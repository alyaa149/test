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

import '../pagesWorker/home.dart';


class WorkerRequest extends StatefulWidget {
//  const WorkerRequest({Key? key}) : super(key: key);

  final String email;
  final String firstName;
  final String lastName;
  final bool isUser;
  final String phoneNumber;
  final String password;
  final String imageUrl;
  WorkerRequest(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.isUser,
      required this.phoneNumber,
      required this.password,
      required this.imageUrl});
  @override
  _WorkerRequestState createState() => _WorkerRequestState();
}

class _WorkerRequestState extends State<WorkerRequest> {
  bool isAvailable24H = false;
  bool _isSendingRequest = false;
  String? _selectedCategoryE;
  String? _selectedCategoryC;

  List<String> cities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Shubra El-Kheima',
    'Port Said',
    'Suez',
    'Luxor',
    'Mansoura',
    'Tanta',
    'Asyut',
    'Ismailia',
    'Fayoum',
    'Zagazig',
    'Aswan',
    'Damietta',
  ];

  String selectedCity = 'Cairo';

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nationalidController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  

  void _submitRequest() async {
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
    };
    // Retrieve the service ID corresponding to the selected category for emergency request
    String? categoryIdE = _selectedCategoryE;
    if (categoryServiceMap.containsKey(_selectedCategoryE)) {
      categoryIdE = categoryServiceMap[_selectedCategoryE]!;
    }

    final String description = _descriptionController.text;
    final String nationalid = _nationalidController.text;

    final dateTimestamp = DateTime.now();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      String? categoryIdC = _selectedCategoryC;
      if (categoryServiceMap.containsKey(_selectedCategoryC)) {
        categoryIdC = categoryServiceMap[_selectedCategoryC]!;
      }

      print('printt ${userCredential.user!.uid}');
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(userCredential.user!.uid)
          .set({
        'email': widget.email ?? '',
        'First Name': widget.firstName ?? '',
        'Last Name': widget.lastName ?? '',
        'PhoneNumber': widget.phoneNumber ?? '',
        'type': 'worker',
        'Rating': 0,
        'about': 'workerr',
        'Pic': widget.imageUrl ?? '',
        'NumberOfRating': 0,
        'Date': dateTimestamp ?? '',
        'Type': description ?? '',
        'Service': categoryIdC ?? '', // Use the dynamically generated service name
        'National-ID': nationalid ?? '',
        'Emergency': isAvailable24H ?? '',
        'City': selectedCity ?? '',
        'isConfirmed': true,
        'reviews': {},
        'packagesId': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('sent successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Failed to send request')),
      );
    }
  }

  void _validateNationalID() {
    if (_nationalidController.text.length != 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('National-ID must be 14 digit'),
        ),
      );
    } else {
      print('National ID: ${_nationalidController.text}');
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
              height: 10,
            ),

// Add Post Fields and Button
            Positioned(
              top: 150,
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
                          minLines: 1,
                          maxLines: 3,
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
                                          _selectedCategoryE = 'Carpenters';
                                          _selectedCategoryC = 'Carpenters';
                                        });
                                        // Set _selectedCategory to 'service1' when 'Carpenters' is selected
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Marble Craftsmen'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC =
                                              'Marble Craftsmen';
                                          _selectedCategoryE =
                                              'Marble Craftsmen';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),

                                    ListTile(
                                      title: Text('Plumbers'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC = 'Plumbers';
                                          _selectedCategoryE = 'Plumbers';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Electricians'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC = 'Electricians';
                                          _selectedCategoryE = 'Electricians';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Painter'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC = 'Painter';
                                          _selectedCategoryE = 'Painter';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Tiler'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC = 'Tiler';
                                          _selectedCategoryE = 'Tiler';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Plastering'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC = 'Plastering';
                                          _selectedCategoryE = 'Plastering';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title:
                                          Text('Appliance Repair Technician'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC =
                                              'Appliance Repair Technician';
                                          _selectedCategoryE =
                                              'Appliance Repair Technician';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Alumetal Technicians'),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryC =
                                              'Alumetal Technicians';
                                          _selectedCategoryE =
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
                              _selectedCategoryE =
                                  _selectedCategoryC ?? 'Categories',
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
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextField(
                              controller: _nationalidController,
                              decoration: InputDecoration(
                                labelText: 'Enter Your National ID card',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                errorText: _nationalidController.text.length >
                                            0 &&
                                        _nationalidController.text.length != 14
                                    ? 'National-ID must be 14 digit'
                                    : null,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Your City :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 400,
                            child: SingleChildScrollView(
                              child: Column(
                                children: cities.map((city) {
                                  return ListTile(
                                    title: Text(city),
                                    onTap: () {
                                      setState(() {
                                        selectedCity = city;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                            selectedCity,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please Enter your National ID card'),
                              ),
                            );
                          } else if (_nationalidController.text.length != 14) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('National-ID must be 14 digit'),
                              ),
                            );
                          } else {
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
