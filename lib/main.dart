import 'package:flutter/material.dart';
import 'package:libry/database/genre_db.dart';
import 'package:libry/database/issue_records_db.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/provider/genre_provider.dart';
import 'package:libry/provider/issue_provider.dart';
import 'package:libry/provider/language_provider.dart';
import 'package:libry/provider/members_provider.dart';
import 'Screens/splash.dart';
import 'Themes/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'database/language_db.dart';
import 'models/issue_records_model.dart';
import 'features/auth/data/model/user_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());

  genreBox = await Hive.openBox<String>('genre');
  languageBox = await Hive.openBox<String>('language');
  userDataBoxNew = await Hive.openBox<User>('users');
  statusBox = await Hive.openBox("status");

  await IssueDBHive.initIssueBox();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<BookViewModel>(create: (_) => BookViewModel()),
          ChangeNotifierProvider<GenreProvider>(create: (_) => GenreProvider()),
          ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
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
