// ignore_for_file: library_prefixes, library_private_types_in_public_api, use_key_in_widget_constructors, file_names, avoid_print, prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as Rx;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserChat extends StatefulWidget {
  const UserChat({Key? key, required this.userId, required this.workerId});

  final String workerId;
  final String userId;

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  String _workerName = ''; // Add this variable to store the worker's name
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  late CollectionReference _workerMessagesCollection;
  late CollectionReference _userMessagesCollection;

  @override
  void initState() {
    super.initState();
    _workerMessagesCollection = _firestore
        .collection('workers')
        .doc(widget.workerId)
        .collection('messages');
    _userMessagesCollection = _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('messages');
    _fetchUserName(); // Call the method to fetch the worker's name
  }

  Future<void> _fetchUserName() async {
    try {
      // Fetch the worker document from Firestore
      DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerId)
          .get();

      // Extract the first name and last name from the document
      String firstName = workerSnapshot[
          'First Name']; // Replace 'First Name' with the actual field name for first name
      String lastName = workerSnapshot[
          'Last Name']; // Replace 'Last Name' with the actual field name for last name

      // Concatenate first name and last name
      String fullName =
          '$firstName $lastName'; // Concatenate first name and last name

      setState(() {
        _workerName =
            fullName; // Update the state variable with the worker's full name
      });
    } catch (error) {
      // Handle any errors
      print('Error fetching worker name: $error');
    }
  }

  Future<void> _handleImageSelectionAndUpload() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);

      try {
        // Upload image to Firebase Storage
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile);

        // Get the download URL of the uploaded image
        final imageUrl = await ref.getDownloadURL();

        // Add image message to worker's collection
        _workerMessagesCollection.add({
          'message': imageUrl,
          'sender': 'User',
          'timestamp': FieldValue.serverTimestamp(),
          'user': widget.userId
        });

        // Add image message to worker's collection
        _userMessagesCollection.add({
          'message': imageUrl,
          'sender': 'User',
          'timestamp': FieldValue.serverTimestamp(),
          'worker': widget.workerId
        });
      } catch (error) {
        // Handle error
        print('Error uploading image: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        title: Row(
          children: [
            Text(
              _workerName.isNotEmpty
                  ? _workerName
                  : 'Worker.Name', // Display the worker's name if available, otherwise fallback to 'Worker.Name'
              style: TextStyle(fontSize: 20.0),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Add logic for info icon
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _mergeMessageStreams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final messages = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].get('message');
                      final sender = messages[index].get('sender');
                      final isMe = sender == 'User';
                      final isImage = message.startsWith('http');

                      if (isImage) {
                        // If it's an image URL, return the image widget
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMe)
                                CircleAvatar(
                                  radius:
                                      20, // Reduced the radius to make the CircleAvatar smaller
                                  backgroundImage: NetworkImage(message),
                                ),
                              SizedBox(
                                  width: isMe
                                      ? 8.0
                                      : 0.0), // Add spacing for user messages
                              Flexible(
                                child: Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      message,
                                      width:
                                          250, // Set a fixed width for the image
                                      height:
                                          250, // Set a fixed height for the image
                                      fit: BoxFit
                                          .cover, // Adjust how the image is inscribed into the space
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // If it's a text message, return a ListTile without CircleAvatar
                        return ListTile(
                          title: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isMe ? Color(0xFFBBA2BF) : Colors.grey,
                                //  color: isMe ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _handleImageSelectionAndUpload,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newMessage = _messageController.text.trim();

                    if (newMessage.isNotEmpty) {
                      // Add message to worker's collection
                      _workerMessagesCollection.add({
                        'message': newMessage,
                        'sender': 'User',
                        'timestamp': FieldValue.serverTimestamp(),
                        'user': widget.userId
                      });

                      // Add message to customer's collection
                      _userMessagesCollection.add({
                        'message': newMessage,
                        'sender': 'User',
                        'timestamp': FieldValue.serverTimestamp(),
                        'worker': widget.workerId 
                      });

                      _messageController.clear();
                    }
                  },
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Object?>> _mergeMessageStreams() {
    final customerStream = _userMessagesCollection
        .orderBy('timestamp', descending: true)
        .where('worker' ,isEqualTo: widget.workerId)
        .snapshots()
           .handleError((error) {
      // Handle error here
      print('User stream error: $error');
    });;
    final workerStream = _workerMessagesCollection
        .orderBy('timestamp', descending: true)
         .where('user' ,isEqualTo: widget.userId)
        .snapshots()
         .handleError((error) {
      // Handle error here
      print('Worker stream error: $error');
    });

    return Rx.MergeStream([
      workerStream,
      customerStream,
    ]);
  }
}