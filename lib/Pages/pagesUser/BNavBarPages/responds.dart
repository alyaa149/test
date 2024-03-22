// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class Responds extends StatefulWidget {
  const Responds({super.key});

  @override
  _RespondsState createState() => _RespondsState();
}

class _RespondsState extends State<Responds> {
  //const WorkersList({Key? key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _workerResponses = [];
  @override
  void initState() {
    super.initState();
    _WorkerResponsesUpdates();
  }

  void _WorkerResponsesUpdates() {
    final requestDoc = _firestore.collection('requests').doc('2');

    requestDoc.snapshots().listen((requestSnapshot) async {
      if (requestSnapshot.exists) {
        final workerResponsesRef =
            requestSnapshot.reference.collection('workerResponses');

        workerResponsesRef.snapshots().listen((workerResponsesSnapshot) async {
          _workerResponses.clear();

          for (final workerResponseDoc in workerResponsesSnapshot.docs) {
            final workerId = workerResponseDoc.data()['worker'];
            final commissionFee = workerResponseDoc.data()['CommissionFee'];

            final workerRef = _firestore.collection('workers').doc(workerId);
            final workerDoc = await workerRef.get();
            final workerData = workerDoc.data() ?? {};

            final workerDetails = {
              'CommissionFee': commissionFee,
              'First Name': workerData['First Name'],
              'Last Name': workerData['Last Name'],
              'Rating': workerData['Rating'].toDouble(),
              'PhoneNumber': workerData['PhoneNumber'],
              'Pic': workerData['Pic'],
            };

            _workerResponses.add(workerDetails);
          }

          setState(() {}); // Update UI
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
        body: _workerResponses.isEmpty // Check if responses are empty
          ? Center( // Center the content within the body
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
      children: [
        CircularProgressIndicator(),
        Text("Wait for getting responses", style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Raleway",
                  color: Colors.black87,
                ),), // Adjust text as needed
      ],
    ),
  )// Display loading indicator
          :SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              //text
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

              //Workers List
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
                              )),
                        );
                     
                    }),
              )
            ])),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
