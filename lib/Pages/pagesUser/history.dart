import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/pagesUser/toqaHistoryUser.dart';
import '../../Domain/customAppBar.dart';
import '../../Domain/listItem.dart';
import '../Menu_pages/menu.dart';
import 'BNavBarPages/workerslist.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                    .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                        final workerId = appointmentDoc.get('worker');
                        final commissionFee =
                            appointmentDoc.get('CommissionFee');
                        final photourl = appointmentDoc.get('PhotoURL');
                        final address = appointmentDoc.get('Address');
                        final dateTimestamp =
                            appointmentDoc.get('Date') as Timestamp?;
                        final time = appointmentDoc.get('Time');
                        String date;
                        if (dateTimestamp != null) {
                          final dateTime = dateTimestamp.toDate();
                          date =
                              '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                        } else {
                          date = 'nooooo'; // Default value if Date is null
                        }
                        final description = appointmentDoc.get('Type');
                        final emergency = appointmentDoc.get('Emergency');
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('workers')
                              .doc(workerId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final firstName =
                                  snapshot.data!.get('First Name');
                              final lastName = snapshot.data!.get('Last Name');
                              final pic = snapshot.data!.get('Pic');
                              final phone = snapshot.data!.get('PhoneNumber');
                              final rating =
                                  snapshot.data!.get('Rating').toDouble();
                              print("dadadadadadada:  $date");

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
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: Image.asset(
                                            "assets/images/Siren.png"),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
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
                                      'PhotoURL': photourl
                                    })),
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
          ]),
        ),
        drawer: Menu(
          scaffoldKey: scaffoldKey,
        ),
      ),
    );
  }
}
