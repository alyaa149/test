import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Domain/WokerBottomNavBar.dart';
import '../pagesWorker/home.dart';


class WorkerRequest extends StatefulWidget {
//  const WorkerRequest({Key? key}) : super(key: key);

 final String email;
 final String firstName;
 final String lastName;
 final bool isUser;
 final String phoneNumber;

 WorkerRequest(
     {required this.email,
     required this.firstName,
     required this.lastName,
     required this.isUser,
     required this.phoneNumber});
  @override
  _WorkerRequestState createState() => _WorkerRequestState();
}

class _WorkerRequestState extends State<WorkerRequest> {
  bool isAvailable24H = false;
  bool _isSendingRequest = false;
  String? _pickedImagePath;
  String? _pickedImagePath1;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nationalidController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  //import firebasestorage package
  void _submitRequest() async {
    // Stop execution if National ID card is not uploaded

    final Map<String, String> categoryServiceMap = {
      'Carpenters': 'service5',
      'Marble Craftsmen': 'service3',
      'Plumbers': 'service8',
      'Electricians': 'service6',
      'Painter': 'service7',
      'Tiler': 'service9',
      'Plastering': 'service4',
      'Appliance Repair Technician': 'service2',
      'Alumetal Technicians': 'service1',
      // Add more categories and their corresponding service IDs as needed
    };
    String? categoryId = _selectedCategory;
    if (categoryServiceMap.containsKey(_selectedCategory)) {
      categoryId = categoryServiceMap[_selectedCategory]!;
    }
    // final String address = _addressController.text;
    final String description = _descriptionController.text;
    final String nationalid = _nationalidController.text;

    final dateTimestamp = DateTime.now();
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final Map<String, dynamic> requestData = {
      'Date': dateTimestamp,     
      'Type': description,
      'Service': categoryId,
      'National-ID': nationalid,
      'Emergency': isAvailable24H,
      'user': currentUserID,
      'worker': FirebaseAuth.instance.currentUser!.uid,
      'email': widget.email,
      'First Name': widget.firstName,
      'Last Name': widget.lastName,
      'PhoneNumber': widget.phoneNumber,
      'type': widget.isUser ? 'user' : 'worker',
      'favorits': [],
      'Rating': 0,
      'NumberOfRating' :0,
      'reviews' : {},
      'Pic': '',
      'packagesId' :[],
      'City':"al"
    };
    try {
      await FirebaseFirestore.instance.collection('workers').add(
            requestData,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send request')),
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
          child: Stack(children: [
            //purple foreground
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: SvgPicture.asset(
                "assets/images/foregroundPurpleSmall.svg",
                fit: BoxFit.cover,
              ),
            ),

            //Mr. house word
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset("assets/images/MR. House.svg"),
              ),
            ),

            SizedBox(
              height: 30,
            ),

// Add Post Fields and Button
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Describe Yourself.......',
                            border: InputBorder.none,
                          ),
                          minLines: 3,
                          maxLines: 5,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Describe Yourself";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Carpenters'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'Carpenters';
                                        });
                                        // Set _selectedCategory to 'service1' when 'Carpenters' is selected
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Marble Craftsmen'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory =
                                              'Marble Craftsmen';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Plumbers'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'Plumbers';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('electricians'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'electricians';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('painter'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'painter';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('tiler'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'tiler';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Plastering'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'Plastering';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title:
                                          Text('Appliance Repair Technician'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory =
                                              'Appliance Repair Technician';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Alumetal Technicians'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory =
                                              'Alumetal Technicians';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    // Add similar code for other categories
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _selectedCategory ?? 'Categories',
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0), // تحديد التباعد
                            child: TextField(
                              controller: _nationalidController,
                              decoration: InputDecoration(
                                labelText: 'Enter Your National ID card',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: isAvailable24H
                              ? Icon(Icons.check_box)
                              : Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            setState(() {
                              isAvailable24H = !isAvailable24H;
                            });
                          },
                        ),
                        Text(
                          'Are You Available 24H',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(234, 0, 0, 0),
                          backgroundColor: const Color(0xFFBBA2BF),
                        ),
                        child: const Text(
                          'Send a Request',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          if (_nationalidController.text.isEmpty) {
                            // Show validation message if National ID card is not entered
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please Enter your National ID card'),
                              ),
                            );
                          } else {
                            // Proceed with submitting the request if National ID card is entered
                            _submitRequest();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeWorker(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  //post layer
  Widget FriendPost({
    required String proName,
  }) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        proName,
                        style: TextStyle(
                          fontSize: 30.0,
                          //  fontWeight: FontWeight.bold,
                          height: 3.0,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    SizedBox(height: 45.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Function to simulate sending request
  void _sendRequest() {
    setState(() {
      _isSendingRequest = true;
    });
    // Simulating a response after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isSendingRequest = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBarWorker()),
      );
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
