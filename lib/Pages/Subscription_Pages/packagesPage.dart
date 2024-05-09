// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradd_proj/Pages/Subscription_Pages/p_details.dart';

class SubscriptionPackage {
  final String? name;
  final String? description;
  final int? appointments;
  final double? price;
  final String? documentId; // Document ID of the package
  final double? revenue;
  SubscriptionPackage({
    required this.name,
    required this.description,
    required this.appointments,
    required this.price,
    required this.documentId,
    required this.revenue // Optional parameter for document ID
  });
}

class PackagesPage extends StatelessWidget {
  final Color backgroundColor = Color(0xFFBBA2BF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Subscription Packages',
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Raleway",
              color: Colors.black87,
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("packages").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<SubscriptionPackage> packages = [];
            snapshot.data!.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              packages.add(SubscriptionPackage(
                name: data['Name'] ?? '',
                description: data['Desc'] ?? '',
                appointments: data['P_number'] ?? 0,
                price: (data['Price'] ?? 0.0).toDouble(),
                documentId: doc.id, // Assign the document ID to the package
                revenue: data['Revenue'].toDouble(),
              ));
            });
            return ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PackageDetailsPage(package: packages[index]),
                      ),
                    );
                  },
                  child: _buildPackageCard(context, packages[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, SubscriptionPackage package) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.name!,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: "Quantico",
                  decoration: TextDecoration.underline),
            ),
            SizedBox(height: 8.0),
            Text(
              package.description!,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
                fontFamily: "Quantico",
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: ${package.price}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
                fontFamily: "Quantico",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
