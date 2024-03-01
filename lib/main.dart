 // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grad_proj/Pages/pagesUser/BNavBarPages/favorites.dart';
import 'package:grad_proj/Pages/pagesUser/BNavBarPages/responds.dart';
import 'package:grad_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';
import 'package:grad_proj/Pages/pagesUser/emergencyResponds.dart';
import 'package:grad_proj/Pages/pagesUser/history.dart';
import 'package:grad_proj/Pages/pagesUser/login.dart';
import 'package:grad_proj/Pages/pagesUser/reqCategory.dart';
import 'package:grad_proj/Pages/pagesUser/signup.dart';
import 'package:grad_proj/Pages/pagesUser/workerReview.dart';
import 'package:grad_proj/Pages/pagesWorker/History.dart';
import 'package:grad_proj/Pages/pagesWorker/home.dart';
import 'package:grad_proj/Pages/pagesWorker/login.dart';
import 'package:grad_proj/Pages/pagesWorker/signup.dart';


void main() {
  runApp(const MyApp());
}

// Color(0xFFBBA2BF)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    //  initialRoute: "/historyUser",
      home:  ReqCategory(),
      routes: {
     
        //"/login": (context) => const Login(),
       
      
       //"/nav_bar": (context) => Bottom_nav_bar(),
      },
    );
  }
}
