// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/responds.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class ReqEmergency extends StatefulWidget {
  const ReqEmergency({Key? key}) : super(key: key);
  @override
  State<ReqEmergency> createState() => _ReqEmergencyState();
}

class _ReqEmergencyState extends State<ReqEmergency> {
  String selectedCity = 'Cairo';
  Map<String, dynamic> requestData = {};
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  bool _uploadingImage = false; // Track image upload status
  String? _uploadedImageName; // Track the name of the uploaded image
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategoryE;
  String? _selectedCategoryC;
  String? categoryId;
  File? _pickedImage;
  String? _imageUrl;
  bool isAgree = false;
  bool Emergency = true;
  String? requestId = '';
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
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
  get currentUserID => null;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            _selectedDate!.toString(); // Update the text in the controller
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0), // Set initial time to 8:00 AM
    );
    if (picked != null) {
      //if (picked.hour >= 12 && picked.hour < 8) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime!.format(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a time between 12:00 AM and 08:00 AM')),
      );
    }
  }

  bool _isRequestActive() {
    DateTime now = DateTime.now();
    int hourC = now.hour;
    return hourC >= 8 && hourC < 24;
  }

  bool _isEmergencyActive() {
    DateTime now = DateTime.now();
    int hourE = now.hour;
    return hourE >= 0 && hourE < 8;
  }

  Future<void> _submitRegularRequest(Map<String, dynamic> requestData) async {
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
    String? categoryIdC = _selectedCategoryC;
    if (categoryServiceMap.containsKey(_selectedCategoryC)) {
      categoryIdC = categoryServiceMap[_selectedCategoryC]!;
    }
    final String address = _addressController.text;
    final String description = _descriptionController.text;
    final String imageUrl = _imageUrl ?? ''; // Handle null case
    final Timestamp? dateTimestamp =
        _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;

    try {
      // Construct the request data including the service ID
      final Map<String, dynamic> requestData = {
        'Date': dateTimestamp,
        'Time': _selectedTime?.format(context),
        'Address': address,
        'Description': description,
        'service': categoryIdC, // Use the service ID
        'PhotoURL': imageUrl,
        'Emergency': false, // Indicate it's an emergency request
        'TypeReq': "general",
        'user': currentUser,
        'City' : selectedCity
      };
      // Add the request to Firestore and capture the document reference
      DocumentReference requestReference =
          await FirebaseFirestore.instance.collection('requests').add(
                requestData,
              );

      // Get the ID of the newly created request
      requestId = requestReference.id;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit request')),
      );
      // Handle the error
    }
  }

  Future<void> _submitEmergencyRequest() async {
    // Define the category-service mapping
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

    if (!isAgree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the emergency fees')),
      );
      return; // Exit the function without navigating to another page
    }

    // Retrieve the service ID corresponding to the selected category for emergency request
    String? categoryIdE = _selectedCategoryE;
    if (categoryServiceMap.containsKey(_selectedCategoryE)) {
      categoryIdE = categoryServiceMap[_selectedCategoryE]!;
    }

    // Get other request data
    final String address = _addressController.text;
    final String description = _descriptionController.text;
    final String imageUrl = _imageUrl ?? ''; // Handle null case
    final Timestamp? dateTimestamp =
        _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;

    try {
      // Construct the request data including the service ID
      final Map<String, dynamic> requestData = {
        'Date': dateTimestamp,
        'Time': _selectedTime?.format(context),
        'Address': address,
        'Description': description,
        'service': categoryIdE, // Use the service ID for emergency request
        'PhotoURL': imageUrl,
        'Emergency': true, // Indicate it's an emergency request
        'TypeReq': "general",
        'user': currentUser,
        'City': selectedCity
      };

      // Add the request to Firestore and capture the document reference
      DocumentReference requestReference =
          await FirebaseFirestore.instance.collection('requests').add(
                requestData,
              );

      // Get the ID of the newly created request
      requestId = requestReference.id;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit request')),
      );
    }
  }

  void _launchMap() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final String latitude = position.latitude.toString();
      final String longitude = position.longitude.toString();
      final String query = Uri.encodeFull('$latitude,$longitude');
      final String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=$query";
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  Future<void> _handleImageSelectionAndUpload() async {
    setState(() {
      _uploadingImage = true; // Set uploading status to true
    });
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage
            .path); // Assign the value of pickedImage to _pickedImage
        _uploadingImage = false; // Set uploading status to false
        _uploadedImageName = pickedImage.path.split('/').last; // Get image name
      });
      try {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_pickedImage!);
        final imageUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 400,
                    height: 950,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3F3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black26, width: 2),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 15,
                        right: 15,
                        bottom: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 7),
                                        GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Date",
                                                prefixIcon:
                                                    Icon(Icons.calendar_month),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 12),
                                              ),
                                              controller: _dateController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please select a date ";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 7),
                                        GestureDetector(
                                          onTap: () => _selectTime(context),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Time",
                                                prefixIcon:
                                                    Icon(Icons.access_time),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 12),
                                              ),
                                              controller: _timeController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please select a time ";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _addressController,
                                          decoration: InputDecoration(
                                            labelText: "Select on Location",
                                            prefixIcon: GestureDetector(
                                              onTap: () {
                                                _launchMap();
                                              },
                                              child: Icon(Icons.location_on),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter your location";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.note),
                                  labelText: "Write the problem...",
                                  contentPadding: EdgeInsets.zero,
                                  fillColor:
                                      const Color.fromARGB(255, 233, 237, 241),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                controller: _descriptionController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your problem";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                // Enable multiline input
                                maxLines: null,
                                // Allow unlimited lines
                                textInputAction: TextInputAction.newline,
                                // Change the action button to newline
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 18.0),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                title: Row(
                                  children: [
                                    const Icon(Icons.image), // Image icon
                                    SizedBox(width: 8),
                                    if (_uploadingImage) // Show progress indicator if uploading
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.green),
                                        ),
                                      )
                                    else if (_uploadedImageName !=
                                        null) // Show uploaded image name
                                      Text(_uploadedImageName!)
                                    else // Show 'Upload Photo' text if not uploading and no image uploaded
                                      const Text(
                                        'Upload Photo',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                  ],
                                ),
                                onTap: () => _handleImageSelectionAndUpload(),
                              ),
                              const SizedBox(height: 18.0),
                              const Text(
                                'The category that related to the problem',
                                style: TextStyle(fontSize: 18),
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
                                                      _selectedCategoryE =
                                                          'Carpenters';
                                                      _selectedCategoryC =
                                                          'Carpenters';
                                                    });
                                                    // Set _selectedCategory to 'service1' when 'Carpenters' is selected
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  title:
                                                      Text('Marble Craftsmen'),
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
                                                      _selectedCategoryC =
                                                          'Tiler';
                                                      _selectedCategoryE =
                                                          'Tiler';
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
                                                  title: Text(
                                                      'Alumetal Technicians'),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          _selectedCategoryE =
                                              _selectedCategoryC ??
                                                  'Categories',
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
                              const SizedBox(height: 18.0),
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
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
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: isAgree
                                          ? const Icon(Icons.check_box)
                                          : const Icon(
                                              Icons.check_box_outline_blank),
                                      onPressed: () {
                                        setState(() {
                                          isAgree = !isAgree;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Agree for emergency fees',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          const Color.fromARGB(234, 0, 0, 0),
                                      backgroundColor: _isEmergencyActive()
                                          ? const Color(0xFFBBA2BF)
                                          : Colors.grey,
                                    ),
                                    onPressed: _isEmergencyActive()
                                        ? () {
                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              if (isAgree) {
                                                _submitEmergencyRequest()
                                                    .then((_) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Responds(
                                                        requestDocId: requestId,
                                                      ),
                                                    ),
                                                  );
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Please agree to the emergency fees'),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        : null,
                                    child: const Text(
                                      'For Emergency',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          const Color.fromARGB(234, 0, 0, 0),
                                      backgroundColor: _isRequestActive()
                                          ? const Color(0xFFBBA2BF)
                                          : Colors.grey,
                                    ),
                                    onPressed: _isRequestActive()
                                        ? () {
                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              _submitRegularRequest(requestData)
                                                  .then((_) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Responds(
                                                      requestDocId: requestId,
                                                    ),
                                                  ),
                                                );
                                              });
                                            }
                                          }
                                        : null,
                                    child: const Text(
                                      'Make a Request',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
