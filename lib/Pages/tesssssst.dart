// ignore_for_file: prefer_const_constructors, sort_child_properties_last


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  testState createState() => testState();
}

class testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundImage: 
          NetworkImage("https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518",scale: 20),
        ) 
        
        
        ),
    );
  }


}
