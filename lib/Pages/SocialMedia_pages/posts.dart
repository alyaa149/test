import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/commentsPage.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/createPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool isLiked;
  final currentUser = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    isLiked = false;
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    List<Map<String, dynamic>> postsData = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .orderBy('Date', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic>? postData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (postData != null) {
            String postId = documentSnapshot.id;
            postData['postId'] = postId;

            // Retrieve userId from post data
            String? userId = postData['userId'];
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            bool isUser = userProvider.isUser;

            // Determine the collection path based on the isUser flag
            String collectionPath = isUser ? 'users' : 'workers';

            // Fetch user document from 'users' collection based on userId
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                .collection(collectionPath)
                .doc(userId)
                .get();

            // Get profile picture URL from user document
            String proPic =
                'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'; // Default profile picture URL

            // Check if user document exists and contains 'Pic' field
            if (userSnapshot.exists) {
              Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;

              if (userData != null && userData.containsKey('Pic')) {
                proPic = userData['Pic'];
              }
            }

            // Add profile picture URL to postData
            postData['proPic'] = proPic;

            // Add modified postData to postsData list
            postsData.add(postData);
          }
        }
      } else {
        print('No documents found in the collection');
      }
    } catch (e) {
      print('Error getting documents: $e');
    }

    // Sort postsData by date in descending order
    postsData.sort(
        (a, b) => (b['Date'] as Timestamp).compareTo(a['Date'] as Timestamp));

    print('Posts Data: $postsData'); // Print postsData for debugging
    return postsData;
  }

  Future<void> showEditDialog(
      BuildContext context, String postId, String currentContent) async {
    TextEditingController contentController =
        TextEditingController(text: currentContent);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Edit your post',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Posts')
                    .doc(postId)
                    .update({
                  'description': contentController.text,
                });
                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI to reflect the changes
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('Posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showSearchBox: false),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getAllPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              List<Map<String, dynamic>> postData = snapshot.data!;
              return ListView.builder(
                itemCount: postData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> post = postData[index];
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 10, left: 10, right: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color.fromARGB(31, 196, 193, 193),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                                image: DecorationImage(
                                  image: NetworkImage(post['proPic'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        post['username'] ?? '',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 120,),
                                      if (post['userId'] == currentUser?.uid)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                size: 20, color: Colors.black),
                                            onPressed: () {
                                              showEditDialog(
                                                  context,
                                                  post['postId'] ?? '',
                                                  post['description'] ?? '');
                                            },
                                          ),
                                          IconButton(
                                        icon: Icon(Icons.delete,
                                            size: 20, color: Colors.red),
                                        onPressed: () {
                                          deletePost(post['postId'] ?? '');
                                        },
                                      ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    post['Date'] != null
                                        ? DateFormat.yMMMd().format(
                                            (post['Date'] as Timestamp)
                                                .toDate())
                                        : '',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  SizedBox(height: 30.0),
                                  Text(
                                    post['description'] ?? '',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  SizedBox(height: 25.0),
                                  // Display the post image if it exists
                                  if (post['imageUrl'] != null &&
                                      post['imageUrl'].isNotEmpty)
                                    Image.network(
                                      post['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  SizedBox(height: 25.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                            SizedBox(width: 5),
                            Text('Like'),
                            SizedBox(width: 40),
                            IconButton(
                              icon: Icon(Icons.comment,
                                  size: 20, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                      postId: post['postId'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 5),
                            Text('Comment'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(child: Text('No posts available'));
            }
          },
        ),
      ),
      drawer: Menu(scaffoldKey: _scaffoldKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePost()));
        },
        backgroundColor: const Color(0xFFBBA2BF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_circle_outline_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
