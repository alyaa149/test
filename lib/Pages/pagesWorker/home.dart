// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Domain/customAppBar.dart';
import '../../Domain/listItem.dart';
import '../Menu_pages/menu.dart';
import '../pagesUser/BNavBarPages/workerslist.dart';
import 'UserReview.dart';

class HomeWorker extends StatefulWidget {
  const HomeWorker({Key? key});

  @override
  State<HomeWorker> createState() => _HomeWorkerState();
}

class _HomeWorkerState extends State<HomeWorker> {
  final _firestore = FirebaseFirestore.instance;
  late DocumentReference userRef;
  List<Map<String, dynamic>> UserRequest = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _listenForRequestsUpdates();
  }

  Future<DocumentSnapshot> _getUserDetails(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userSnapshot = await userRef.get();
      return userSnapshot;
    } catch (e) {
      print('Error fetching user details: $e');
      throw e;
    }
  }

 
  Future<String> _getWorkerService(String workerId) async {
    try {
      final workerRef = _firestore.collection('workers').doc(workerId);
      final workerSnapshot = await workerRef.get();
      final service = workerSnapshot.data()?['Service'] ?? '';
      return service;
    } catch (e) {
      print('Error fetching worker details: $e');
      throw e;
    }
  }

 void _listenForRequestsUpdates() async {
  // CollectionReference appointmentsCollection =
  //     FirebaseFirestore.instance.collection('appointments');

  // QuerySnapshot querySnapshot = await appointmentsCollection.get();

  // querySnapshot.docs.forEach((doc) {
  //   doc.reference.delete();
  // });
  
  final workerDoc = FirebaseAuth.instance.currentUser!.uid;
  final workerService = await _getWorkerService(workerDoc);
  final requestsRef = _firestore.collection('requests').where('service', isEqualTo: workerService);

  requestsRef.snapshots().listen((requestsSnapshot) async {
    UserRequest.clear(); // Clear existing data

    for (final requestDoc in requestsSnapshot.docs) {
      final requestData = requestDoc.data() ?? {};
      final requestId = requestDoc.id;

      bool hasResponse = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .collection('workerResponses')
          .where('worker', isEqualTo: workerDoc)
          .get()
          .then((querySnapshot) => querySnapshot.docs.isNotEmpty)
          .catchError((error) {
        print('Error checking worker responses: $error');
        return false; // Return false in case of an error
      });
    //   final isActive = requestData['isActive'];
      if (!hasResponse ) {
        if (requestData.containsKey('user')) {
          final user = requestData['user'];
          final description = requestData['Description'];
          final emergency = requestData['Emergency'];
          final Address = requestData['Address'] ?? 'nooooo';
          final problemPhoto = requestData['PhotoURL'] ?? 'nooooo';
          final TypeReq = requestData['TypeReq'] ?? 'nooooo TypeReq';
          final dateTimestamp = requestData['Date'] as Timestamp?;
          final time = requestData['Time'] as String ?? 'nooooo';

          userRef = _firestore.collection('users').doc(user);
          final userSnapshot = await userRef.get();

          if (userSnapshot.exists) {
            final Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

            final RequestDetails = {
              'user': user,
              'Type': description,
              'First Name': userData?['First Name'],
              'Last Name': userData?['Last Name'],
              'Rating': userData?['Rating'].toDouble(),
              'PhoneNumber': userData?['PhoneNumber'],
              'Pic': userData?['Pic'],
              'Emergency': emergency,
              'Address': Address,
              'Date': dateTimestamp,
              'Time': time,
              'PhotoURL': problemPhoto,
              'worker': workerDoc,
              'TypeReq': TypeReq,
              'id': requestId
            };

            UserRequest.add(RequestDetails);
          }
        }
      }
    }

    setState(() {}); // Update UI after processing all requests
  });
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: false,
        ),
        body: UserRequest.isEmpty
            ? _buildEmptyRequests() // Display loading indicator
            : _buildRequestsList(),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }

  Widget _buildEmptyRequests() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(
            "No requests till now",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Raleway",
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Color.fromARGB(31, 125, 124, 124),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.black26,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/Siren.png"),
                  SizedBox(width: 7),
                  Text(
                    "For Emergency",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Raleway",
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 6,
            child: Text(
              "Today Requests:",
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
              itemCount: UserRequest.length,
              itemBuilder: (context, itemCount) {
                final requestDetails = UserRequest[itemCount];
                return FutureBuilder(
                  future: _getUserDetails(requestDetails['user']),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final dynamic userData = snapshot.data?.data() ?? {};
                      print(snapshot.data?.id);

                      return ListItem(
                        Member: {
                          'First Name': userData['First Name'],
                          'Last Name': userData['Last Name'],
                          'Rating': userData['Rating'].toDouble(),
                          'Type': requestDetails['Type'],
                          'Pic': userData['Pic'],
                          'PhoneNumber': userData['PhoneNumber'],
                        },
                        trailingWidget: requestDetails['Emergency'] == true
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset("assets/images/Siren.png"),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset("assets/images/Siren2.png"),
                              ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserReview(
                                request: requestDetails,
                                userId: snapshot.data?.id ?? '',
                              
                              ),
                            ),
                          );
                        },
                        pageIndex: 1,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
