import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradd_proj/Domain/bottom.dart';
import 'package:gradd_proj/Pages/SignUp_pages/username_page.dart';
import 'package:gradd_proj/Pages/pagesUser/signup.dart';
import 'package:gradd_proj/Pages/tired.dart';
import 'BNavBarPages/home.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  try {
    // Check if email or phone number and password are empty
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      throw FirebaseAuthException(
          code: 'empty-email-password',
          message: 'Please enter both email and password');
    }

    if (_emailController.text.contains('@')) {
      // Email authentication
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      // Phone number authentication
      // Concatenate '@domain.com' to the phone number
      final phoneNumberWithEmail =
          '${_emailController.text.trim()}@domain.com';
      // Perform phone number authentication using Firebase
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: phoneNumberWithEmail,
        password: _passwordController.text.trim(),
      );
    }
    
    // Navigate to home screen if login is successful
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BottomNavBarUser()), // Replace HomeScreen() with your home screen widget
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Successful"),
          content: Text("You have successfully logged in."),
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

  } on FirebaseAuthException catch (e) {
    // Handle login errors
    String errorMessage = 'Failed to Sign in';
    if (e.code == 'empty-email-password') {
      errorMessage = 'Please enter both email and password.';
    } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      errorMessage = 'Invalid email or password.';
    }
    // Handle login errors, show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(errorMessage),
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


  @override
  Widget build(BuildContext context) {
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
                    backgroundImage:
                    AssetImage('assets/images/FixxIt.png'),
                  ),
                ),
                // Centered Rectangle with User Inputs
                Center(
                  child: Container(
                    width: 320,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login As User',
                            style: TextStyle(
                              fontFamily: "Quando",
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email or Phone Number:',
                              style: TextStyle(
                                fontFamily: "Quando",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email or Phone Number",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password:',
                              style: TextStyle(
                                fontFamily: "Quando",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              _signInWithEmailAndPassword(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFBBA2BF),
                              padding: EdgeInsets.symmetric(
                                horizontal: 77,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[850],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    //Navigate to sign up screen
                                    Example: Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UsernamePage(isUser: true)),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontFamily: "Raleway",
                                      color: Color.fromARGB(255, 173, 148, 177),
                                      fontSize: 17,
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
