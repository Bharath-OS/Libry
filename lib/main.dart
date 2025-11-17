import 'package:flutter/material.dart';
import 'package:libry/provider/book_provider.dart';
import 'Screens/splash.dart';
import 'Themes/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user_model.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  userDataBox = await Hive.openBox<User>('users');
  statusBox = await Hive.openBox("status");

  // Run the app
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider<BookProvider>(create: (_) => BookProvider()),
  ],child: LibryApp()));
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
