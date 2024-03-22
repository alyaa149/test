// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';





class HomeWorker extends StatefulWidget {
  const HomeWorker({super.key});

  @override
  State<HomeWorker> createState() => _HomeWorkerState();
}

class _HomeWorkerState extends State<HomeWorker> {
  final _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> UserRequest = [];

 @override
void initState() {
  super.initState();
  _listenForRequestsUpdates();
}

void _listenForRequestsUpdates() {
  final requestsRef = _firestore.collection('requests');
  requestsRef.snapshots().listen((requestsSnapshot) async {
    UserRequest.clear(); // Clear existing data

    for (final requestDoc in requestsSnapshot.docs) {
      final requestData = requestDoc.data() ?? {};

      if (requestData.containsKey('user') && requestData.containsKey('Description')) {
        final user = requestData['user']; // Assuming user ID is stored here
        final description = requestData['Description'];
        final emergency = requestData['Emergency'];

        // Fetch user details from users collection
        final userRef = _firestore.collection('users').doc(user);
        final userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() ?? {};

          final RequestDetails = {
            'user': user, // Keep user ID for reference
            'Description': description,
            'First Name': userData['First Name'],
            'Last Name': userData['Last Name'],
            'Rating': userData['Rating'].toDouble(), // Convert to double if needed
            'PhoneNumber': userData['PhoneNumber'],
            'Pic': userData['Pic'], // Add 'Pic' if available in users collection
            'Emergency': emergency,
          };

          UserRequest.add(RequestDetails);
        }
      }
    }

    setState(() {}); // Update UI after processing all requests
  });
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey,showSearchBox: false,),
        body:UserRequest.isEmpty // Check if responses are empty
          ? Center( // Center the content within the body
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
      children: [
        CircularProgressIndicator(),
        Text("No requests till now", style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Raleway",
                  color: Colors.black87,
                ),), // Adjust text as needed
      ],
    ),
  )// Display loading indicator
          : SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
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
                      SizedBox(
                        width: 7,
                      ),
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
              //Text
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

              //Workers List
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
                    return ListItem(
                        Member: {   'First Name': requestDetails['First Name'],
                            'Last Name': requestDetails['Last Name'],
                            'Rating': requestDetails['Rating'].toDouble(),
                            'Description': requestDetails['Description'],
                            'Pic': requestDetails['Pic'],
                            'PhoneNumber': requestDetails['PhoneNumber'],},
                        trailingWidget: requestDetails['Emergency'] == true
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset("assets/images/Siren.png"),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset("assets/images/Siren2.png"),
                              ),
                              onPressed: () => navigateToPage1(context,UserReview()),
                        pageIndex: 1);
                  },
                ),
              )
            ])
        ),
        drawer: Menu(scaffoldKey: _scaffoldKey,),
      ),
    );
  }
}
