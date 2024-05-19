import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/SignUp_pages/password_page.dart';
import 'package:gradd_proj/Pages/SignUp_pages/phoneNo_page.dart';
import 'package:gradd_proj/Pages/pagesUser/login.dart';
import 'package:gradd_proj/Pages/pagesWorker/login.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool isUser;
  final File? imageFile;
  EmailPage(
      {required this.firstName,
      required this.lastName,
      required this.isUser,
      required this.imageFile});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  String email = '';
  final _formKey = GlobalKey<FormState>(); // Define form key
  bool signUpWithEmail = true; // Default sign-up method is with email

  @override
  Widget build(BuildContext context) {
    bool isUser = Provider.of<UserProvider>(context).isUser;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: 700,
            height: 800,
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
                Center(
                  child: Container(
                    width: 320,
                    height: 330,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      // Wrap with Form widget
                      key: _formKey, // Assign form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter your ${signUpWithEmail ? 'email' : 'phone number'}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          signUpWithEmail
                              ? TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  // Remove validator to allow any input
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Email",
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                )
                              : TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  // Remove validator to allow any input
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Phone Number",
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                ),
                          SizedBox(height: 20.0),
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (signUpWithEmail) {
                                        // Navigate to the next page for email sign-up
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PhoneNumberPage(
                                              firstName: widget.firstName,
                                              lastName: widget.lastName,
                                              email: email,
                                              isUser: widget.isUser,
                                              imageFile: widget.imageFile,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Combine phone number with domain and navigate to the next page
                                        String phoneNumberWithEmail =
                                            email + '@domain.com';
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PasswordPage(
                                              firstName: widget.firstName,
                                              lastName: widget.lastName,
                                              email: phoneNumberWithEmail,
                                              isUser: widget.isUser,
                                              phoneNumber: email,
                                              imageFile: widget.imageFile,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFBBA2BF),
                                    fixedSize: Size(120, 50),
                                  ),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            isUser ? Login() : LoginWorker(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Already have an account? ${isUser ? 'Login' : 'Login as Worker'}',
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      signUpWithEmail = !signUpWithEmail;
                                    });
                                  },
                                  child: Text(
                                    signUpWithEmail
                                        ? 'Or Sign up with phone number'
                                        : 'Or Sign up with email',
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
