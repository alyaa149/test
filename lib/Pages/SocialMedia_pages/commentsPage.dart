import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:provider/provider.dart';

import '../../Domain/customAppBar.dart';
import 'editPost.dart';
import '../Menu_pages/menu.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int unreadCommentsCount = 0; // Track the number of unread comments
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showSearchBox: false),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('Posts')
                    .doc(widget.postId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final postData = snapshot.data!.data();
                  final List<dynamic>? comments = postData?['comments'];

                  return ListView.builder(
                    itemCount: comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = comments![index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 4, left: 10, right: 10,bottom: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      comment['name'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        comment['comment'] ?? '',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height:8), // Added space between comment and reply field
                            Center(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add a reply',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                    color: isLiked
                                        ? Colors.blue
                                        : Color.fromARGB(255, 171, 185, 197),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                ),
                                Text('Like'),
                                SizedBox(
                                  width: 40,
                                ),
                                IconButton(
                                  icon: Icon(Icons.reply,
                                      size: 20, color: Colors.black),
                                  onPressed: () {},
                                ),
                                Text('Reply'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(hintText: 'Add a comment'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _addComment();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Menu(
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  // Inside your _CommentsPageState class
  void _addComment() {
  setState(() {
    unreadCommentsCount++;
  });

  String commentText = _commentController.text.trim();
  if (commentText.isNotEmpty) {
    // Get current user
    final user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isUser = userProvider.isUser;
    String collectionPath = isUser ? 'users' : 'workers';

    if (user != null) {
      FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(user.uid)
          .get()
          .then((userData) {
        if (userData.exists) {
          String firstName = userData['First Name'];
          String lastName = userData['Last Name'];

          // Add comment with user's first and last name
          _firestore.collection('Posts').doc(widget.postId).update({
            'comments': FieldValue.arrayUnion([
              {
                'name': '$firstName $lastName',
                'comment': commentText,
              }
            ])
          }).then((_) {
            _commentController.clear();

            // Create a notification
            _createNotification(
                user.uid, widget.postId, '$firstName $lastName', commentText);
          }).catchError((error) {
            // Handle error
            print('Failed to add comment: $error');
          });
        } else {
          print('User data not found');
        }
      }).catchError((error) {
        // Handle error
        print('Failed to get user data: $error');
      });
    }
  }
}

  void _createNotification(String commenterId, String postId,
      String commenterName, String commentText) {
    // Create a new document in the "Notifications" collection
    FirebaseFirestore.instance.collection('Notifications').add({
      'commenterId': commenterId,
      'postId': postId,
      'commenterName': commenterName,
      'commentText': commentText,
      // 'postOwnerName' : uid,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      // Notification created successfully
      // You can optionally show a snackbar or other UI feedback to confirm comment creation
    }).catchError((error) {
      // Handle error
      print('Failed to create notification: $error');
    });
  }
}
