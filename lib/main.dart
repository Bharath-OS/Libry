import 'package:flutter/material.dart';
import 'package:libry/features/auth/view_models/user_viewmodel.dart';
import 'package:libry/features/issues/data/service/issue_records_db.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:libry/features/settings/data/service/settings_service.dart';
import 'package:libry/features/settings/viewmodel/settings_viewmodel.dart';
import 'core/themes/styles.dart';
import 'features/splash/splash.dart';
import 'features/issues/data/model/issue_records_model.dart';
import 'features/auth/data/model/user_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());

  userDataBoxNew = await Hive.openBox<UserModel>('users');
  statusBox = await Hive.openBox("status");

  await IssueDBHive.initIssueBox();
  await SettingsService.instance.init();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
          ChangeNotifierProvider<BookViewModel>(create: (_) => BookViewModel()),
          ChangeNotifierProvider<SettingsViewModel>(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider<IssueProvider>(create: (_) => IssueProvider()..init()),
          ChangeNotifierProvider<MembersProvider>(
            create: (context) => MembersProvider(),
          ),
        ],
        child: LibryApp(),
      ),
    );
  });
}

class LibryApp extends StatelessWidget {
  const LibryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.myTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
