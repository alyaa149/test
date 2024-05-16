import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/bottom.dart';
import 'package:gradd_proj/Domain/user_provider.dart';

import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'workerRequest.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isUser;
  final File? imageFile;

  PasswordPage(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.isUser,
      required this.imageFile});

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

  static const String _defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/userlogo.png?alt=media&token=54fca04d-b125-4db4-9cf4-d96daaef1041';

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

    Future<String?> _uploadImageToFirebaseStorage(
        File? imageFile, bool isUser) async {
      try {
        if (imageFile == null) {
          // Use a default image if no image file is provided
          return _defaultImageUrl;
        }

        if (!imageFile.existsSync()) {
          throw Exception("Image file does not exist.");
        }

        final String folderName = isUser ? 'Users' : 'Workers';
        final firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'Profile Pictures/$folderName/${DateTime.now().millisecondsSinceEpoch}');

        await ref.putFile(imageFile);

        final imageUrl = await ref.getDownloadURL();
        return imageUrl; // Return the imageURL
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
        return null;
      }
    }

    // Reset error messages
    setState(() {
      passwordError = '';
      confirmPasswordError = '';
      isLoading = true;
    });

    try {
      // Upload image to Firebase Storage
      String? imageUrl =
          await _uploadImageToFirebaseStorage(widget.imageFile, widget.isUser);

      // If the user is a regular user, store additional user information in Firestore
      if (widget.isUser) {
        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: password,
        );
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': widget.email,
          'First Name': widget.firstName ,
          'Last Name': widget.lastName,
          'PhoneNumber': widget.phoneNumber,
          'type': 'user',
          'favorits': [],
          'Rating': 5.0,
          'Pic': imageUrl ?? _defaultImageUrl,
          'NumberOfRating': 0,
          'reviews': {},
        });
        // Navigate to the appropriate screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBarUser(),
          ),
        );
        showDialog(
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
      } else {
        // Navigate to WorkerRequest page if it's not a user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerRequest(
              email: widget.email,
              firstName: widget.firstName,
              lastName: widget.lastName,
              isUser: widget.isUser,
              phoneNumber: widget.phoneNumber,
              password: password,
              imageUrl: imageUrl ?? _defaultImageUrl,
            ),
          ),
        );
        return;
      }
    } catch (e) {
      // Registration failed, display error message
      // Check if the widget is mounted before showing the dialog
      if (mounted) {
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
                            onPressed: () {
                              _registerWithEmailAndPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFBBA2BF),
                              fixedSize: Size(120, 50),
                            ),
                            child: Text(
                              'Next',
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
