// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:provider/provider.dart';
import '../../Domain/customAppBar.dart';
import '../Menu_pages/menu.dart';

class HistoryPage extends StatefulWidget {
  final Map<String, dynamic>? member;

  HistoryPage({Key? key, this.member}) : super(key: key);

  @override
  State<HistoryPage> createState() => _WorkerHistoryPageState();
}

class _WorkerHistoryPageState extends State<HistoryPage> {
  String fname = '';
  String lname = '';
  String desc = '';
  String address = '';
  String Pic = '';
  double Rating = 5.0;
  String PhoneNumber = '';
  String? userId = '';
  String Date = '';
  String Time = '';
  String problemPic = '';
  String commissionFee = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Access worker data after the widget is created
    fname = widget.member?['First Name'] ?? '';
    lname = widget.member?['Last Name'] ?? '';
    desc = widget.member?['Description'] ?? '';
    Date = widget.member?['Date'].toString() ?? '';
    Time = widget.member?['Time'] ?? '';
    problemPic = widget.member?['PhotoURL'] ?? '' as String;
    commissionFee = widget.member?['CommissionFee'] ?? '';
    address = widget.member?['Address'] ?? 'No address available';
    PhoneNumber = widget.member?['PhoneNumber'] ?? '';
    Rating = (widget.member?['Rating'])?.toDouble() ?? 0.0;
    Pic = widget.member?['Pic'] ?? '' as String;

    print("userrrrrrrrrrrrrr: $userId");
  }
  
 


  @override
  Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context);
    bool isUser = userProvider.isUser;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
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
              child: Row(
                children: [
                  CircleAvatar(
                    maxRadius: 30.0,
                    minRadius: 30.0,
                    backgroundColor: Colors.white,
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
                        SizedBox(height: 3),
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      "in $address",
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Raleway",
        color: Colors.black87,
      ),
    ),
    // Conditionally show the favorite icon based on the value of isUser
    isUser==true
        ? GestureDetector(
            onTap: () {
             // Favorites().toggleFavoriteWorker('f', 'f');
            },
            child: Icon(
              Icons.favorite_border,
              color: Color(0xFFBBA2BF),
            ),
          )
        : SizedBox(), // Use SizedBox to hide the icon if isUser is false
  ],
),
     SizedBox(height: 3,),
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
                                SizedBox(width: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                    SizedBox(width: 2),
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
                  'Date: $Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Raleway",
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
                    fontFamily: "Raleway",
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
                "$desc",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Raleway",
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
                    fontFamily: "Raleway",
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
                      labelText: "$commissionFee Egyptian Pound",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFFBBA2BF),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
 
}
