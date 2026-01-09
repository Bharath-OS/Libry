import 'package:flutter/foundation.dart'; // Added for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libry/features/auth/view_models/user_viewmodel.dart';
import 'package:libry/features/issues/data/service/issue_records_db.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:libry/features/members/data/model/members_model.dart';
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
import 'package:path_provider/path_provider.dart' as path_provider;

import 'features/books/data/model/books_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for permanent storage
  if (kIsWeb) {
    await Hive.initFlutter(); // No path needed for web, it uses IndexedDB
  } else {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
  }

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());
  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(MemberModelAdapter());

  userDataBoxNew = await Hive.openBox<UserModel>('users');
  statusBox = await Hive.openBox("status");
  await Hive.openBox<BookModel>('books');

  await IssueDBHive.initIssueBox();
  await SettingsService.instance.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
          ChangeNotifierProvider<BookViewModel>(create: (_) => BookViewModel()),
          ChangeNotifierProvider<SettingsViewModel>(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider<IssueViewModel>(create: (_) => IssueViewModel()),
          ChangeNotifierProvider<MembersViewModel>(
            create: (_) => MembersViewModel(),
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
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child) {
        return MaterialApp(
          theme: CustomTheme.myTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      }
    );
  }
}
