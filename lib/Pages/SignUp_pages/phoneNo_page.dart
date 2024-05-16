import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/SignUp_pages/password_page.dart';
import 'package:provider/provider.dart';

class PhoneNumberPage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final bool isUser;
  final File? imageFile;

  PhoneNumberPage(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.isUser,
      required this.imageFile});

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  late String phoneNumber = ''; // Initialize with an empty string
  final _formKey = GlobalKey<FormState>();
  String phoneNumberError = '';

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
                    height: 260,
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
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter your phone number:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              SizedBox(width: 10.0),
                              Flexible(
                                child: TextFormField(
                                  onChanged: (value) {
                                    phoneNumber = value;
                                    setState(() {
                                      phoneNumberError = '';
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  maxLength:
                                      11, // Adjust as per your country's phone number length
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone number cannot be empty';
                                    }
                                    if (value.length != 11 ||
                                        !value.startsWith('01')) {
                                      return 'Please enter a valid phone number starting with 01';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: "Phone Number",
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Navigate to the next page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PasswordPage(
                                        email: widget.email,
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        phoneNumber: '+2$phoneNumber',
                                        isUser: widget.isUser,
                                        imageFile: widget.imageFile,
                                      ),
                                    ),
                                  );
                                }
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}