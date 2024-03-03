// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grad_proj/Domain/CustomNabBar.dart';
import 'package:grad_proj/Domain/listItem.dart';
import 'package:grad_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';
import 'package:grad_proj/Pages/pagesUser/workerReview.dart';
import 'package:grad_proj/Pages/pagesWorker/MenuWorker.dart';
import 'package:grad_proj/Pages/pagesWorker/UserReview.dart';

class HistoryWorker extends StatefulWidget {
  @override
  _HistoryWorkerState createState() => _HistoryWorkerState();
}

class _HistoryWorkerState extends State<HistoryWorker> {
  List<Map<String, dynamic>> worker = [
{
"name": "Ola Ahmed",
"Type": "Air Conditioning Maintenance",
"pic": "assets/images/profile.png",
"Number": "0123456",
"Description": "skilled and professional technician",
"Review": "",
"Rating": 4.4,
"Date": DateTime(2024, 12, 31),
"Commission Fee":200,
"emergency": true
},

{
"name": "Ola Ahmed",
"Type": "Air Conditioning Maintenance",
"pic": "assets/images/profile.png",
"Number": "0123456",
"Description": "skilled and professional technician",
"Review": "",
"Rating": 4.4,
"Date": DateTime(2024, 12, 31),
"Commission Fee":200,
"emergency": true
},
{
"name": "Nagy Ahmed",
"Type": "Refrigerator Maintenance",
"pic": "assets/images/profile.png",
"Rating": 5.0,
"Number": "1237568",
"Description": "",
"Review": "",
"Date": DateTime(2024, 12, 31),
"Commission Fee":50
},

{
"name": "Nagy Ahmed",
"Type": "Refrigerator Maintenance",
"pic": "assets/images/profile.png",
"Rating": 5.0,
"Number": "1237568",
"Description": "",
"Review": "",
"Date": DateTime(2024, 2, 15),
"Commission Fee":50
},
{
"name": "Laila Ahmed",
"Type": "Refrigerator Maintenance",
"pic": "assets/images/profile.png",
"Rating": 5.0,
"Number": "1237568",
"Description": "",
"Review": "",
"Date": DateTime(2024, 1, 10),
"Commission Fee":100
},
{
"name": "Laila Ahmed",
"Type": "Refrigerator Maintenance",
"pic": "assets/images/profile.png",
"Rating": 5.0,
"Number": "1237568",
"Description": "",
"Review": "",
"Date": DateTime(2024, 1, 10),
"Commission Fee":100
},
{
"name": "Laila Ahmed",
"Type": "Refrigerator Maintenance",
"pic": "assets/images/profile.png",
"Rating": 5.0,
"Number": "1237568",
"Description": "",
"Review": "",
"Date": DateTime(2024, 1, 10),
"Commission Fee":100
},

];
  List<Map<String, dynamic>> getRecentWorkers() {
    DateTime today = DateTime.now();
    return worker.where((w) {
      DateTime appointmentDate = w['Date'];
      return appointmentDate.isAfter(today);
    }).toList();
  }

  List<Map<String, dynamic>> getPreviousRequests() {
    DateTime today = DateTime.now();
    return worker.where((w) {
      DateTime appointmentDate = w['Date'];
      return appointmentDate.isBefore(today);
    }).toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> recentWorkers = getRecentWorkers();
    List<Map<String, dynamic>> previousRequests = getPreviousRequests();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(scaffoldKey: _scaffoldKey),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Recent:",
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
              SizedBox(height: 10,),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentWorkers.length,
                itemBuilder: (context, index) {
                  final worker = recentWorkers[index];
                  return ListItem(
                    worker: worker,
                    trailingWidget: worker['emergency'] == true
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset("assets/images/Siren.png"),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset("assets/images/Siren2.png"),
                          ),
                    onPressed: () => navigateToPage1(context, WorkerReview()),
                    pageIndex: 3,
                  );
                },
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  "Previous Requests:",
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
                SizedBox(height: 10,),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: previousRequests.length,
                itemBuilder: (context, index) {
                  final worker = previousRequests[index];
                  return ListItem(
                    worker: worker,
                    trailingWidget: worker['emergency'] == true
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset("assets/images/Siren.png"),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset("assets/images/Siren2.png"),
                          ),
                    onPressed: () => navigateToPage1(context, WorkerReview()),
                    pageIndex: 3,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
   }
}
