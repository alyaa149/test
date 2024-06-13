import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rxdart/rxdart.dart' as Rx;

class UserAdminChat extends StatefulWidget {
  const UserAdminChat({Key? key,});



  @override
  _UserAdminChatState createState() => _UserAdminChatState();
}

class _UserAdminChatState extends State<UserAdminChat> {
  String _adminName = '';
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  late CollectionReference _adminMessagesCollection;
  late CollectionReference _userMessagesCollection;

  @override
  void initState() {
    super.initState();
    _adminMessagesCollection = _firestore.collection('adminsMessages');
    _userMessagesCollection = _firestore.collection('users').doc( FirebaseAuth.instance.currentUser!.uid).collection('AUmessages');
    //_fetchAdminName();
  }


  // Future<void> _fetchAdminName() async {
  //   try {
  //     DocumentSnapshot adminSnapshot = await _firestore.collection('admins').doc(widget.adminId).get();
  //     String firstName = adminSnapshot.get('First Name') ?? 'Unknown';
  //     String lastName = adminSnapshot.get('Last Name') ?? 'Unknown';
  //     String fullName = '$firstName $lastName';

  //     setState(() {
  //       _adminName = fullName;
  //     });
  //   } catch (error) {
  //     print('Error fetching admin name: $error');
  //   }
  // }

  Future<void> _handleImageSelectionAndUpload() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);
      try {
        final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref()
            .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile);
        final imageUrl = await ref.getDownloadURL();
        await _userMessagesCollection.add({
          'AUmessage': imageUrl,
          'sender': 'User',
          'timestamp': FieldValue.serverTimestamp(),
    
        });
        await _adminMessagesCollection.add({
          'AUmessage': imageUrl,
          'sender': 'User',
          'timestamp': FieldValue.serverTimestamp(),
          'userId':  FirebaseAuth.instance.currentUser!.uid,
        });
      } catch (error) {
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
        title: Text(
          'Mr. House',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _mergeMessageStreams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final messages = snapshot.data ?? [];

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index].data() as Map<String, dynamic>;
                      final message = messageData['AUmessage'] ?? '';
                      final sender = messageData['sender'] ?? '';
                      final isMe = sender == 'User';
                      final isImage = message is String && message.startsWith('http');

                      if (isImage) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMe)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(message),
                                ),
                              SizedBox(width: isMe ? 8.0 : 0.0),
                              Flexible(
                                child: Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      message,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isMe ? Color(0xFFBBA2BF) : Colors.grey,
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
                      _userMessagesCollection.add({
                        'AUmessage': newMessage,
                        'sender': 'User',
                        'timestamp': FieldValue.serverTimestamp(),
                    
                      });

                      _adminMessagesCollection.add({
                        'AUmessage': newMessage,
                        'sender': 'User',
                        'timestamp': FieldValue.serverTimestamp(),
                        'userId':  FirebaseAuth.instance.currentUser!.uid,
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

   Stream<List<DocumentSnapshot>> _mergeMessageStreams() {
    final userStream = _userMessagesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .handleError((error) {
      print('User stream error: $error');});

    final adminStream = _adminMessagesCollection
        .orderBy('timestamp', descending: true)
        .where('userId', isEqualTo:  FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .handleError((error) {
      print('Admin stream error: $error');
    });

    return Rx.Rx.merge([userStream, adminStream]);
  }
}
