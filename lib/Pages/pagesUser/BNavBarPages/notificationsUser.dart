// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';
import '../../../Domain/customAppBar.dart';
import '../../Menu_pages/menu.dart';
import '../../toqaHistoryUser.dart';

class Notifiction extends StatelessWidget {
  Notifiction({Key? key}) : super(key: key);

  //const WorkersList({Key? key});
  List notification1 = [
    {
      "massege1":
          "Don’t Forget! you have an appointment with Mohamed Ahmed Today! show details",
    },
    {
      "massege2": "Mohamed Ahmed Confirmed your massege",
    },
  ];
  List notification2 = [
    {
      "massege3": "Don't forget you have an  with ..",
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
        ),
        body: Stack(children: [
          //text
          const Positioned(
            top: 20,
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
            top: 260,
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
            top: 60,
            right: 5,
            left: 5,
            bottom: 0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: notification1.length,
              itemBuilder: (context, itemCount) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                          text:
                              'Don’t Forget! you have an appointment with Mohamed Ahmed Today! ',
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
                                  navigateToPage1(context, HistoryPage());
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
            top: 290,
            right: 5,
            left: 5,
            bottom: 0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: notification2.length,
              itemBuilder: (context, itemCount) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                          text: 'Ahmed nagy confirmed your massege ',
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
        ]),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
