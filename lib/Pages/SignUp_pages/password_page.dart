// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Pages/SignUp_pages/workerRequest.dart';
import 'package:provider/provider.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Domain/WokerBottomNavBar.dart';
import 'package:gradd_proj/Domain/bottom.dart';
import 'package:gradd_proj/Pages/Welcome.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isUser;

  PasswordPage({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.isUser,
  });

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String password = '';
  String confirmPassword = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String passwordError = '';
  String confirmPasswordError = '';
  bool showDel = false;

  get sha256 => null;

 void toggleLoadingAnimation() {
  if (mounted) {
    setState(() {
      showDel = !showDel;
    });
  }
}


  Future<void> _registerWithEmailAndPassword() async {
    // Validations for password length and matching passwords
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password cannot be empty.';
        confirmPasswordError = '';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters long.';
        confirmPasswordError = '';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match.';
        passwordError = '';
      });
      return;
    }

    // Reset error messages
    setState(() {
      passwordError = '';
      confirmPasswordError = '';
      isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: password,
      );

      // Store additional user information in Firestore
      final String collectionName = widget.isUser ? 'users' : 'workers';
      String hashedPassword = hashPassword(password);
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userCredential.user!.uid)
          .set({
        'email': widget.email,
        'First Name': widget.firstName,
        'Last Name': widget.lastName,
        'PhoneNumber': widget.phoneNumber,
        'type': widget.isUser ? 'user' : 'worker',
        'favorits': [],
        'Rating': 0,
        'about': 'userrrrr',
        'Pic': '',
        'NumberOfRating' : 0,
        'reviews': {},

        'packagesId' :[],

      });

      // Navigate to Welcome page after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              widget.isUser ? BottomNavBarUser() : BottomNavBarWorker()
              // WorkerRequest(email: widget.email, firstName: widget.firstName, lastName: '', isUser: widget.isUser, phoneNumber: '',),
        ),
      );

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Successful"),
            content: Text(
                "You have successfully signed up. Please verify your email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Registration failed, display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  String hashPassword(String password) {
    try {
      var bytes = utf8.encode(password); // Encode the password as UTF-8
      if (bytes.isNotEmpty) {
        var digest = sha256.convert(bytes); // Generate the SHA-256 hash
        return digest.toString(); // Return the hashed password as a string
      } else {
        throw Exception("Password cannot be empty");
      }
    } catch (e) {
      print("Error hashing password: $e");
      return ''; // Return empty string in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUser = Provider.of<UserProvider>(context).isUser;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: 700,
            height: 700,
            child: Stack(
              children: [
                // Background Image
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: SvgPicture.asset(
                    "assets/images/Rec that Contain menu icon &profile1.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                // App Title
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SvgPicture.asset("assets/images/MR. House.svg"),
                  ),
                ),
                // App Icon
                Positioned(
                  right: 15,
                  top: 15,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/FixxIt.png'),
                  ),
                ),
                // Centered Rectangle with User Inputs
                Center(
                  child: Container(
                    width: 320,
                    height: 360,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a password:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          onChanged: (value) {
                            password = value;
                            setState(() {
                              passwordError = '';
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        if (passwordError.isNotEmpty)
                          Container(
                            padding: EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              passwordError,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        SizedBox(height: 20.0),
                        TextField(
                          onChanged: (value) {
                            confirmPassword = value;
                            setState(() {
                              confirmPasswordError = '';
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Confirm Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        if (confirmPasswordError.isNotEmpty)
                          Container(
                            padding: EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              confirmPasswordError,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        SizedBox(height: 20.0),
                        Center(
                            child: ElevatedButton(
                       onPressed: () async {
  if (mounted) {
    setState(() {
      toggleLoadingAnimation(); // Start loading animation
    });
  }

  // Perform your registration or any other operation here
  await _registerWithEmailAndPassword();

  if (mounted) {
    setState(() {
      toggleLoadingAnimation(); // Stop loading animation
    });
  }
},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFBBA2BF),
                            fixedSize: Size(120, 50),
                          ),
                          child: Text(
                            'Finish',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
