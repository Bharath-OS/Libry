import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libry/features/auth/view/profile.dart';
import 'package:libry/features/home/views/home.dart';
import 'package:provider/provider.dart';
import '../../database/genre_db.dart';
import '../../database/issue_records_db.dart';
import '../../database/language_db.dart';
import '../../features/auth/data/model/user_model.dart';
import '../../features/books/viewmodel/book_provider.dart';
import '../../models/issue_records_model.dart';
import '../../provider/genre_provider.dart';
import '../../provider/issue_provider.dart';
import '../../provider/language_provider.dart';
import '../../provider/members_provider.dart';

void main(List<String> path) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());

  genreBox = await Hive.openBox<String>('genre');
  languageBox = await Hive.openBox<String>('language');
  userDataBoxNew = await Hive.openBox<UserModel>('users');
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
        child: path == 'home'? HomeScreen() : ProfileScreen(),
      ),
    );
  });
}