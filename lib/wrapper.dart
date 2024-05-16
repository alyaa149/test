// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Domain/WokerBottomNavBar.dart';
import 'package:gradd_proj/Domain/bottom.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/login.dart';
import 'package:gradd_proj/Pages/pagesWorker/home.dart';
import 'package:gradd_proj/Pages/splashscreen.dart';
import 'package:gradd_proj/Pages/welcome.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('print here');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          } else {
            if (snapshot.data == null) {
              print('print here   null');
              return Welcome();
            } else {
              // Get the current user
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      return Center(child: Text("Error"));
                    } else {
                      if (userSnapshot.data!.exists) {
                        print('User exists in the users collection');
                        Provider.of<UserProvider>(context, listen: false).setIsUser(true);
                        print('print here  user');
                        return BottomNavBarUser();
                      } else {
                        // If the user does not exist in the 'users' collection, check the 'workers' collection
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('workers').doc(user.uid).get(),
                          builder: (context, workerSnapshot) {
                            if (workerSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (workerSnapshot.hasError) {
                              return Center(child: Text("Error"));
                            } else {
                              if (workerSnapshot.data!.exists) {
                                print('User exists in the workers collection');
                                Provider.of<UserProvider>(context, listen: false).setIsUser(false);
                                print('print here worker');
                                return BottomNavBarWorker();
                              } else {
                                print('User does not exist in either collection');
                                return Center(child: Text("User does not exist"));
                              }
                            }
                          },
                        );
                      }
                    }
                  },
                );
              } else {
                // Handle case where user is null
                return Center(child: Text("User is null"));
              }
            }
          }
        },
      ),
    );
  }
}
