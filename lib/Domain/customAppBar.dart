import 'dart:async';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showSearchBox;
  final FutureOr<Iterable<String?>> Function(String)? onSearchTextChanged; // Make the parameter optional

  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    this.showSearchBox = false,
    //required GlobalKey<ScaffoldState> scaffoldKeyU, // Default value is false
    this.onSearchTextChanged, // Make the parameter optional
  }) : super(key: key);

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
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/images/profile.png',
              ),
            ),
          ),
        ],
      )
    //   bottom: showSearchBox && onSearchTextChanged != null ? PreferredSize(
    //     preferredSize: const Size.fromHeight(0),
    //     child: Expanded(
    //       child: Padding(
    //         padding: const EdgeInsets.all(6.0),
    //         child: TextField(
    //           onChanged: (pattern) async {
    //             if (onSearchTextChanged != null) {
    //               await onSearchTextChanged!(pattern); // Call the provided function if it's not null
    //             }
    //           },
    //           decoration: InputDecoration(
    //             labelText: 'Search for a technician...',
    //             border: OutlineInputBorder(),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ) : null,
    );
  }

  @override
  Size get preferredSize {
    // if (showSearchBox && onSearchTextChanged != null) {
    //   return const Size.fromHeight(90.0);
    // } else {
      return const Size.fromHeight(60.0);
    // }
  }
}
