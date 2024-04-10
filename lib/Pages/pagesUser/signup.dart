// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'login.dart';

// class SignUpUser extends StatelessWidget {
//   final bool isUser; // Add this variable to receive the isUser value
//   SignUpUser({Key? key, required this.isUser});

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController(); // Add TextEditingController for username

//   get sha256 => null;

//   Future<void> _registerWithEmailAndPassword(
//       String email, String password, String username, BuildContext context) async {
//     try {
//       UserCredential userCredential =
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Send email verification
//       await userCredential.user!.sendEmailVerification();

//       // Determine the collection name based on the value of isUser
//       String collectionName = isUser ? 'users' : 'workers';

//       // Hash the password before storing it
//       String hashedPassword = hashPassword(password);

//       // Write email and password to the appropriate collection in Cloud Firestore
//       await FirebaseFirestore.instance
//           .collection(collectionName)
//           .doc(userCredential.user!.uid)
//           .set({
//         'email': email,
//         'username' : username,
//         'password': password,
//         'type': isUser ? 'user' : 'worker',
//              'favorites': [],
//         'PhoneNumber': '',
//         'Pic': '',
//         'Rating':5.0,
//         'First Name': "",
//          'Last Name': ""
//       });

//             Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 Login()), // Replace Login() with your login screen widget
//       );

//       return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Sign Up Successful"),
//             content: Text(
//                 "You have successfully signed up. Please verify your email."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       // Registration failed, display error message
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text(e.toString()),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }



//   String hashPassword(String password) {
//     try {
//       var bytes = utf8.encode(password); // Encode the password as UTF-8
//       if (bytes.isNotEmpty) {
//         var digest = sha256.convert(bytes); // Generate the SHA-256 hash
//         return digest.toString(); // Return the hashed password as a string
//       } else {
//         throw Exception("Password cannot be empty");
//       }
//     } catch (e) {
//       print("Error hashing password: $e");
//       return ''; // Return empty string in case of error
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     String email = '';
//     String password = '';
//     String confirmPassword = ''; // Add confirmPassword variable
//     String username = '';
//     return SafeArea(
//       child: Scaffold(
//         body: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 left: 0,
//                 child: SvgPicture.asset(
//                   "assets/images/Rec that Contain menu icon &profile1.svg",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 left: 3,
//                 top: 9,
//                 child: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                       size: 40,
//                     )),
//               ),
//               Positioned(
//                 top: 15,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: SvgPicture.asset("assets/images/MR. House.svg"),
//                 ),
//               ),
//               Positioned(
//                 right: 15,
//                 top: 15,
//                 child: CircleAvatar(
//                   radius: 25,
//                   backgroundImage: AssetImage('assets/images/FixxIt.png'),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   width: 320,
//                   height: 500,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F3F3),
//                     borderRadius: BorderRadius.circular(20.0),
//                     border: Border.all(
//                       color: Colors.black26,
//                       width: 2,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Sign Up As User',
//                           style: TextStyle(
//                             fontFamily: "Quando",
//                             color: Color.fromARGB(255, 173, 148, 177),
//                             fontSize: 24,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         TextField(
//                           onChanged: (value) {
//                             email = value; // Capture email input
//                           },
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             prefixIcon: Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           onChanged: (value) {
//                             username = value; // Capture username input
//                           },
//                           decoration: InputDecoration(
//                             labelText: "Username",
//                             prefixIcon: Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           onChanged: (value) {
//                             password = value; // Capture password input
//                           },
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             prefixIcon: Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           onChanged: (value) {
//                             confirmPassword =
//                                 value; // Capture confirm password input
//                           },
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Confirm Password",
//                             prefixIcon: Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (password == confirmPassword) {
//                               _registerWithEmailAndPassword(
//                                   email, password, username, context);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Passwords do not match'),
//                                   duration: Duration(seconds: 3),
//                                 ),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFFBBA2BF),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 77,
//                               vertical: 13,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(27),
//                             ),
//                           ),
//                           child: Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.grey[850],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 5,),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => Login()),
//                             );
//                           },
//                           child: Text(
//                             'Already have an account? Login',
//                             style: TextStyle(
//                               fontFamily: "Raleway",
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         // Sign up with Facebook or Google
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Or Sign up with ',
//                               style: TextStyle(
//                                 fontFamily: "Raleway",
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async{
//                                 try{
//                                   final LoginResult result = await FacebookAuth.instance.login();

//                                   if(result != null){
//                                     final userData = await FacebookAuth.instance.getUserData();
//                                     print('Facebook Sign-up successful: $userData');
//                                   }
//                                   else{
//                                     print('Facebook sign-up faild');
//                                   }
//                                 } catch (e) {
//                                   print('error signing up : $e');
//                                 }
//                               },
//                               child: SvgPicture.asset(
//                                 'assets/images/facebook.svg',
//                                 width: 30,
//                                 height: 30,
//                                 color: Color.fromARGB(255, 173, 148, 177),
//                               ),
//                             ),
//                             SvgPicture.asset(
//                               'assets/images/google.svg',
//                               width: 30,
//                               height: 30,
//                               color: Color.fromARGB(255, 173, 148, 177),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }