// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';




class UserReview extends StatelessWidget {
  const UserReview({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        // child: Text("   review     "),
         
                                    child: Text(
                                      "UserReview",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                
      )
    );
  }
}