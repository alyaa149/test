// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/reqEmergency.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Req extends StatefulWidget {
  final String workerId;
   final String serviceId;
  const Req({Key? key, required this.serviceId,required this.workerId}) : super(key: key);

  @override
  State<Req> createState() => _ReqState();
}

class _ReqState extends State<Req> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  bool _uploadingImage = false;
  String? _uploadedImageName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  String? categoryId;
  String? _imageUrl = '';
  File? imageFile;

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
        _dateController.text = _selectedDate!.toString();
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: 10, minute: 0), // Set initial time to 10:00 AM
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (picked.hour >= 08 && picked.hour < 12) {
        setState(() {
          _selectedTime = picked;
          _timeController.text = _selectedTime!.format(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please select a time between 08:00 AM and 12:00 PM \nOR Go to Emergency ')),
        );
      }
    }
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
    String? categoryId = _selectedCategory;
    if (categoryServiceMap.containsKey(_selectedCategory)) {
      categoryId = categoryServiceMap[_selectedCategory]!;
    }
    final String address = _addressController.text;
    final String description = _descriptionController.text;
    final String imageUrl = _imageUrl ?? '';

    final Timestamp? dateTimestamp =
        _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;

    final Map<String, dynamic> requestData = {
      'Date': dateTimestamp,
      'Time': _selectedTime?.format(context),
      'Address': address,
      'Description': description,
      'service': widget.serviceId,
      'PhotoURL': imageUrl, // Include the image URL in requestData
      'Emergency': false,
      'TypeReq': "specified",
      'user' :FirebaseAuth.instance.currentUser!.uid,
      'worker' :widget.workerId,
      'City' : selectedCity
    };

    try {
      await FirebaseFirestore.instance.collection('requests').add(
            requestData,
          );
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
    try {
      late FilePickerResult? result;

      if (Platform.isAndroid || Platform.isIOS) {
        final picker = ImagePicker();
        final pickedImage = await picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          imageFile = File(pickedImage.path);
        }
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null) {
          imageFile = File(result.files.single.path!);
        }
      }

      if (imageFile != null) {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = ref.putFile(imageFile!);
        final taskSnapshot = await uploadTask;

        if (taskSnapshot.state == firebase_storage.TaskState.success) {
          final imageUrl = await ref.getDownloadURL();

          setState(() {
            _imageUrl = imageUrl;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded successfully')),
            );
          });
          print('Image uploaded successfully. URL: $imageUrl');
        } else {
          print('Error uploading image');
        }
      }
    } catch (error) {
      print('Error picking or uploading image: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
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
          child: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 400,
                      height: 650,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3F3),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.black26, width: 2),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
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
                                                  prefixIcon: Icon(
                                                      Icons.calendar_month),
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
                                              labelText: "Select Your Location",
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
                                    fillColor: const Color.fromARGB(
                                        255, 233, 237, 241),
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
                                  keyboardType: TextInputType
                                      .multiline, // Enable multiline input
                                  maxLines: null, // Allow unlimited lines
                                  textInputAction: TextInputAction
                                      .newline, // Change the action button to newline
                                  onChanged: (_) {
                                    setState(() {
                                      // Update the border continuously
                                    });
                                  },
                                ),
                                const SizedBox(height: 18.0),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  title: Row(
                                    children: [
                                      const Icon(Icons.image),
                                      SizedBox(width: 8),
                                      if (_uploadingImage)
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
                                      else if (_uploadedImageName != null)
                                        Text(_uploadedImageName!)
                                      else
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
                             
                               
                                const SizedBox(height: 18.0),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            const Color.fromARGB(234, 0, 0, 0),
                                        backgroundColor:
                                            const Color(0xFFBBA2BF),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          _submitRequest();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home()),
                                          );
                                        }
                                      },
                                      child: const Text('Book'),
                                    ),
                                  ),
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
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReqEmergency()),
            );
          },
          backgroundColor: const Color(0xFFBBA2BF),
          shape: const CircleBorder(),
          child: const Icon(Icons.add_chart_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
