import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gradd_proj/Pages/SignUp_pages/email_page.dart';

class ProfilePicPage extends StatefulWidget {
  final bool isUser;
  final String firstName;
  final String lastName;

  const ProfilePicPage({
    Key? key,
    required this.isUser,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _ProfilePicPageState createState() => _ProfilePicPageState();
}

class _ProfilePicPageState extends State<ProfilePicPage> {
  File? _imageFile;
  bool _imageSelected = false;
  String _defaultImageAssetPath = 'assets/images/profile.png';

  // Function to handle image selection
  Future<void> _selectImage() async {
  final picker = ImagePicker();
  if (!kIsWeb) {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageSelected = true;
      });
    }
  } 
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: 700,
          height: 700,
          child: Stack(
            children: [
              // Background Image
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SvgPicture.asset(
                  "assets/images/Rec that Contain menu icon &profile1.svg",
                  fit: BoxFit.cover,
                ),
              ),
              // App Title
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset("assets/images/MR. House.svg"),
                ),
              ),
              // App Icon
              Positioned(
                right: 15,
                top: 15,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/FixxIt.png'),
                ),
              ),
              Center(
                child: Container(
                  width: 320,
                  height: 360,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F3F3),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please select a Profile Picture',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _imageSelected || _imageFile != null
                          ? _buildProfileImage()
                          : Placeholder(
                              fallbackHeight: 150,
                              fallbackWidth: 150,
                            ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF824E8B),
                        ),
                        onPressed: _selectImage,
                        child: Text(
                          'Browse to select Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF824E8B),
                            ),
                            onPressed: () {
                              _handleSkip();
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF824E8B),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailPage(
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      isUser: widget.isUser,
                                      imageFile: _imageFile
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return _imageSelected || _imageFile != null
        ? _imageFile != null
            ? Image.file(
                _imageFile!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
            : Image.asset(
                _defaultImageAssetPath,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
        : Text(
            'Image not selected', // Placeholder text when no image is selected
            style: TextStyle(fontSize: 16),
          );
  }

  void _handleSkip() {
    setState(() {
      _imageFile = null;
      _imageSelected = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailPage(
          firstName: widget.firstName,
          lastName: widget.lastName,
          isUser: widget.isUser,
          imageFile: File(_defaultImageAssetPath),
        ),
      ),
    );
  }
}
