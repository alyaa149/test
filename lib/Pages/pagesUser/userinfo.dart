import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';

class userinfo extends StatefulWidget {
  const userinfo({Key? key}) : super(key: key);

  @override
  _userinfoState createState() => _userinfoState();
}

class _userinfoState extends State<userinfo> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: false,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
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
                final about = userData['about'] ?? 'No Data';
                final rating = userData['Rating'] ?? 0;
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    Row(
                                      children: List.generate(
                                            rating
                                                .floor(), // Get the integer part of the rating
                                            (index) => Icon(Icons.star,
                                                color: Colors.yellow),
                                          ) +
                                          List.generate(
                                            (rating * 10 % 10)
                                                .toInt(), // Get the decimal part of the rating
                                            (index) => Icon(Icons.star_half,
                                                color: Colors.yellow),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle FloatingActionButton press
          },
          backgroundColor: const Color(0xFFBBA2BF),
          shape: const CircleBorder(),
          child: const Icon(Icons.add_chart_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        drawer: Menu(scaffoldKey: _scaffoldKey),
      ),
    );
  }
}
