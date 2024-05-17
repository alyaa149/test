import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/Menu_pages/History.dart';
import 'package:gradd_proj/Pages/pagesWorker/workerInfo.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:provider/provider.dart';

import '../../Domain/WokerBottomNavBar.dart';
import '../../Domain/bottom.dart';
import '../../Domain/customAppBar.dart';
import '../../Domain/user_provider.dart';
import '../pagesUser/History.dart';
import '../pagesUser/reqEmergency.dart';
import '../pagesUser/userinfo.dart';

import '../welcome.dart';
import 'aboutApp.dart';
import 'settingsPage.dart';

class MenuDrawerPage extends StatefulWidget {
  const MenuDrawerPage({Key? key}) : super(key: key);

  @override
  _MenuDrawerPageState createState() => _MenuDrawerPageState();
}

class _MenuDrawerPageState extends State<MenuDrawerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        // firestore: FirebaseFirestore.instance,
        //collection: FirebaseFirestore.instance.collection('services'),
      ),
      drawer: Menu(scaffoldKey: _scaffoldKey),
    );
  }
}

class Menu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  Menu({Key? key, required this.scaffoldKey}) : super(key: key);
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isUser = userProvider.isUser;
    return Drawer(
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        child: Container(
          color: const Color(0xFFBBA2BF),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFFBBA2BF),
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                          stream: currentUser.currentUser != null
                              ? FirebaseFirestore.instance
                                  .collection(isUser ? "users" : "workers")
                                  .doc(currentUser.currentUser!.uid)
                                  .snapshots()
                              : null, // If currentUser is null, pass null to the stream
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('User data not found');
                            }

                            // Once data is available, extract the username from the snapshot
                            Map<String, dynamic>? userData =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (userData == null ||
                                !userData.containsKey('First Name') ||
                                !userData.containsKey('Last Name')) {
                              return Text('User data is incomplete');
                            }

                            String firstName = userData['First Name'];
                            String lastName = userData['Last Name'];

                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    userData?['Pic'] ??
                                        'assets/images/profile.png',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$firstName $lastName',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onTap: () {
                    if (isUser == true) {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const BottomNavBarUser(), withNavBar: false);
                    } else {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const BottomNavBarWorker(),
                          withNavBar: false);
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onTap: () {
                    // // Check user role here
                    // bool isUser = true; // Replace with actual user role check

                    if (isUser) {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const userinfo(), withNavBar: false);
                    } else {
                        PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const Workererinfo(), withNavBar: false);
                    }
                  },
                ),
                const Divider(),
                if (isUser)
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text(
                      'History',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: History(), withNavBar: false);
                    },
                  ),
                if (isUser) const Divider(),
                if (isUser)
                  ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: const Text(
                      'Emergency',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const ReqEmergency(), withNavBar: false);
                    },
                  ),
                // if(!isUser)
                // const Divider(),
                if (!isUser)
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text(
                      'Appointments',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: HistoryWorker(), withNavBar: false);
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text(
                    'AboutApp',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutApp()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: SettingsPage());
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(45),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(234, 0, 0, 0),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Log Out'),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        // Navigate to the welcome screen after successful logout
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: Welcome(), withNavBar: false);
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Log out Successful"),
                              content:
                                  Text("You have successfully logged out."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        print('Error logging out: $e');
                        // Handle any errors that occur during logout
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
