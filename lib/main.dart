// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_proj_on_github/Domain/themeNotifier.dart';

import 'Domain/user_provider.dart';
import 'Pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// Color(0xFFBBA2BF)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ],
      child:  Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child){
          return MaterialApp(
            theme: ThemeData(
              brightness: themeNotifier.isDarkModeEnabled
                  ? Brightness.dark
                  : Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );

  }
}
