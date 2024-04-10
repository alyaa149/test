// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesWorker/home.dart';

class UserReview extends StatefulWidget {
  Map<String, dynamic>? request;
 
  final String? userId;

  UserReview(
      {Key? key,
      required this.request,
      required this.userId,
      })
      : super(key: key);

  static String routeName = 'userreview';

  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  @override
  void initState() {
    super.initState();

    // Access worker data after the widget is created
    fname = widget.request?['First Name'] ?? '';
    lname = widget.request?['Last Name'] ?? '';
    Type = widget.request?['Type'] ?? '';
    Timestamp? Date = widget.request?['Date'] ?? 'no date' as Timestamp?;

    if (Date != null) {
      // Convert timestamp to DateTime
      final dateTime = Date.toDate();
      // Format DateTime as a string, adjust format as needed
      date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    } else {
      date = 'nooooo'; // Default value if Date is null
    }
    print('Dateee  $Date');

    print('dateee  $date');

    Time = widget.request?['Time'] ?? '';
    problemPic = widget.request?['PhotoURL'] ?? '';

    address = widget.request?['Address'] ?? 'No address available';
    print("Address: $address");
    PhoneNumber = widget.request?['PhoneNumber'] ?? '';
    Rating = (widget.request?['Rating'])?.toDouble() ?? 0.0;
    Pic = widget.request?['Pic'] ?? '' as String;
    reqId = widget.request?['id'] ?? '' as String;
    userId = widget.userId ?? 'No';

    TypeReq = widget.request?['TypeReq'] ?? 'No TypeReq available' as String;
    print("TypeReq: $TypeReq");
  }

  final TextEditingController _reviewController = TextEditingController();
  List<String> reviews = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fname = '';
  String lname = '';
  String Type = '';
  String address = '';
  String Pic = '';
  String reqId = '';
  double Rating = 5.0;
  String PhoneNumber = '';
  String? userId = '';
  String date = '';
  String Time = '';
  String problemPic = '';
  String TypeReq = '';
  String textFieldPriceValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 35,
                        backgroundImage: NetworkImage(Pic ?? ''),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  // Wrap the Text widget with Flexible
                                  child: Text(
                                    '$fname' ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Quantico",
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  // Wrap the Text widget with Flexible
                                  child: Text(
                                    '$lname' ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Quantico",
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '$address',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Quantico",
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  '$PhoneNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Quantico",
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.phone,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Date: $date',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Quantico",
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 10.0),
                Icon(
                  Icons.access_time,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Time: $Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Quantico",
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "$Type",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Quantico",
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.photo,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Picture Here',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Quantico",
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Location : $address',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Quantico",
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Color(0xFFBBA2BF),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'The range of Commission Fee : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Raleway",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Egyptian Pound",
                    ),
                    onChanged: (value) {
                      setState(() {
                        textFieldPriceValue = value;
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (TypeReq == 'specified') {
                      print('yessss specified');
       try {
                       
                        CollectionReference workerResponsesCollection =
                            FirebaseFirestore.instance
                                .collection('requests')
                                .doc(reqId)
                                .collection('workerResponses');
                        DocumentReference docRef =
                            await workerResponsesCollection.add({
                          'CommissionFee': textFieldPriceValue,
                          'worker': FirebaseAuth.instance.currentUser!.uid
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('SubCollection created.'),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to create subcollection: $e'),
                        ));
                      }
                      // Insert worker data into appointments collection
                      FirebaseFirestore.instance
                          .collection('appointments')
                          .doc() // Use .doc() to automatically generate a unique document ID
                          // Merge as widget.request doesn't have CommissionFee
                          .set({
                        ...widget.request ?? {},
                        'CommissionFee': '0',
                        'worker': FirebaseAuth.instance.currentUser!.uid
                      }).then((_) {
                       
                      
                        print(
                            'appointment inserted into appointments collection successfully');
                        
                        // Navigate to Home page after inserting data
                         Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeWorker(),
              ));
                        
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Your appointment has been booked successfully!'),
                        ));
                      }).catchError((error) {
                     
                        print(
                            'Failed to insert worker data into appointments collection: $error');
                      });
                    } else {
                        
                      try {
                       
                        CollectionReference workerResponsesCollection =
                            FirebaseFirestore.instance
                                .collection('requests')
                                .doc(reqId)
                                .collection('workerResponses');
                        DocumentReference docRef =
                            await workerResponsesCollection.add({
                          'CommissionFee': textFieldPriceValue,
                          'worker': FirebaseAuth.instance.currentUser!.uid
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('SubCollection created.'),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to create subcollection: $e'),
                        ));
                      }
                     
                                Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeWorker(),
              ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBA2BF),
                    padding: EdgeInsets.symmetric(
                      horizontal: 77,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: Text(
                    "Response",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[850],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Menu(
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}
