// // ignore_for_file: prefer_const_constructors
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gradd_proj/Domain/customAppBar.dart';
// import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
// import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/responds.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:url_launcher/url_launcher.dart';

// class ReqCategory extends StatefulWidget {
//   const ReqCategory({Key? key}) : super(key: key);
//   @override
//   State<ReqCategory> createState() => _ReqCategoryState();
// }

// class _ReqCategoryState extends State<ReqCategory> {
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final imagePicker = ImagePicker();
//   bool _uploadingImage = false; // Track image upload status
//   String? _uploadedImageName; // Track the name of the uploaded image
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedCategory;
//   String? categoryId;
//   File? _pickedImage;
//   String? _imageUrl;
// //  final currentUser = FirebaseAuth.instance.currentUser!.uid;
//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text =
//             _selectedDate!.toString(); // Update the text in the controller
//       });
//     }
//   }

//   void _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//         _timeController.text =
//             _selectedTime!.format(context); // Update the text in the controller
//       });
//     }
//   }

//   Future<String?> _submitRequest() async {
    
  
//     final String address = _addressController.text;
//     final String description = _descriptionController.text;
//     final String imageUrl = _imageUrl ?? ''; // Handle null case

//     final Timestamp? dateTimestamp =
//         _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;
//     //  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
//     final Map<String, dynamic> requestData = {
//       'Date': dateTimestamp,
//       'Time': _selectedTime?.format(context),
//       'Address': address,
//       'Description': description,
//       'service': _selectedCategory,
      
//       'PhotoURL': imageUrl,
//       'Emergency': false,
//       'TypeReq': "general",
//       // 'user': currentUserID,
//        'user': FirebaseAuth.instance.currentUser!.uid,
//         "isActive":false
//     };
//      try {
//        final DocumentReference requestRef =
//         await FirebaseFirestore.instance.collection('requests').add(requestData);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Request submitted successfully')),
//     );
//       return requestRef.id;
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to submit request')),
//       );
//          return null;
//     }
//   }

//   void _launchMap() async {
//     // Use the URL launcher to open a map application
//     final String query = Uri.encodeFull(_addressController.text);
//     final String googleMapsUrl =
//         "https://www.google.com/maps/search/?api=1&query=$query";

//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       // Handle error
//       throw 'Could not launch $googleMapsUrl';
//     }
//   }

//   Future<void> _handleImageSelectionAndUpload() async {
//     setState(() {
//       _uploadingImage = true; // Set uploading status to true
//     });
//     final pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _pickedImage = File(pickedImage
//             .path); // Assign the value of pickedImage to _pickedImage
//         _uploadingImage = false; // Set uploading status to false
//         _uploadedImageName = pickedImage.path.split('/').last; // Get image name
//       });

//       try {
//         final firebase_storage.Reference ref = firebase_storage
//             .FirebaseStorage.instance
//             .ref()
//             .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

//         await ref.putFile(_pickedImage!);
//         final imageUrl = await ref.getDownloadURL();

