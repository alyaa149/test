// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable, library_private_types_in_public_api

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class WorkersList extends StatefulWidget {
  final String serviceId;
 const WorkersList({super.key, required this.serviceId});

  @override
  State<WorkersList> createState() => _WorkersListState();
}

class _WorkersListState extends State<WorkersList> {
  late Stream<QuerySnapshot> _workerSream;
    @override
  void initState() {
    super.initState();
    final String serviceId = widget.serviceId;
    _workerSream = FirebaseFirestore.instance
      .collection('workers')
      .where('Service', isEqualTo: serviceId)
      .snapshots(includeMetadataChanges: true);
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              //Workers List
              Positioned(
                top: 10,
                right: 5,
                left: 5,
                bottom: 0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _workerSream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final workers = snapshot.data!.docs.toList();

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: workers.length,
                        itemBuilder: (context, itemCount) {
                          final doc = workers[itemCount];
                          final dynamic workerData = doc.data();
                          final firstName = workerData['First Name'] as String?;
                          final lastName = workerData['Last Name'] as String?;
                          final desc = workerData['Description'] as String?;
                          final pic = workerData['Pic'] as String?;
                          final number = workerData['PhoneNumber'] as String?;
                      
                            final ratingInt = workerData['Rating'] is int ? workerData['Rating'] as int : 0;
final rating = (ratingInt).toDouble();

                          // print(workerData['Service']
                          //     .get()
                          //     .docSnapshot
                          //     .data()!['name']);
                          // print(
                          //    workerData['ServiceDetails'][0]['Type Description']);
                          if (workerData != null &&
                              workerData is Map<String, dynamic>) {
                            return ListItem(
                              Member: {
                                'First Name': firstName ?? 'N/A',
                                'Last Name': lastName ?? 'N/A',
                                'Description': desc ?? 'N/A',
                                'Pic': pic ?? 'N/A',
                                'PhoneNumber': number ?? 'N/A',
                                'Rating': rating,
                                // 'Rating': rating ,
                              },
                              pageIndex: 0,
                              onPressed: () => navigateToPage1(
                                context,
                                WorkerReview(
                                  previousPage: 'WorkersList',
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container or any other appropriate widget
                          }
                        },
                      );
                    }

                    return CircularProgressIndicator(); // Show loading indicator
                  },
                ),
              )
            ])),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}

void navigateToPage1(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
