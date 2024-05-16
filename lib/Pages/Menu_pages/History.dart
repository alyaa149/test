import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';

import 'package:gradd_proj/Pages/toqaHistoryUser.dart';
import '../../Domain/customAppBar.dart';
import '../../Domain/listItem.dart';
import '../Menu_pages/menu.dart';


class HistoryWorker extends StatefulWidget {
  @override
  State<HistoryWorker> createState() => _HistoryWorkerState();
}

class _HistoryWorkerState extends State<HistoryWorker> {
  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('appointments')
                    .where('worker',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final documents = snapshot.data!.docs;
                    if (documents.isEmpty) {
                      return Container(
                        child: const Center(
                          child: Text(
                            "No Appointments yet",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "Raleway"),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final appointmentDoc = documents[index];
                        final appointmentId = appointmentDoc.id;
                        final userId = appointmentDoc.get('user');
                        final dateTimestamp =
                            appointmentDoc.get('Date') as Timestamp?;
                        final time = appointmentDoc.get('Time');
                        String date;
                        String day;
                        String dayOfWeek;

                        //String days;
                        if (dateTimestamp != null) {
                          final dateTime = dateTimestamp.toDate();
                          date =
                              '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                          final days = [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ];

                          // Get the index of the day of the week (0 for Monday, 1 for Tuesday, etc.)
                          final dayIndex = dateTime.weekday - 1;
                          // Get the day of the week name using the index
                          dayOfWeek = days[dayIndex];
                        } else {
                          date = 'nooooo';
                          dayOfWeek = 'no'; // Default value if Date is null
                        }
                        final description = appointmentDoc.get('Type');

                        final emergency = appointmentDoc.get('Emergency');

                        String commissionFee =
                            appointmentDoc.get('CommissionFee');
                        final photourl = appointmentDoc.get('PhotoURL');
                        final address = appointmentDoc.get('Address');

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.data!.exists) {
                                final firstName =
                                    snapshot.data!.get('First Name');
                                final lastName =
                                    snapshot.data!.get('Last Name');
                                final pic = snapshot.data!.get('Pic');
                                final phone = snapshot.data!.get('PhoneNumber');
                                final rating =
                                    snapshot.data!.get('Rating').toDouble();
                                return ListItem(
                                  Member: {
                                    'First Name': firstName,
                                    'Last Name': lastName,
                                    'Pic': pic,
                                    'PhoneNumber': phone,
                                    'Rating': rating,
                                    'CommissionFee': commissionFee
                                  },
                                  trailingWidget: emergency == true
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
                                      context,
                                      HistoryPage(member: {
                                        'First Name': firstName,
                                        'Last Name': lastName,
                                        'Pic': pic,
                                        'PhoneNumber': phone,
                                        'Rating': rating,
                                        'CommissionFee': commissionFee,
                                        'Address': address,
                                        'Description': description,
                                        'Date': date,
                                        'Time': time,
                                        'PhotoURL': photourl,
                                        'userId': userId,
                                        'appointmentId': appointmentId,
                                        'day': dayOfWeek
                                      })),
                                  pageIndex: 3,
                                );
                              } else {
                                return Center(
                                  child: Text("no"),
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            )
          ]),
        ),
        drawer: Menu(
          scaffoldKey: scaffoldKey,
        ),
      ),
    );
  }
}
