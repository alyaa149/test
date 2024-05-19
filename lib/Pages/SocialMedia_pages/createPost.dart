// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/posts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _pickedImagePath;
  final ImagePicker _imagePicker = ImagePicker();
  bool _uploadingImage = false;
  late File _pickedImage;
  String? _pickedImagePath1;
  File? _selectedImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance;


Future<String> _fetchProfilePicUrl() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    return 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'; // Return default profile picture URL if the user is not authenticated
  }

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  bool isUser = userProvider.isUser;

  // Determine the collection path based on the isUser flag
  String collectionPath = isUser ? 'users' : 'workers';

  final userDocumentSnapshot = await FirebaseFirestore.instance
  .collection(collectionPath)
  .doc(currentUser.uid)
  .get();

  if (userDocumentSnapshot.exists) {
      final userData = userDocumentSnapshot.data();
      print('Fetched user data: $userData');
      if (userData != null && userData.containsKey('Pic')) {
        return userData['Pic'] as String;
      } else {
        return 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'; // Return default profile picture URL if 'Pic' field doesn't exist
      }
    } else {
      return 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'; // Return default profile picture URL if the user document does not exist
    }
  }

  Future<void> _submitRequest() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  bool isUser = userProvider.isUser;

  final String description = _descriptionController.text;
  final username = await _fetchUsernameFromFirestore();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  String imageUrl1 = '';
  final imageUrl = _pickedImagePath ?? '';
  final imagePath = _pickedImagePath1 ?? '';
  final dateTimestamp = DateTime.now();

  final requestData = {
    'description': description,
    'username': username,
    'userId': userId,
    'imageUrl': imageUrl,
    'camerapic': imagePath,
    'Date': dateTimestamp,
  };

  try {
    await FirebaseFirestore.instance.collection('Posts').add(requestData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posted successfully')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Posts(),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to Post')),
    );
  }
}


  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Return the download URL
      return imageUrl;
    } catch (error) {
      // If an error occurs during the upload process, return null
      print('Error uploading image: $error');
      return null;
    }
  }

Future<String> _fetchUsernameFromFirestore() async {
    // Fetch the usernames from Firestore using the current user's document ID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return 'Anonymous'; // Return 'Anonymous' if the user is not authenticated
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
  bool isUser = userProvider.isUser;

  // Determine the collection path based on the isUser flag
  String collectionPath = isUser ? 'users' : 'workers';

  final userDocumentSnapshot = await FirebaseFirestore.instance
  .collection(collectionPath)
  .doc(currentUser.uid)
  .get();

  if(userDocumentSnapshot.exists){
      // If the user document exists, get the usernames from it
      final username1 = userDocumentSnapshot.data()?['First Name'] as String;
      final username2 = userDocumentSnapshot.data()?['Last Name'] as String;

      // Combine the usernames into a single string
      final combinedUsername = '$username1 $username2';

      return combinedUsername.trim(); // Return the combined username
    } else {
      return 'Anonymous'; // Return 'Anonymous' if the user document does not exist
    }
  }





  Future<void> _handleImageSelectionAndUpload() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _pickedImagePath = pickedImage.path;
        _selectedImage = _pickedImage; // Set the selected image
        _uploadingImage = true; // Set uploading status to true
      });

      final imageUrl = await uploadImageToFirebase(_pickedImage);
      if (imageUrl != null) {
        setState(() {
          _pickedImagePath = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
        // Continue with post creation or other actions
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }

      setState(() {
        _uploadingImage =
            false; // Set uploading status to false after upload completes
      });
    }
  }

  Widget _buildSelectedImage() {
    return _pickedImage != null
        ? Image.file(_pickedImage!)
        : SizedBox(); // If no image is selected, return an empty SizedBox
  }

  Future<void> _handleImageSelectionAndUpload1() async {
    setState(() {
      _uploadingImage = true; // تعيين حالة التحميل إلى صحيحة
    });

    final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera); // تغيير المصدر هنا

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _pickedImagePath = pickedImage.path;
        _selectedImage = _pickedImage; // Set the selected image
      });

      try {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_pickedImage!); // تحميل الصورة إلى Firebase Storage
        final imageUrl =
            await ref.getDownloadURL(); // الحصول على رابط تنزيل الصورة
        setState(() {
          _pickedImagePath = imageUrl; // تحديث مسار الصورة المختارة بالرابط
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Posts(),
          ),
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
    final userProvider = Provider.of<UserProvider>(context);
    bool isUser = userProvider.isUser;
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
              //Mr. house word
              SizedBox(
                height: 45,
              ),
              ListView(
                padding: EdgeInsets.symmetric(vertical: 100),
                children: [
                    FutureBuilder<List<String>>(
                    future: Future.wait(
                        [_fetchProfilePicUrl(), _fetchUsernameFromFirestore()]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the data to be fetched, show a loading indicator
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there's an error fetching the data, display an error message
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // If the data is successfully fetched, extract profile pic URL and username
                        final List<String> data = snapshot.data!;
                        final String proPic = data[0];
                        print('THIS IS THE PROPIC: $proPic');
                        final String proName = data[1];

                        // Pass profile pic URL and username to the FriendPost widget
                        return FriendPost(
                          proPic: proPic,
                          proName: proName,
                        );
                      }
                    },
                  ),
                ],
              ),

              // Add Post Fields and Button
              Positioned(
                top: 200,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Write your post here...',
                                  ),
                                  minLines: 3,
                                  maxLines: 5,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // يبدأ من اليسار
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      _handleImageSelectionAndUpload, // استدعاء وظيفة pickImage
                                  icon: Icon(Icons.photo),
                                  label: Text('Upload photo/video'),
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

                                // Display progress indicator if uploading image
                                if (_uploadingImage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child:
                                        CircularProgressIndicator(), // Show progress indicator
                                  ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100, // تحديد العرض حسب الحاجة
                          height: 50, // تحديد الارتفاع حسب الحاجة
                          child: TextButton(
                            onPressed:  _submitRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFBBA2BF),
                            ), // تغيير لون الزر
                            child: Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //post layer
  Widget FriendPost({
    required String proPic,
    required String proName,
  }) {
    return Column(
      children: <Widget>[
        Container(
          width: 700,
          padding: EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown),
                  image: DecorationImage(
                    image: NetworkImage(proPic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      proName,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        height: 3.0,
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
}
