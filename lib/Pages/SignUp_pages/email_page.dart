import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/themeNotifier.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/SignUp_pages/password_page.dart';
import 'package:gradd_proj/Pages/SignUp_pages/phoneNo_page.dart';
import 'package:gradd_proj/Pages/SignUp_pages/username_page.dart';
import 'package:gradd_proj/Pages/pagesUser/login.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool isUser;
  EmailPage(
      {required this.firstName, required this.lastName, required this.isUser});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  String email = '';
  final _formKey = GlobalKey<FormState>(); // Define form key

  // void _showErrorSnackBar(String errorMessage) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(errorMessage),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

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
                Center(
                  child: Container(
                    width: 320,
                    height: 290,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Form( // Wrap with Form widget
                      key: _formKey, // Assign form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter your email address',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Navigate to the next page or perform other actions with collected data
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PhoneNumberPage(
                                            firstName: widget.firstName,
                                            lastName: widget.lastName,
                                            email: email,
                                            isUser: widget.isUser,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Show snackbar if form validation fails
                                      // _showErrorSnackBar(
                                      //     'Please enter a valid email address');
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
                                          builder: (context) => Login()),
                                    );
                                  },
                                  child: Text(
                                    'Already have an account? Login',
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
