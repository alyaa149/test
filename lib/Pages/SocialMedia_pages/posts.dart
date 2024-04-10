
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';


import '../../Domain/customAppBar.dart';
import 'commentsPage.dart';
import 'createPost.dart';


class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<Posts> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         key: _scaffoldKey,
        appBar: 
          CustomAppBar(scaffoldKey: _scaffoldKey,showSearchBox: false,),
        drawer: Menu(scaffoldKey: _scaffoldKey,),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
    
              SizedBox(
                height: 35,
              ),
                //post layer Open
              ListView(
                padding: EdgeInsets.symmetric(vertical: 100),
                children: [
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Ali Omar',
                    Date: ' 9 AM',
                    postText:
                        'السلام عليكم, حد عارف ازاي انضف خرطوم مياه الصرف للحوض',
                    context: context,
                  ),
                  SizedBox(height: 20),
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Mohamed Khaled',
                    Date: 'Today at 11:30 PM',
                    postText:
                        'اهلا وسهلا, عندي مشكلة في حنفية المطبخ اريد سباك',
                    context: context,
                  ),
                  SizedBox(height: 20),
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Ahmed Mohamed',
                    Date: 'Yesterday at 11:30 AM',
                    postText:
                        'السلام عليكم, حد عارف ازاي انضف خرطوم مياه الصرف للحوض',
                    context: context,
                  ),
                  SizedBox(height: 20),
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Amira samir',
                    Date: 'Yesterday at 8:30 AM',
                    postText:
                        'اهلا وسهلا, عندي مشكلة في حنفية المطبخ اريد سباك',
                    context: context,
                  ),
                  SizedBox(height: 20),
                  FriendPost(
                    proPic: 'assets/images/profile.png',
                    proName: 'Marwan Mostafa',
                    Date: 'Monday at 7:30 AM',
                    postText:
                        'السلام عليكم, حد عارف ازاي انضف خرطوم مياه الصرف للحوض',
                    context: context,
                  ),
                ],
              ),
              //post layer
            ],
          ),
        ),
         floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePost()));
        },
        backgroundColor: const Color(0xFFBBA2BF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class FriendPost extends StatefulWidget {
  final String proPic;
  final String proName;
  final String Date;
  final String postText;
  final BuildContext context;
  const FriendPost(
      {Key? key,
      required this.proPic,
      required this.proName,
      required this.Date,
      required this.postText,
      required this.context})
      : super(key: key);

  @override
  _FriendPostState createState() => _FriendPostState();
}

class _FriendPostState extends State<FriendPost> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
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
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown),
                  image: DecorationImage(
                    image: AssetImage(widget.proPic),
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
                      widget.proName,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.Date,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      widget.postText,
                      style: TextStyle(fontSize: 15.0),
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
                icon: Icon(Icons.comment, size: 20, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsPage()),
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
  }
}
