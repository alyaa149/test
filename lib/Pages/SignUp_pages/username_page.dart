import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradd_proj/Pages/SignUp_pages/email_page.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/SignUp_pages/profilePic_page.dart';
import 'package:gradd_proj/Pages/pagesUser/login.dart';
import 'package:gradd_proj/Pages/pagesWorker/login.dart';
import 'package:provider/provider.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({Key? key, required this.isUser}) : super(key: key);
  final bool isUser;

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add form key

  String? _firstNameError;
  String? _lastNameError;
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
                    height: 340,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey, // Assign form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter your first and last name:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Column(
                          children: [
                            TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "First Name",
                                prefixIcon: Icon(Icons.person),
                                errorText: _firstNameError,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "Last Name",
                                prefixIcon: Icon(Icons.person),
                                errorText: _lastNameError,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // Check if fields are empty and set error messages accordingly
                                    _firstNameError = _firstNameController.text.isEmpty ? 'First name cannot be empty' : null;
                                    _lastNameError = _lastNameController.text.isEmpty ? 'Last name cannot be empty' : null;
                                  });

                                  // If both fields are not empty, navigate to the next page
                                  if (_firstNameError == null && _lastNameError == null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePicPage(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          isUser: widget.isUser,
                                        ),
                                        ),
                                      );
                                    } else {
                                      // If fields are not valid, show a snackbar
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFBBA2BF),
                                    fixedSize: Size(120, 50),
                                  ),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
  onTap: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isUser ? Login() : LoginWorker(),
      ),
    );
  },
  child: Text(
    'Already have an account? ${isUser ? 'Login' : 'Login'}',
    style: TextStyle(
      fontFamily: "Raleway",
      fontSize: 15,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    ),
  ),
)
,
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
