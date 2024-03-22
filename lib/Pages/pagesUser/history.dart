// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
// List<Map<String, dynamic>> recentWorkers = getRecentWorkers();
// List<Map<String, dynamic>> previousRequests = getPreviousRequests();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: scaffoldKey,
          showSearchBox: true,
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              //text
              Positioned(
                top: 70,
                left: 6,
                child: Text(
                  "Appointments :",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Quantico",
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
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('appointments')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is being fetched, show a loading indicator or placeholder
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If an error occurred during data fetching, display an error message
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // If data fetching is successful, display the worker's first names
                      final documents = snapshot.data!.docs;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final appointmentDoc = documents[index];
                          final workerId = appointmentDoc.get('worker');
                          final commissionFee =
                              appointmentDoc.get('CommissionFee');

                          final emergency = appointmentDoc.get('Emergency');
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('workers')
                                .doc(workerId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While data is being fetched, show a loading indicator or placeholder
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // If an error occurred during data fetching, display an error message
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // If data fetching is successful, display the worker's first name
                                final firstName =
                                    snapshot.data!.get('First Name');
                                final lastName =
                                    snapshot.data!.get('Last Name');
                                final pic = snapshot.data!.get('Pic');
                                final phone = snapshot.data!.get('PhoneNumber');
                                final rating =
                                    snapshot.data!.get('Rating').toDouble();
                                if (commissionFee == null) {
                                  print(
                                      "commmissssssssssssssssionnnnnnn : Error");
                                } else {
                                  print(
                                      "commmissssssssssssssssionnnnnnn : ${commissionFee ?? 'null'}");
                                }
                                return ListItem(
                                  Member: {
                                    'First Name': firstName,
                                    'Last Name': lastName,
                                    'Pic': pic,
                                    'PhoneNumber': phone,
                                    'Rating': rating,
                                    'CommissionFee': commissionFee
                                  },
                                  trailingWidget: emergency == 'true'
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                              "assets/images/Siren.png"),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                              "assets/images/Siren2.png"),
                                        ),
                                  onPressed: () => navigateToPage1(
                                      context, WorkerHistoryPage()),
                                  pageIndex: 3,
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ])),
        drawer: Menu(
          scaffoldKey: scaffoldKey,
        ),
      ),
    );
  }
}


