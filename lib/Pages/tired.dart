// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:url_launcher/url_launcher.dart';


class WorkerRequest extends StatefulWidget {
  const WorkerRequest({Key? key}) : super(key: key);

  @override
  _WorkerRequestState createState() => _WorkerRequestState();
}

class _WorkerRequestState extends State<WorkerRequest> {
  late Stream<List<Map<String, dynamic>>> _workerDataStream;
  int _selectedIndex = 0;
  String serviceName = '';

  @override
  void initState() {
    super.initState();
    _workerDataStream = _streamWorkerData();
  }

  Stream<List<Map<String, dynamic>>> _streamWorkerData() {
    return FirebaseFirestore.instance
        .collection('workerRequests')
        .where('isConfirmed', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((snapshot) async {
      final docs = snapshot.docs;
      final workerData = await Future.wait(docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final serviceId = data['Service'];
        final service = await FirebaseFirestore.instance
            .collection('services')
            .doc(serviceId)
            .get();
        //=================
 

        //==================
        final serviceName = service['name'];
        print('email: ${data['email'] ?? 'null'}');
        print('First Name: ${data['First Name'] ?? 'null'}');
        print('Last Name: ${data['Last Name'] ?? 'null'}');
        print('PhoneNumber: ${data['PhoneNumber'] ?? 'null'}');
        print('about: workerr');
        print('Pic: ${data['Pic'] ?? 'null'}');
        print('Date: ${data['Date'] ?? 'null'}');
        print('Type: ${data['Type'] ?? 'null'}');
        print('Service: $serviceId');
        print('serviceName: $serviceName');
        print('National-ID: ${data['National-ID'] ?? 'null'}');
        print('Emergency: ${data['Emergency'] ?? 'null'}');
        print('City: ${data['City'] ?? 'null'}');
        print('isConfirmed: ${data['isConfirmed' ?? 'null']}');
        print('documentId: ${doc.id}' ?? 'null');
         print('National-ID: ${data['National-ID'] ?? 'null'}');
        print('Reference Number: ${data['Reference Number' ?? 'null']}');
        print('Feesh Pic: ${data['Reference Number' ?? 'null']}' ?? 'null');
        return {
          'email': data['email'] ?? '',
          'First Name': data['First Name'] ?? '',
          'Last Name': data['Last Name'] ?? '',
          'PhoneNumber': data['PhoneNumber'] ?? '',
          'about': 'workerr',
          'Pic': data['Pic'] ?? '',
          'Date': data['Date'] ?? '',
          'Type': data['Type'] ?? '',
          'Service': serviceId,
          'serviceName': serviceName,
          'National-ID': data['National-ID'] ?? '',
          'Emergency': data['Emergency'] ?? '',
          'City': data['City'] ?? '',
          'isConfirmed': data['isConfirmed'],
          'documentId': doc.id,
          'Reference Number': data['Reference Number'],
          'National-ID Pic' : data['National-ID Pic'],
          'Feesh Pic' : data['Feesh Pic'],
        };
      }));
      return workerData;
    });
  }

  void _ApproveRequest(String documentId) async {
    print('documentId  $documentId');
    final dateTimestamp = DateTime.now();
    // Fetch necessary data from workerRequests based on documentId
    DocumentSnapshot<Map<String, dynamic>> workerSnapshot =
        await FirebaseFirestore.instance
            .collection('workerRequests')
            .doc(documentId)
            .get();

    try {
      if (workerSnapshot.exists) {
        print('exist');
        // Retrieve data from the document
        Map<String, dynamic> data = workerSnapshot.data()!;
        print('data');
        FirebaseAuth instancee = FirebaseAuth.instance;
        print('instancee');
        print(
            'data[email] ${data['email']} data[password] ${data['password']} ');
        UserCredential userCredential =
            await instancee.createUserWithEmailAndPassword(
          email: data['email'],
          password: data['password'],
        );
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        print('userCredential.user!.uid  :   ${userCredential.user!.uid}');
        await FirebaseFirestore.instance
            .collection('workerRequests')
            .doc(documentId)
            .update({
          'isConfirmed': 'confirmed',
          'worker': userCredential.user!.uid
        });

        print('updated ,confirmed');

        await FirebaseFirestore.instance
            .collection('workers')
            .doc(userCredential.user!.uid)
            .set({
          'email': data['email'] ?? '',
          'First Name': data['First Name'] ?? '',
          'Last Name': data['Last Name'] ?? '',
          'PhoneNumber': data['PhoneNumber'] ?? '',
          'type': 'worker',
          'Rating': 0,
          'about': 'workerr',
          'Pic': data['Pic'] ?? '',
          'NumberOfRating': 0,
          'Date': dateTimestamp ?? '',
          'Type': data['Type'] ?? '',
          'Service': data['Service'] ?? '',
          'National-ID': data['National-ID'] ?? '',
          'Emergency': data['Emergency'] ?? false,
          'City': data['City'] ?? '',
          'isConfirmed': 'confirmed',
          'isDeleted': false,
          'reviews': {},
          'packagesId': [],
          'Reference Number': data['Reference Number'] ?? 'null',
          'National-ID Pic' : data['National-ID Pic'] ?? 'null' ,
          'Feesh Pic' : data['Feesh Pic'] ?? 'null',
        });
        print('submitted ');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Worker details not found')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Failed to accept the request ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // NavigationRail(
          //   backgroundColor: const Color.fromARGB(251, 176, 137, 202),
          //   unselectedIconTheme:
          //       const IconThemeData(color: Colors.white, opacity: 1),
          //   unselectedLabelTextStyle: const TextStyle(color: Colors.white),
          //   selectedIconTheme:
          //       const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
          //   destinations: const [
          //     NavigationRailDestination(
          //       icon: Icon(Icons.home),
          //       label: Text("Home"),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.chat),
          //       label: Text("Users Chat"),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.chat),
          //       label: Text("Workers Chat"),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.request_quote),
          //       label: Text("Request"),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.app_registration_sharp),
          //       label: Text("Request"),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.logout),
          //       label: Text("Logout"),
          //     ),
          //   ],
          //   selectedIndex: _selectedIndex,
          //   onDestinationSelected: (int index) {
          //     setState(() {
          //       _selectedIndex = index;
          //       if (index == 0) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => home()),
          //         );
          //       } else if (index == 1) {
          //         // Navigate to Users Chat
          //       } else if (index == 2) {
          //         // Navigate to Workers Chat
          //       } else if (index == 3) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => request()),
          //         );
          //       } else if (index == 4) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => WorkerRequest()),
          //         );
          //       } else if (index == 5) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => Login()),
          //         );
          //       }
          //     });
          //   },
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _streamWorkerData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final List<Map<String, dynamic>> workers =
                              snapshot.data!;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      const Color.fromARGB(255, 194, 173, 202)),
                              columns: const [
                                DataColumn(label: Text('Username')),
                                DataColumn(label: Text('National ID')),
                                DataColumn(label: Text('Service')),
                                DataColumn(label: Text('Emergency')),
                                DataColumn(label: Text('Phone Number')),
                                DataColumn(label: Text('description')),
                                DataColumn(
                                    label: Text(
                                        '  Certificate of \n Criminal Record')),
                                DataColumn(label: Text('ID Image')),
                                DataColumn(label: Text('Pro photo')),
                                DataColumn(
                                    label:
                                        Text('    Reference \n Phone Number')),
                                DataColumn(label: Text('    Action')),
                              ],
                              rows: workers.map((worker) {
                                final nationalID =
                                    worker['National-ID'].toString();
                                final service =
                                    worker['serviceName'].toString();
                                final emergency =
                                    worker['Emergency'].toString();
                                final phoneNumber =
                                    worker['PhoneNumber'].toString();
                                final firstname =
                                    worker['First Name'].toString();
                                final lastname = worker['Last Name'].toString();
                                final desc = worker['Type'].toString();
                                final ref =
                                    worker['Reference Number'].toString();
                                final Pic = worker['Pic'].toString();
                                return DataRow(cells: [
                                  DataCell(Text('$firstname $lastname')),
                                  DataCell(Text(nationalID)),
                                  DataCell(Text(service)),
                                  DataCell(Text(emergency)),
                                  DataCell(Text(phoneNumber)),
                                  DataCell(Text(desc)),
//
                                  // // el fesh image
                                  //   GestureDetector(
                                  //     onTap: () {
                                  //       //  print("data['photoUrl'] ${data['photoUrl']}",);
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return AlertDialog(
                                  //             content: Container(
                                  //               width: double.maxFinite,
                                  //               child: Image.network(
                                  //                 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
                                  //                 "{data['photoUrl']}",
                                  //                 scale: 1.0,
                                  //                 fit: BoxFit.contain,
                                  //                 errorBuilder: (context, error,
                                  //                     stackTrace) {
                                  //                   print(
                                  //                       'Error loading image: $error');
                                  //                   return Text(
                                  //                       'Error loading image: $error');
                                  //                 },
                                  //               ),
                                  //             ),
                                  //           );
                                  //         },
                                  //       );
                                  //     },
                                  //     child: Text(
                                  //       'Image',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontFamily: "Raleway",
                                  //         color: Colors.blue,
                                  //         decoration: TextDecoration.underline,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                 DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        //  print("data['photoUrl'] ${data['photoUrl']}",);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: double.maxFinite,
                                                child: Image.network(
                                                  //'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
                                                  // "{data['photoUrl']}",
                                                  worker['Feesh Pic'],
                                                  scale: 1.0,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return Text(
                                                        'Error loading image: $error');
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.network(
                                            worker['Feesh Pic']!), // Show selected image
                                      )
                                    ),
                                  ),
                                // National-ID Pic

                                 DataCell(
                                    GestureDetector(
                                      onTap: () {
                                      
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: double.maxFinite,
                                                child: Image.network(
                                                  //'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
                                                  // "{data['photoUrl']}",
                                                  worker['National-ID Pic'],
                                                  scale: 1.0,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return Text(
                                                        'Error loading image: $error');
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.network(
                                            worker['National-ID Pic']!), // Show selected image
                                      )
                                    ),
                                  ),
                                
                                  // //Pic
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        //  print("data['photoUrl'] ${data['photoUrl']}",);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: double.maxFinite,
                                                child: Image.network(
                                                  //'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
                                                  // "{data['photoUrl']}",
                                                  Pic,
                                                  scale: 1.0,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return Text(
                                                        'Error loading image: $error');
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 60, // Adjust width as needed
                                        height: 60, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.network(
                                            Pic), // Show selected image
                                      )
                                    ),
                                  ),

                                  // Referene Number
                                  DataCell(Text(ref ?? 'null')),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              // Update the document to set the "isConfirmed" field to true

                                              _ApproveRequest(
                                                  worker['documentId']);
                                              print(
                                                  'print data workerId ${worker['documentId']}');

                                              print('Request approved!');
                                            } catch (error) {
                                              print(
                                                  'Error approving request: $error');
                                            }
                                          },
                                          child: Text('Approve',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .green), // Set the button's background color
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('workerRequests')
                                                .doc(worker['documentId'])
                                                .update({
                                              'isConfirmed': 'rejected'
                                            });
                                          },
                                          child: Text('Reject',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .red), // Set the button's background color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
