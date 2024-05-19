import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/adminchat.dart';

import '../Menu_pages/History.dart';

class Workererinfo extends StatefulWidget {
  const Workererinfo({Key? key}) : super(key: key);

  @override
  _WorkererinfoState createState() => _WorkererinfoState();
}

class _WorkererinfoState extends State<Workererinfo> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showSearchBox: false,),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('workers')
              .doc(currentUser.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>?;

              if (userData != null) {
                final fname = userData['First Name'] ?? 'No Data';
                final lname = userData['Last Name'] ?? '';
                final email = userData['email'] ?? 'No Data';
                final phoneNumber = userData['PhoneNumber'] ?? 'No Data';
                final about = userData['Type'] ?? 'No Data';
                final rating = userData['Rating'] ?? 0 as double;
                final ProfilePhotoURL = userData['Pic'];

                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.10,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                userData['Pic'] ??
                                    'assets/images/profile.png',
                              ),
                            ),
                              const SizedBox(height: 5),
                              Text(
                                '$fname $lname',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: ListTile(
                                      leading: Icon(Icons.info),
                                      title: Text(
                                        "About",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        about,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  if (phoneNumber != 'No Data')
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: const ListTile(
                                        leading: Icon(Icons.phone),
                                        title: Text(
                                          "Phone Number:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 5),
                                  if (phoneNumber != 'No Data')
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        phoneNumber,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 5),
                                  if (email != '$phoneNumber@domain.com') // Add this condition
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 16),
                                          child: const ListTile(
                                            leading: Icon(Icons.mail),
                                            title: Text(
                                              "Email:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          margin: const EdgeInsets.only(left: 16),
                                          child: Text(
                                            email,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.star,
                                          color: Color.fromRGBO(74, 74, 74, 1),
                                          size: 25),
                                      title: Text(
                                        "Rating:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                      RatingBar.builder(
                    initialRating: rating as double? ?? 0.0,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    unratedColor: Colors.grey,
                    itemCount: 5,
                    itemSize: 25.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (rating) => print(rating),
                  ),
                
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle tap on the message icon
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminChat()));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 16), // Increased the left margin
                              child: const Tooltip(
                                message: "Admin Chat",
                                child: ListTile(
                                  leading: Icon(Icons.message_rounded),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      // Social Media Icons in Row
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Show Orders Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  HistoryWorker()),
                                );
                                // Add your logic for the "Show Orders" button here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFBBA2BF), // Light purple color
                              ),
                              child: const Text(
                                'Show Orders',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('User data is empty');
              }
            } else {
              return Text('No data available');
            }
          },
        ),
        drawer: Menu(scaffoldKey: _scaffoldKey),
      ),
    );
  }
}