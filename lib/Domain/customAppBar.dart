import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/pagesUser/userinfo.dart';
import 'package:gradd_proj/Pages/pagesWorker/workerInfo.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showSearchBox;
  final FutureOr<Iterable<String?>> Function(String)?
      onSearchTextChanged; // Make the parameter optional

  CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    this.showSearchBox = false,
    //required GlobalKey<ScaffoldState> scaffoldKeyU, // Default value is false
    this.onSearchTextChanged, // Make the parameter optional
  }) : super(key: key);
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isUser = userProvider.isUser;

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
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 40,
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
            child: StreamBuilder(
              stream: currentUser.currentUser != null
                  ? FirebaseFirestore.instance
                      .collection(isUser ? "users" : "workers")
                      .doc(currentUser.currentUser!.uid)
                      .snapshots()
                  : null,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('User data not found');
                }

                // Once data is available, extract the username from the snapshot
                Map<String, dynamic>? userData =
                    snapshot.data!.data() as Map<String, dynamic>?;

                return GestureDetector(
                  onTap: () {
                    if (isUser == true) {
                      // Define navigation logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => userinfo()),
                      );
                    } else{
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Workererinfo()));
                    }
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      userData?['Pic'] ?? 'assets/images/profile.png',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // bottom: showSearchBox && onSearchTextChanged != null
      //     ? PreferredSize(
      //         preferredSize: const Size.fromHeight(0),
      //         child: Expanded(
      //           child: Padding(
      //             padding: const EdgeInsets.all(6.0),
      //             child: TextField(
      //               onChanged: (pattern) async {
      //                 if (onSearchTextChanged != null) {
      //                   await onSearchTextChanged!(
      //                       pattern); // Call the provided function if it's not null
      //                 }
      //               },
      //               decoration: InputDecoration(
      //                 labelText: 'Search for a technician...',
      //                 border: OutlineInputBorder(),
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : null,
    );
  }

  @override
  Size get preferredSize {
    // if (showSearchBox && onSearchTextChanged != null) {
    // return const Size.fromHeight(90.0);
    // }
    //  else {
    return const Size.fromHeight(60.0);
    // }
  }
}
