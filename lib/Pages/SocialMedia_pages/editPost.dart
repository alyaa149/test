// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/posts.dart';

import '../../Domain/customAppBar.dart';
import '../Menu_pages/menu.dart';


class EditPost extends StatefulWidget {
  const EditPost({Key? key}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //const WorkersList({Key? key});

  get bottomNavigationBar => null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey,showSearchBox: false,),
         drawer: Menu(scaffoldKey: _scaffoldKey,),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
           SizedBox(
                height: 45,
              ),
              ListView(
                padding: EdgeInsets.symmetric(vertical: 100),
                children: [
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Ali Mohamed Omar ',
                  ),
                ],
              ),
              // Add Post Fields and Button
              Positioned(
                top: 200, // تعديل الارتفاع حسب الاحتياج
                left: 20, // تعديل المسافة من اليسار حسب الاحتياج
                right: 20,
                // تعديل المسافة من اليمين حسب الاحتياج
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
                            decoration: InputDecoration(
                              hintText:
                                  'اهلا وسهلا, عندي مشكلة في حنفية المطبخ اريد نجار',
                              border: InputBorder.none,
                            ),
                            minLines: 3,
                            maxLines: 5,
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
                            onPressed: () {
                              // Add functionality for upload photo/video button
                              print('Upload button pressed');
                            },
                            icon: Icon(Icons.photo),
                            label: Text('Upload photo/video'),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // يبدأ من اليسار
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // Add functionality for camera button
                              print('Camera button pressed');
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text('Camera'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100, // تحديد العرض حسب الحاجة
                          height: 50, // تحديد الارتفاع حسب الحاجة
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Posts()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFBBA2BF),
                            ), // Change button color
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors
                                    .black, // تغيير لون النص إلى اللون الأرجواني
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
        SizedBox(
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