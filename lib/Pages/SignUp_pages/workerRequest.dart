import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradd_proj/Pages/welcome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pagesWorker/home.dart';

class WorkerRequest extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final bool isUser;
  final String phoneNumber;
  final String password;
  final String imageUrl;

  WorkerRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isUser,
    required this.phoneNumber,
    required this.password,
    required this.imageUrl,
  });

  @override
  _WorkerRequestState createState() => _WorkerRequestState();
}

class _WorkerRequestState extends State<WorkerRequest> {
  bool isAvailable24H = false;
  bool _isSendingRequest = false;
  String? _selectedCategoryE = 'Carpenters';
  String? _selectedCategoryC;
  bool _showNationalIdLoading = false;
  bool _showFeeshImageLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  late File _pickedImage;
  String? _pickedImagePath;
  String? _pickedImagePath2;
  String imageType = '';
  File? _selectedImage;
  bool _uploadingImage = false;
  double _nationalIdUploadProgress = 0.0;
  double _FeeshProgress = 0.0;
  String nationalIdUrl = '';
  String feeshUrl = '';

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
  final TextEditingController _refNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCategory;

  Future<void> _handleImageSelectionAndUpload() async {
  final nationalIdImage = await _imagePicker.pickImage(source: ImageSource.gallery);
  final feeshImage = await _imagePicker.pickImage(source: ImageSource.gallery);

  if (nationalIdImage != null && feeshImage != null) {
    setState(() {
      _uploadingImage = true; // Set uploading status to true
    });

    final nationalIdFile = File(nationalIdImage.path);
    final feeshFile = File(feeshImage.path);

    final imageUrls = await _uploadImages(nationalIdFile, feeshFile);

    if (imageUrls['nationalIdUrl'] != '' && imageUrls['feeshUrl'] != '') {
      setState(() {
        _pickedImagePath = imageUrls['nationalIdUrl'];
        _pickedImagePath2 = imageUrls['feeshUrl'];
        _nationalIdUploadProgress = 1.0;
        _FeeshProgress = 1.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );
      // Continue with post creation or other actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload images')),
      );
    }

    setState(() {
      _uploadingImage = false; // Set uploading status to false after upload completes
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No images selected')),
    );
  }
}

  // Widget _buildSelectedImage(String imageType) {
  //   if (imageType == 'National ID') {
  //     return _pickedImage != null ? Image.file(_pickedImage!) : SizedBox();
  //   } else if (imageType == 'Feesh Image') {
  //     return _pickedImage != null ? Image.file(_pickedImage!) : SizedBox();
  //   }
  //   return SizedBox();
  // }

  Future<Map<String, String>> _uploadImages(File nationalIdImage, File feeshImage) async {
  try {
    // Define paths for both images
    String nationalIdPath = 'worker_Data/N_ID/${DateTime.now().millisecondsSinceEpoch}.jpg';
    String feeshPath = 'worker_Data/Feesh/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload National ID image
    final nationalIdRef = firebase_storage.FirebaseStorage.instance.ref().child(nationalIdPath);
    await nationalIdRef.putFile(nationalIdImage);
    final nationalIdUrl = await nationalIdRef.getDownloadURL();

    // Upload Feesh image
    final feeshRef = firebase_storage.FirebaseStorage.instance.ref().child(feeshPath);
    await feeshRef.putFile(feeshImage);
    final feeshUrl = await feeshRef.getDownloadURL();

    _pickedImagePath = nationalIdUrl;
    _pickedImagePath2 = feeshUrl;

    // Return both URLs as a Map
    return {
      'nationalIdUrl': nationalIdUrl,
      'feeshUrl': feeshUrl,
    };
  } catch (error) {
    print('Error uploading images: $error');
    return {
      'nationalIdUrl': '',
      'feeshUrl': '',
    };
  }
}


  void waitingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              'Wait until you receive an email confirming your request!',
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Quantico",
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Welcome(),
                    ),
                  );
                },
                child: Text(
                  'Ok',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
    String? categoryIdE = _selectedCategoryE;
    if (categoryServiceMap.containsKey(_selectedCategoryE)) {
      categoryIdE = categoryServiceMap[_selectedCategoryE]!;
    }

    final String description = _descriptionController.text;
    final String nationalid = _nationalidController.text;
    final String refNumber = _refNumberController.text;
    final nationalUrl = _pickedImagePath ?? '';
    final feeshUrl = _pickedImagePath2 ?? '';

    final dateTimestamp = DateTime.now();

    try {
      String? categoryIdC = _selectedCategoryC;
      if (categoryServiceMap.containsKey(_selectedCategoryC)) {
        categoryIdC = categoryServiceMap[_selectedCategoryC]!;
      }

      await FirebaseFirestore.instance.collection('workerRequests').doc().set({
        'email': widget.email,
        'First Name': widget.firstName,
        'Last Name': widget.lastName,
        'PhoneNumber': widget.phoneNumber,
        'about': 'worker',
        'Pic': widget.imageUrl,
        'Date': dateTimestamp,
        'Type': description,
        'Service': categoryIdC,
        'National-ID': nationalid,
        'Emergency': isAvailable24H,
        'City': selectedCity,
        'isConfirmed': 'pending',
        'password': widget.password,
        'Reference Number': refNumber,
        'National-ID Pic': nationalUrl,
        'Feesh Pic': feeshUrl,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send request')),
      );
    }
  }

  void _validateNationalID() {
    if (_nationalidController.text.length != 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('National-ID must be 14 digits'),
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                //purple foreground
                Positioned(
                  top: -20,
                  right: 0,
                  left: 0,
                  child: SvgPicture.asset(
                    "assets/images/foregroundPurpleSmall.svg",
                    fit: BoxFit.cover,
                  ),
                ),

                //Mr. house word
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SvgPicture.asset("assets/images/MR. House.svg"),
                  ),
                ),
                // Add Post Fields and Button
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                                                  _selectedCategoryE =
                                                      'Carpenters';
                                                  _selectedCategoryC =
                                                      'Carpenters';
                                                });
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
                                                  _selectedCategoryC =
                                                      'Plumbers';
                                                  _selectedCategoryE =
                                                      'Plumbers';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: Text('Electricians'),
                                              onTap: () {
                                                setState(() {
                                                  _selectedCategoryC =
                                                      'Electricians';
                                                  _selectedCategoryE =
                                                      'Electricians';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: Text('Painter'),
                                              onTap: () {
                                                setState(() {
                                                  _selectedCategoryC =
                                                      'Painter';
                                                  _selectedCategoryE =
                                                      'Painter';
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
                                                  _selectedCategoryC =
                                                      'Plastering';
                                                  _selectedCategoryE =
                                                      'Plastering';
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: Text(
                                                  'Appliance Repair Technician'),
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
                                              title:
                                                  Text('Alumetal Technicians'),
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
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 70,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    _selectedCategoryE ??
                                        'Select a Category', // Show selected category or default text
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DropdownButton<String>(
                                value: selectedCity,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCity = newValue!;
                                  });
                                },
                                items: cities.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: 'Describe Yourself.......',
                                border: InputBorder.none,
                              ),
                              minLines: 1,
                              maxLines: 3,
                              controller: _descriptionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please describe yourself";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 14,
                                controller: _nationalidController,
                                decoration: InputDecoration(
                                  hintText: 'Enter National ID',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 14) {
                                    return "National ID must be 14 digits";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _refNumberController,
                                maxLength: 11,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter Reference Number (e.g., 01123456789)',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length != 11 ||
                                      !value.startsWith('01')) {
                                    return "Reference Number must start with '01' and be 11 digits long";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () =>
                                      _handleImageSelectionAndUpload(),
                                  icon: Icon(Icons.photo),
                                  label: Text('Upload National ID'),
                                ),
                                _selectedImage != null
                                    ? Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.file(
                                            _selectedImage!), // Show selected image
                                      )
                                    : Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Icon(Icons
                                            .image), // Placeholder if no image is selected
                                      ),
                                if (_uploadingImage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child:
                                        CircularProgressIndicator(), // Show progress indicator
                                  ),
                                if (!_uploadingImage &&
                                    _nationalIdUploadProgress == 1.0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(Icons.check_circle,
                                        color: Colors
                                            .green), // Show green check icon when upload is complete
                                  ),
                                // ElevatedButton(
                                //   onPressed: () =>
                                //       _handleImageSelectionAndUpload(),
                                //   child: Text('Choose File'),
                                // ),
                                // _nationalIdUploadProgress == 1.0
                                //   ? Icon(Icons.check_circle, color: Colors.green)
                                //   : Visibility(
                                //       visible: _nationalIdUploadProgress < 1.0,
                                //       child: CircularProgressIndicator(),
                                //     ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _handleImageSelectionAndUpload(), // استدعاء وظيفة pickImage
                                  icon: Icon(Icons.photo),
                                  label: Text('Upload Feesh Image'),
                                ),
                                _selectedImage != null
                                    ? Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.file(
                                            _selectedImage!), // Show selected image
                                      )
                                    : Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Icon(Icons
                                            .image), // Placeholder if no image is selected
                                      ),
                                if (_uploadingImage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child:
                                        CircularProgressIndicator(), // Show progress indicator
                                  ),
                                if (!_uploadingImage && _FeeshProgress == 1.0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(Icons.check_circle,
                                        color: Colors
                                            .green), // Show green check icon when upload is complete
                                  ),
                                // ElevatedButton(
                                //   onPressed: () =>
                                //       _handleImageSelectionAndUpload(),
                                //   child: Text('Choose File'),
                                // ),
                                // _feeshImageUploadProgress == 1.0
                                //     ? Icon(Icons.check_circle, color: Colors.green)
                                //     : Visibility(
                                //         visible: _feeshImageUploadProgress < 1.0,
                                //         child: CircularProgressIndicator(),
                                //       ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isAvailable24H,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAvailable24H = value!;
                                });
                              },
                            ),
                            Text(
                              '24-hour service availability',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 15, right: 15, bottom: 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(234, 0, 0, 0),
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
                                    content: Text(
                                        'Please Enter your National ID card'),
                                  ),
                                );
                              } else if (_nationalidController.text.length !=
                                  14) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('National-ID must be 14 digit'),
                                  ),
                                );
                              } else {
                                _submitRequest();

                                waitingDialog(context);
                              }
                            },
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
    );
  }
}
