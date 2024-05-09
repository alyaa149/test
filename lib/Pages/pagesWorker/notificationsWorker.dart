// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';
import 'package:gradd_proj/Pages/pagesUser/toqaHistoryUser.dart';
import 'package:gradd_proj/Pages/pagesWorker/History.dart';

import '../../Domain/customAppBar.dart';

class alartsWorker extends StatelessWidget {
  alartsWorker({Key? key}) : super(key: key);

  List notification1 = [
    {
      "massege1": "You Confirmed by Lailla Mohamed !",
    },
  ];
  List notification2 = [
    {
      "massege3": "We hope our serves helped you...",
    },
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: true,
        ),
        body: Stack(
          children: [
            // Background Image

            Container(
              child: Stack(
                children: [
                  //purple foreground
                  //text
                  const Positioned(
                    top: 10,
                    left: 6,
                    child: Text(
                      "Today : ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Raleway",
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 120,
                    left: 6,
                    child: Text(
                      "Suterday : ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Raleway",
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Workers List
                  Positioned(
                    top: 40,
                    right: 5,
                    left: 5,
                    bottom: 0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: notification1.length,
                      itemBuilder: (context, itemCount) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(31, 125, 124, 124),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2.0,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(2),
                              leading: const Column(),
                              //name
                              title: RichText(
                                text: TextSpan(
                                  text: 'You Confirmed by Lailla Mohamed ! ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Raleway",
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'show details',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Raleway",
                                        color: Color.fromARGB(255, 8, 110, 200),
                                        decoration: TextDecoration.underline,
                                      ),
                                      // Add onTap callback for the clickable text
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          navigateToPage1(
                                              context, HistoryWorker());
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  //Workers List
                  Positioned(
                    top: 160,
                    right: 5,
                    left: 5,
                    bottom: 0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: notification2.length,
                      itemBuilder: (context, itemCount) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(31, 125, 124, 124),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2.0,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(2),
                              leading: const Column(),
                              //name
                              title: RichText(
                                text: const TextSpan(
                                  text: 'We hope our serves helped you...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Raleway",
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Menu(scaffoldKey: _scaffoldKey),
      ),
    );
  }
}
