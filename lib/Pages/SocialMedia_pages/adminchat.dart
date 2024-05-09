import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microphone/microphone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({Key? key}) : super(key: key);

  @override
  _AdminChatState createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  // final TextEditingController _messageController = TextEditingController();
  // final ScrollController _scrollController = ScrollController();
  // late MicrophoneRecorder _recorder;
  // final imagePicker = ImagePicker();
  // bool _uploadingImage = false; // Track image upload status
  // String? _uploadedImageName;

  // final CollectionReference _adminCollection =
  //     FirebaseFirestore.instance.collection('messages');

  // final CollectionReference _otherCollection =
  //     FirebaseFirestore.instance.collection('workerMessages');
  // File? _pickedImage;
  // String? _imageUrl;

  // @override
  // void initState() {
  //   super.initState();
  //   _recorder = MicrophoneRecorder();
  // }

  // @override
  // void dispose() {
  //   _messageController.dispose();
  //   _recorder.dispose();
  //   super.dispose();
  // }

  // Future<void> _startRecording() async {
  //   try {
  //     await _recorder.start();
  //     print('Recording started');
  //   } catch (e) {
  //     print('Error starting recording: $e');
  //   }
  // }

  // void _attachFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     // Use the picked file
  //     print('File picked: ${result.files.single.path}');
  //   } else {
  //     print('No file selected.');
  //   }
  // }

  // Future<void> _handleImageSelectionAndUpload() async {
  //   setState(() {
  //     _uploadingImage = true; // Set uploading status to true
  //   });
  //   final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _pickedImage = File(pickedImage
  //           .path); // Assign the value of pickedImage to _pickedImage
  //       _uploadingImage = false; // Set uploading status to false
  //       _uploadedImageName = pickedImage.path.split('/').last; // Get image name
  //     });

  //     try {
  //       final firebase_storage.Reference ref = firebase_storage
  //           .FirebaseStorage.instance
  //           .ref()
  //           .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

  //       await ref.putFile(_pickedImage!);
  //       final imageUrl = await ref.getDownloadURL();

  //       setState(() {
  //         _imageUrl = imageUrl;
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Image uploaded successfully')),
  //       );
  //     } catch (error) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Failed to upload image')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //     appBar: AppBar(
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           IconButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             icon: Icon(Icons.arrow_back),
  //           ),
  //           Text('Chat with John Doe'),
  //           SizedBox(width: 45),
  //         ],
  //       ),
  //     ),
  //     body: Row(
  //       children: [
  //         Expanded(
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream: _otherCollection.orderBy('timestamp').snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               } else if (snapshot.hasError) {
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               } else {
  //                 final List<DocumentSnapshot> documents =
  //                     snapshot.data!.docs.reversed.toList();
  //                 return ListView.builder(
  //                   reverse: true, // Reverse the list view
  //                   itemCount: documents.length,
  //                   itemBuilder: (context, index) {
  //                     final message = documents[index]['message'];
  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 16.0, vertical: 8.0),
  //                       child: Align(
  //                         alignment: Alignment.centerLeft,
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(30.0),
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 16.0, vertical: 8.0),
  //                             decoration: BoxDecoration(color: Colors.grey),
  //                             child: Text(
  //                               message,
  //                               style: TextStyle(
  //                                   color: Colors.white, fontSize: 16.0),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //         Expanded(
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream: _adminCollection.orderBy('timestamp').snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               } else if (snapshot.hasError) {
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               } else {
  //                 final List<DocumentSnapshot> documents = snapshot.data!.docs;
  //                 WidgetsBinding.instance!.addPostFrameCallback((_) {
  //                   _scrollController.animateTo(
  //                     _scrollController.position.maxScrollExtent,
  //                     duration: Duration(milliseconds: 300),
  //                     curve: Curves.easeOut,
  //                   );
  //                 });
  //                 return ListView.builder(
  //                   controller: _scrollController,
  //                   itemCount: documents.length,
  //                   itemBuilder: (context, index) {
  //                     final message = documents[index]['message'];
  //                     final isMe = documents[index]['isMe'];
  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 16.0, vertical: 8.0),
  //                       child: Align(
  //                         alignment: isMe
  //                             ? Alignment.centerRight
  //                             : Alignment.centerLeft,
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(30.0),
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 16.0, vertical: 8.0),
  //                             decoration: BoxDecoration(
  //                                 color: isMe ? Colors.blue : Colors.grey),
  //                             child: Text(
  //                               message,
  //                               style: TextStyle(
  //                                   color: Colors.white, fontSize: 16.0),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: _buildMessageInputSection(),
  //   );
  // }

  // Widget _buildMessageInputSection() {
  //   return Container(
  //     color: Colors.white, // Set background color to white
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.attach_file),
  //           onPressed: () {
  //             setState(() {
  //               _attachFile();
  //             });
  //             // Handle attachment logic
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.camera_alt),
  //           onPressed: () {
  //             setState(() {
  //               _handleImageSelectionAndUpload();
  //             });
  //             // Handle camera logic
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.mic),
  //           onPressed: () {
  //             setState(() {
  //               _startRecording();
  //             });
  //           },
  //         ),
  //         Expanded(
  //           child: TextField(
  //             controller: _messageController,
  //             decoration: InputDecoration(
  //               hintText: 'Type a message...',
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(
  //                   Radius.circular(30.0),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 8.0),
  //         ElevatedButton(
  //           onPressed: () async {
  //             final newMessage = _messageController.text.trim();
  //             if (newMessage.isNotEmpty) {
  //               await _adminCollection.add({
  //                 'message': newMessage,
  //                 'isMe': true,
  //                 'timestamp': DateTime.now(),
  //               });
  //               _messageController.clear();
  //             }
  //           },
  //           child: Icon(Icons.send),
  //         ),
  //       ],
  //     ),
    );
  }
}
