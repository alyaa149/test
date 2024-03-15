import 'package:flutter/material.dart';
import 'package:grad_proj/Pages/createPost.dart';
import 'package:grad_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:grad_proj/Pages/pagesWorker/home.dart';

class CustomNabBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showSearchBox;
  final bool arrowBack;


  const CustomNabBar({
    Key? key,
    required this.scaffoldKey,
    this.showSearchBox = false,
    required this.arrowBack,

  }) : super(key: key);

  @override
  Size get preferredSize {
    if (showSearchBox) {
      return const Size.fromHeight(90.0);
    } else {
      return const Size.fromHeight(60.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFBBA2BF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      title: Row(
        children: [
          if (arrowBack)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();


              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          const Spacer(),
          Image.asset(
            'assets/images/MR. House.png',
            width: 80,
            height: 60,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Handle profile picture tap
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/images/profile.png',
              ),
            ),
          ),
        ],
      ),
      bottom: showSearchBox
          ? PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search technician name",
              contentPadding: EdgeInsets.zero,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }


}
