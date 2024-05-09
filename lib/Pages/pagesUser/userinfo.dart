// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../Domain/customAppBar.dart';
import '../../Domain/user_provider.dart';
import '../Menu_pages/menu.dart';
import 'History.dart';

class user_worker_info extends StatefulWidget {
  const user_worker_info({Key? key}) : super(key: key);

  @override
  _user_worker_infoState createState() => _user_worker_infoState();
}

class _user_worker_infoState extends State<user_worker_info> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isUser = Provider.of<UserProvider>(context).isUser;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: false,
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(isUser
                  ? 'users'
                  : 'workers') // Check user type and choose collection accordingly
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
                final name = userData['First Name'] ?? 'No Data';
                final email = userData['email'] ?? 'No Data';
                final phoneNumber = userData['PhoneNumber'] ?? 'No Data';
                final about = userData['about'] ?? 'No Data';
                double rating = userData['Rating'].toDouble();
                int roundedRating = rating.round();
                final ProfilePhotoURL = userData['Pic'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        // backgroundImage: ProfilePhotoURL != null
                        //   ? NetworkImage(ProfilePhotoURL)
                        //   : AssetImage("assets/images/profile.png"),
                      ),
                      SizedBox(height: 8),
                      Text(
                        name,
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
                                    roundedRating,
                                    (index) =>
                                        Icon(Icons.star, color: Colors.yellow),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
      ),
    );
  }
}
