import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/WokerBottomNavBar.dart';
import 'package:gradd_proj/Pages/SignUp_pages/username_page.dart';
import 'package:gradd_proj/Pages/pagesWorker/home.dart';
//import 'package:gradd_proj/Pages/pagesUser/pagesWorker/signup.dart';

class LoginWorker extends StatelessWidget {
   LoginWorker({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  try {
    // Check if email and password are empty
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      throw FirebaseAuthException(code: 'empty-email-password', message: 'Please enter both email and password.');
    }

    final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BottomNavBarWorker()), // Replace HomeScreen() with your home screen widget
    );

    // Show a dialog prompt for successful login
    // return showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text("Login Successful"),
    //       content: Text("You have successfully logged in."),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text("OK"),
    //         ),
    //       ],
    //     );
    //   },
    // );

  } on FirebaseAuthException catch (e) {
    // Handle login errors
    String errorMessage = 'Failed to Sign in';
    if (e.code == 'empty-email-password') {
      errorMessage = 'Please enter both email and password.';
    } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      errorMessage = 'Invalid email or password.';
    }
    
    // Show dialog with error message
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
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background Image
              //purple foreground
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
                          'Login As Worker',
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
                            'Email:',
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
                            labelText: "Email",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Or Login with ',
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/facebook.svg',
                              width: 30,
                              height: 30,
                              color: Color.fromARGB(255, 173, 148, 177),
                            ),
                            SvgPicture.asset(
                              'assets/images/google.svg',
                              width: 30,
                              height: 30,
                              color: Color.fromARGB(255, 173, 148, 177),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
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
                        Row(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UsernamePage(isUser: false,)),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
