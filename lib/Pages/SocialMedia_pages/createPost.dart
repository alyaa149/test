import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/posts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  String? _pickedImagePath1;
  final ImagePicker _imagePicker = ImagePicker();
  bool _uploadingImage = false;
  late File _pickedImage;
  File? _selectedImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _submitRequest() async {
    final String description = _descriptionController.text;
    final username = await _fetchUsernameFromFirestore();
    String imageUrl1 = '';
    final imageUrl = _pickedImagePath ?? '';
    final imagePath = _pickedImagePath1 ?? '';
    final dateTimestamp = DateTime.now();

    final requestData = {
      'description': description,
      'username': username, // Use the username fetched from Firestore
      'gallerypic': imageUrl,
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

    final userDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser
            .uid) // Assuming the document ID is the same as the user's UID
        .get();

    if (userDocumentSnapshot.exists) {
      // If the user document exists, get the usernames from it
      final username1 = userDocumentSnapshot.data()?['First Name'] as String?;
      final username2 = userDocumentSnapshot.data()?['Last Name'] as String?;

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
          _pickedImagePath1 = imageUrl; // تحديث مسار الصورة المختارة بالرابط
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
                  FutureBuilder<String>(
                    future: _fetchUsernameFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the user ID to be fetched, you can show a loading indicator
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there's an error fetching the user ID, display an error message
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // If the user ID is successfully fetched, display the FriendPost widget
                        final userId = snapshot.data;
                        return FriendPost(
                          proPic: 'assets/images/profile.png',
                          proName: userId ?? '', // Use the fetched user ID
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
                                  MainAxisAlignment.start, // يبدأ من اليسار
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      _handleImageSelectionAndUpload, // استدعاء وظيفة pickImage
                                  icon: Icon(Icons.photo),
                                  label: Text('Upload photo/video'),
                                ),
                                _selectedImage != null
                                    ? Image.network(_selectedImage!
                                        .path) // Use Image.network for web
                                    : SizedBox(height: 0),
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
                            onPressed: _submitRequest,
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
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown),
                  image: DecorationImage(
                    image: AssetImage(proPic),
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
