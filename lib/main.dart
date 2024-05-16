
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradd_proj/Pages/Intro_pages/onboarding_screen.dart';

import 'package:gradd_proj/Pages/pagesWorker/home.dart';
import 'package:gradd_proj/Pages/Subscription_Pages/packagesPage.dart';
import 'package:gradd_proj/Pages/splashscreen.dart';
import 'package:gradd_proj/Pages/welcome.dart';
import 'package:gradd_proj/firebase_options.dart';
import 'package:gradd_proj/wrapper.dart';
import 'package:provider/provider.dart';

import 'Domain/themeNotifier.dart';
import 'Domain/user_provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(), // Provide your ThemeNotifier instance here
        ),
        // Add other providers if needed
        // ChangeNotifierProvider<UserProviderr>(
        //     create: (context) => UserProviderr(UserModel(uid: '', username: '')),
        // )
      ],
      child: const MyApp(),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(), //mtnseesh t7oty el splash screen hena
      // Define named routes for easy navigation
       routes: {
        '/welcome': (context) => Welcome(), // Example route for SignUp widget
        //Add more routes as needed
       },
    );
  }
}
