// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:grad_proj/Domain/user_provider.dart';
import 'package:grad_proj/Pages/pagesUser/login.dart';
import 'package:grad_proj/Pages/pagesWorker/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  
   

  @override
  Widget build(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // //purple foreground
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
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F3F3),
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.black26,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 120,
                        child: ElevatedButton(
                          onPressed: () {
                             userProvider.setIsUser(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBBA2BF),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/userlogo.png', // Path to user 1 logo image
                                height: 50,
                              ),
                              const Text('User'),
                              
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 100,
                        height: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            userProvider.setIsUser(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginWorker()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBBA2BF),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/workerlogo.png', // Path to user 2 logo image
                                height: 50,
                              ),
                              const Text('Worker'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