//         setState(() {
//           _imageUrl = imageUrl;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image uploaded successfully')),
//         );
//       } catch (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to upload image')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: CustomAppBar(
//           scaffoldKey: _scaffoldKey,
//         //  scaffoldKeyU: _scaffoldKey,
//         ),
//         body: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: Stack(
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 330,
//                       height: 630,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F3F3),
//                         borderRadius: BorderRadius.circular(20.0),
//                         border: Border.all(color: Colors.black26, width: 2),
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           top: 0,
//                           left: 15,
//                           right: 15,
//                           bottom: 20,
//                         ),
//                         child: Form(
//                           key: _formKey,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 7),
//                                           GestureDetector(
//                                             onTap: () => _selectDate(context),
//                                             child: AbsorbPointer(
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                   labelText: "Date",
//                                                   prefixIcon: Icon(
//                                                       Icons.calendar_month),
//                                                   border: OutlineInputBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                   ),
//                                                   contentPadding:
//                                                       EdgeInsets.symmetric(
//                                                           vertical: 12),
//                                                 ),
//                                                 controller: _dateController,
//                                                 validator: (value) {
//                                                   if (value!.isEmpty) {
//                                                     return "Please select a date ";
//                                                   }
//                                                   return null;
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 18.0),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 7),
//                                           GestureDetector(
//                                             onTap: () => _selectTime(context),
//                                             child: AbsorbPointer(
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                   labelText: "Time",
//                                                   prefixIcon:
//                                                       Icon(Icons.access_time),
//                                                   border: OutlineInputBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                   ),
//                                                   contentPadding:
//                                                       EdgeInsets.symmetric(
//                                                           vertical: 12),
//                                                 ),
//                                                 controller: _timeController,
//                                                 validator: (value) {
//                                                   if (value!.isEmpty) {
//                                                     return "Please select a time ";
//                                                   }
//                                                   return null;
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 18.0),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           TextFormField(
//                                             controller: _addressController,
//                                             decoration: InputDecoration(
//                                               labelText: "Select on Location",
//                                               prefixIcon: GestureDetector(
//                                                 onTap: () {
//                                                   _launchMap();
//                                                 },
//                                                 child: Icon(Icons.location_on),
//                                               ),
//                                               border: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10.0),
//                                               ),
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return "Please enter your location";
//                                               }
//                                               return null;
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 18.0),
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                     prefixIcon: Icon(Icons.note),
//                                     labelText: "Write the problem...",
//                                     contentPadding: EdgeInsets.zero,
//                                     fillColor: const Color.fromARGB(
//                                         255, 233, 237, 241),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   controller: _descriptionController,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return "Please enter your problem";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 18.0),
//                                 ListTile(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 0, horizontal: 0),
//                                   //  leading: const Icon(Icons.camera_alt_outlined),
//                                   title: Row(
//                                     children: [
//                                       const Icon(Icons.image), // Image icon
//                                       SizedBox(width: 8),
//                                       if (_uploadingImage) // Show progress indicator if uploading
//                                         SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                     Colors.green),
//                                           ),
//                                         )
//                                       else if (_uploadedImageName !=
//                                           null) // Show uploaded image name
//                                         Text(_uploadedImageName!)
//                                       else // Show 'Upload Photo' text if not uploading and no image uploaded
//                                         const Text(
//                                           'Upload Photo',
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 18.0),
//                                         ),
//                                     ],
//                                   ),
//                                   onTap: () => _handleImageSelectionAndUpload(),
//                                 ),
//                                 const SizedBox(height: 18.0),
//                                 const Text(
//                                   'The category that related to the problem*',
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                                 const SizedBox(height: 10.0),
//                                   Center(
//                                   child: InkWell(
//                                     onTap: () {
//                                       showModalBottomSheet(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return SizedBox(
//                                             height: 400,
//                                             child: SingleChildScrollView(
//                                               child: Column(
//                                                 children: <Widget>[
//                                                   ListTile(
//                                                     title: Text('Carpenters'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service5';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                   ),
//                                                   ListTile(
//                                                     title: Text('Plumbers'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service8';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected:
//                                                         _selectedCategory ==
//                                                             'Plumber',
//                                                   ),
//                                                   ListTile(
//                                                     title: Text('Electrician'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'Electrician';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected:
//                                                         _selectedCategory ==
//                                                             'Electrician',
//                                                   ),
//                                                   ListTile(
//                                                     title: Text('painter'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service7';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected:
//                                                         _selectedCategory ==
//                                                             'painter',
//                                                   ),
//                                                   ListTile(
//                                                     title: Text('tiler'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service9';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected:
//                                                         _selectedCategory ==
//                                                             'Tiler',
//                                                   ),
//                                                   ListTile(
//                                                     title: Text('Plastering'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service4';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected:
//                                                         _selectedCategory ==
//                                                             'Plastering',
//                                                   ),
//                                                   ListTile(
//                                                     title: Text(
//                                                         'Appliance Repair Technician'),
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _selectedCategory =
//                                                             'service2';
//                                                       });
//                                                       Navigator.pop(context);
//                                                     },
//                                                     selected: _selectedCategory ==
//                                                         'Appliance Repair Technician',
//                                                   ),
//                                                   // Add similar code for other categories
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 0, horizontal: 0),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(25),
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             _selectedCategory ?? 'Categories',
//                                             style: TextStyle(fontSize: 18),
//                                           ),
//                                           Icon(
//                                             Icons.arrow_drop_down,
//                                             size: 35,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               SizedBox(
//                                   height: 35,
//                                 ),
//                                 Center(
//                                     child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 0, left: 15, right: 15, bottom: 0),
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       foregroundColor:
//                                           const Color.fromARGB(234, 0, 0, 0),
//                                       backgroundColor: const Color(0xFFBBA2BF),
//                                     ),
//                                     child: const Text(
//                                       'Make a Request',
//                                       style: TextStyle(fontSize: 15),
//                                     ),
//                                     onPressed: () async{
//                                       if (_formKey.currentState?.validate() ==
//                                           true) {
//                                            String? documentId = await _submitRequest();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => Responds(requestDocId: documentId,)),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         drawer: Menu(
//           scaffoldKey: _scaffoldKey,
//         ),
//       ),
//     );
//   }
// }
