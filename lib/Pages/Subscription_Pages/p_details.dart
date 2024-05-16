// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gradd_proj/Domain/WokerBottomNavBar.dart';
import 'package:gradd_proj/Pages/Subscription_Pages/packagesPage.dart';
import 'package:gradd_proj/Pages/pagesWorker/home.dart';
import 'package:image_picker/image_picker.dart';

class PackageDetailsPage extends StatefulWidget {
  final SubscriptionPackage? package;

  PackageDetailsPage({Key? key, this.package}) : super(key: key);

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  final String worker_id = FirebaseAuth.instance.currentUser!.uid;
  String? reference;

  void waitingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              'Wait until we confirm your payment !',
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Quantico",
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBarWorker(),
                    ),
                  );
                },
                child: Text(
                  'Ok',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addPackageRequest(
      String packageId, String workerId, String? refernce) async {
    try {
      // Get a reference to the Firestore database
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate a new document in the "adminsPackagesRequests" collection
      final DocumentReference documentReference =
          firestore.collection('adminsPackagesRequests').doc();

      // Set the fields of the new document
      await documentReference.set({
        'Package_id': packageId,
        'worker_id': workerId,
        'Reference': refernce,
        'isConfirmed': "pending",
        'isRead': false,
         'Date': FieldValue.serverTimestamp(),
        // You can add more fields here if needed
      });

      print('Admins package request added successfully');
    } catch (e) {
      print('Error adding admins package request: $e');
      // Handle any errors that occur during the process
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.package?.name ?? 'Package Details',
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Quantico",
            color: Colors.black87,
          ),
        ),
        backgroundColor: Color(0xFFBBA2BF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOU CAN SUBSCRIBE WITH 2 WAYS:',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontFamily: "Quantico",
                ),
              ),
              SizedBox(height: 25),
              Text(
                '1) Vodafone cash:',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontFamily: "Quantico",
                    decoration: TextDecoration.underline),
              ),
              Text(
                '01289453775',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black54,
                  fontFamily: "Quantico",
                ),
              ),
              SizedBox(height: 25),
              Text(
                '2) Insta bay:',
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black87,
                    fontFamily: "Quantico",
                    decoration: TextDecoration.underline),
              ),
              Text(
                '54953',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  fontFamily: "Quantico",
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Enter the Reference (رقم العملية):',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    // Update the reference variable with the value entered in the TextField
                    reference = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "reference",
                  prefixIcon: Icon(Icons.price_check),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //  addPackageIdIfNeeded(package!.documentId!);
                    waitingDialog(context);
                    addPackageRequest(
                        widget.package!.documentId!, worker_id, reference);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBarWorker()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBA2BF),
                  ),
                  child: Text(
                    'Get new package !',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[850],
                      fontFamily: "Quantico",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
