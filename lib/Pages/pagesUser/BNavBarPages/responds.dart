// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';
import '../../../Domain/customAppBar.dart';
import '../../../Domain/listItem.dart';
import '../workerReview.dart';

class Responds extends StatefulWidget {
  final String? requestDocId;
  Responds({required this.requestDocId});

  @override
  _RespondsState createState() => _RespondsState();
}

class _RespondsState extends State<Responds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _workerResponses = [];

  @override
  void initState() {
    super.initState();
    _workerResponsesUpdates();
  }
void _workerResponsesUpdates() {
  final requestDoc = _firestore.collection('requests').doc(widget.requestDocId);
  requestDoc.get().then((requestSnapshot) {
    if (requestSnapshot.exists) {
      final data = requestSnapshot.data();
      final emergency = data?['Emergency'] ?? 'no emergency';
      final photoURL = data?['PhotoURL'] ?? 'noooooo photo';
      final time = data?['Time']  ?? 'noooooo time';
      final date = data?['Date']  ?? 'noooooo date' as Timestamp? ;
      final address = data?['Address']  ?? 'noooooo address' ;
      final descOfproblem = data?['Description']  ?? 'noooooo desc' ;

      final workerResponsesRef = requestSnapshot.reference.collection('workerResponses');
      
      // Listen for real-time updates
      workerResponsesRef.snapshots().listen((workerResponsesSnapshot) {
        _workerResponses.clear();

        for (final workerResponseDoc in workerResponsesSnapshot.docs) {
          final workerId = workerResponseDoc.data()['worker'];
          final commissionFee = workerResponseDoc.data()['CommissionFee'];

          String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
          final workerRef = _firestore.collection('workers').doc(workerId);
          final workerData = workerRef.get().then((workerDoc) {
            final workerData = workerDoc.data() ?? {};

            final workerResponseDetails = {
              'worker': workerId,
              'CommissionFee': commissionFee,
              'First Name': workerData['First Name'],
              'Last Name': workerData['Last Name'],
              'Rating': workerData['Rating'].toDouble(),
              'PhoneNumber': workerData['PhoneNumber'],
            
              'Date': date,
              'Type': descOfproblem,
              'Pic': workerData['Pic'],
              'service': workerData['Service'],
              'Emergency': emergency,
              'PhotoURL': photoURL ?? 'noooooo photo',
              'Time': time,
              'user': currentUserId,
              'Address': address,
            };

            _workerResponses.add(workerResponseDetails);
            setState(() {}); // Update UI
          });
        }
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: true,
        ),
        body: _workerResponses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Wait for getting responses",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Raleway",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 70,
                      left: 6,
                      child: Text(
                        "Choose one of the responses:",
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
                    Positioned(
                      top: 120,
                      right: 5,
                      left: 5,
                      bottom: 0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: _workerResponses.length,
                        itemBuilder: (context, itemCount) {
                          final workerResponse = _workerResponses[itemCount];
                          print(
                              'Date::::::::::::: ${workerResponse['Date']}, Emergency::::::: ${workerResponse['Emergency']}, problem::::::: ${workerResponse['Type']},Emergency::::::: ${workerResponse['Emergency']}, Time::::::: ${workerResponse['Time']},Address::::::: ${workerResponse['Address']}');
                          return ListItem(
                            Member: {
                              'First Name': workerResponse['First Name'],
                              'Last Name': workerResponse['Last Name'],
                              'Rating': workerResponse['Rating'].toDouble(),
                              'CommissionFee': workerResponse['CommissionFee'],
                              'Pic': workerResponse['Pic'],
                              'PhoneNumber': workerResponse['PhoneNumber'],
                            },
                            pageIndex: 2,
                            onPressed: () => navigateToPage1(
                              context,
                              WorkerReview(
                                previousPage: 'Responds',
                                worker: workerResponse,
                                workerId: workerResponse['workerID'],
                                requestId: widget.requestDocId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
