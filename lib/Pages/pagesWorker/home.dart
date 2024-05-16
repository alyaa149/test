// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradd_proj/Domain/WokerBottomNavBar.dart';
import 'package:gradd_proj/Pages/Subscription_Pages/packagesPage.dart';
import '../../Domain/customAppBar.dart';
import '../../Domain/listItem.dart';
import '../Menu_pages/menu.dart';

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
  final String worker_id = FirebaseAuth.instance.currentUser!.uid ?? 'No';
  bool result = false;
  
  Future<void> processAdminsPackagesRequests() async {
    // Reference to the "adminsPackagesRequests" collection
    CollectionReference adminsPackagesRef =
        FirebaseFirestore.instance.collection('adminsPackagesRequests');

    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Get documents from the collection
        QuerySnapshot querySnapshot = await adminsPackagesRef.get();

        // Iterate through each document
        querySnapshot.docs.forEach((document) {
          // Extract fields from the document
          String worker =
              document['worker_id']; // Assuming field name is 'worker'
          bool isRead = document['isRead'];
          String isConfirmed = document['isConfirmed'];
          print('$isRead   $isConfirmed');
          // Check if the worker field matches the current user's ID
          if (worker == currentUser.uid) {
            // Call another function based on conditions
            if (!isRead && isConfirmed == "confirmed") {
              showPackageDialog(
                  "Successful payment, Now you're in a new package!");
              document.reference.update({'isRead': true});
            } else if (!isRead && isConfirmed == "deleted") {
              showPackageDialog(
                  "Your package request is rejected, please Enter a correct Reference or chat with admins!");
              document.reference.update({'isRead': true});
            }
          }
        });
      } else {
        print("Current user is null.");
      }
    } catch (e) {
      print("Error fetching adminsPackagesRequests: $e");
    }
  }

  void showPackageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Quantico",
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackagesPage(),
                    ),
                  );
                },
                child: Text(
                  'Chat With admin',
                ),
              ),
              TextButton(
                onPressed: () {
                   Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BottomNavBarWorker(),
                  //   ),
                  // );
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> subscribedOrNot(int countArray) async {
    try {
      // Query Firestore to count appointments where the worker field matches the currentUserID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('worker', isEqualTo: worker_id)
          .get();
      final currentcount = querySnapshot.size;
      print('print appointment currentcount $currentcount');
      print('print countArray $countArray ');

      if (((currentcount <= 5)) || (currentcount <= countArray)) {
        print(
            'print inside if ,currentcount  = $currentcount   <  countArray = $countArray  ');
        return true;
      } else {
        print(
            'print outside if ,currentcount  =$currentcount >  countArray = $countArray ');
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Error counting appointments: $e');
      return false; // Return -1 to indicate an error
    }
  }

  Future<int> countPackageNumbers(List<dynamic> packageIds) async {
    int totalPNumbers = 5;
    // Loop through each package id
    for (String packageId in packageIds) {
      // Reference to the package document
      DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .get();

      // Check if the package document exists and data is not null
      if (packageSnapshot.exists && packageSnapshot.data() != null) {
        // Cast data to Map<String, dynamic>
        Map<String, dynamic> data =
            packageSnapshot.data() as Map<String, dynamic>;
        // Get the P_number field value
        int? pNumber = data['P_number'] as int?;
        // Check if pNumber is not null before adding to the total
        if (pNumber != null) {
          totalPNumbers += pNumber;
        }
      }
    }
    return totalPNumbers;
  }

  void showAppointmentLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text(
              'Appointments Limit Exceeded',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Quantico",
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            content: Text(
              'Subscribe to make more appointments !',
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Quantico",
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackagesPage(),
                    ),
                  );
                },
                child: Text(
                  'Subscribe Now!',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _listenForRequestsUpdates();
    processAdminsPackagesRequests();
    print('print cuurent worker${FirebaseAuth.instance.currentUser!.uid}');
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

  Future<Map<String, dynamic>> _getWorkerDetails(String workerId) async {
    try {
      final workerRef =
          FirebaseFirestore.instance.collection('workers').doc(workerId);
      final workerSnapshot = await workerRef.get();
      final service = workerSnapshot.data()?['Service'] ?? '';
      final city = workerSnapshot.data()?['City'] ?? '';
      return {'service': service, 'city': city};
    } catch (e) {
      print('Error fetching worker details: $e');
      throw e;
    }
  }

  void _listenForRequestsUpdates() async {
    final workerDoc = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> workerDetails = await _getWorkerDetails(workerDoc);
    String service = workerDetails['service'];
    String city = workerDetails['city'];
    print('print service : $service   city : $city');
    final requestsRef = _firestore
        .collection('requests')
        .where('service', isEqualTo: service)
        .where('City', isEqualTo: city);

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

        if (!hasResponse) {
          if (requestData.containsKey('user')) {
            final TypeReq = requestData['TypeReq'] ?? 'nooooo TypeReq';
            final worker = requestData['worker'] ?? '';
            print('worker :  $worker     current worker : $worker_id');

            final user = requestData['user'];
            final description = requestData['Description'];
            final emergency = requestData['Emergency'];
            final Address = requestData['Address'] ?? 'nooooo';
            final problemPhoto = requestData['PhotoURL'] ?? 'nooooo';

            final dateTimestamp = requestData['Date'] as Timestamp?;
            final time = requestData['Time'] as String ?? 'nooooo';

            userRef = _firestore.collection('users').doc(user);
            final userSnapshot = await userRef.get();

            if (userSnapshot.exists) {
              final Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;

              final DocumentSnapshot workerSnapshot = await FirebaseFirestore
                  .instance
                  .collection('workers')
                  .doc(worker_id)
                  .get();

              final Map<String, dynamic>? workerData =
                  workerSnapshot.data() as Map<String, dynamic>?;

              final isAvailable24h = workerData?['Emergency'] ?? false;
              List<dynamic> packagesId = workerData?['packagesId'] ?? ['0'];
              final countArray = await countPackageNumbers(packagesId);
              result = await subscribedOrNot(countArray);
              print('print subscribedOrNot : $result');
              print(isAvailable24h);

              // Check the specific condition
              if ((isAvailable24h) || (!isAvailable24h && !emergency)) {
                if ((TypeReq == 'specified' && worker == worker_id) ||
                    (TypeReq == 'general')) {
                  final RequestDetails = {
                    'user': user,
                    'Type': description ?? ' No Disc',
                    'First Name': userData?['First Name'] ?? 'No First',
                    'Last Name': userData?['Last Name'] ?? 'No last',
                    'Rating': userData?['Rating'].toDouble() ?? 'No Rating',
                    'PhoneNumber': userData?['PhoneNumber'] ?? 'No Phone',
                    'Pic': userData?['Pic'].isEmpty
                        ? 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
                        : userData?['Pic'],
                    'Emergency': emergency ?? 'no emergency',
                    'Address': Address ?? 'No Address',
                    'Date': dateTimestamp ?? '',
                    'Time': time ?? '',
                    'PhotoURL': problemPhoto ?? '',
                    'worker': workerDoc,
                    'TypeReq': TypeReq ?? '',
                    'id': requestId,
                  };

                  if (mounted) {
                    // Check if the widget is still mounted
                    UserRequest.add(RequestDetails);
                    setState(() {}); // Update UI after processing each request
                  }
                }
              }
            }
          }
        }
      }
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
                          if (result == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserReview(
                                  request: requestDetails,
                                  userId: snapshot.data?.id ?? '',
                                ),
                              ),
                            );
                          } else {
                            print('print result inside else $result ');
                            showAppointmentLimitDialog(context);
                          }
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
