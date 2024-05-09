  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
  //     body: SingleChildScrollView(
      
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             margin: EdgeInsets.all(5.0),
  //             padding: EdgeInsets.all(5.0),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[200],
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 5,
  //                   blurRadius: 7,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   children: [
  //                     CircleAvatar(
  //                       backgroundColor: Colors.purple,
  //                       radius: 35,
  //                       backgroundImage: NetworkImage(Pic ?? ''),
  //                     ),
  //                     SizedBox(width: 10),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Flexible(
  //                                 // Wrap the Text widget with Flexible
  //                                 child: Text(
  //                                   '$fname' ?? 'N/A',
  //                                   style: TextStyle(
  //                                     fontSize: 19,
  //                                     fontWeight: FontWeight.w500,
  //                                     fontFamily: "Quantico",
  //                                     color: Colors.black,
  //                                   ),
  //                                   overflow: TextOverflow.ellipsis,
  //                                 ),
  //                               ),
  //                               SizedBox(width: 5),
  //                               Flexible(
  //                                 // Wrap the Text widget with Flexible
  //                                 child: Text(
  //                                   '$lname' ?? 'N/A',
  //                                   style: TextStyle(
  //                                     fontSize: 19,
  //                                     fontWeight: FontWeight.w500,
  //                                     fontFamily: "Quantico",
  //                                     color: Colors.black,
  //                                   ),
  //                                   overflow: TextOverflow.ellipsis,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 1),
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Expanded(
  //                                   child: Text(
  //                                 'Date: $date $dayOfWeek',
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontFamily: "Quantico",
  //                                   color: Colors.black87,
  //                                 ),
  //                               )),
  //                               SizedBox(width: 10),
  //                             ],
  //                           ),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 '$PhoneNumber',
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontFamily: "Quantico",
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: 40,
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   IconButton(
  //                                     icon: Icon(
  //                                       Icons.chat_bubble,
  //                                       color: Color(0xFFBBA2BF),
  //                                     ),
  //                                     onPressed: () {
  //                                       Navigator.pushReplacement(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 WorkerChat(workerId: (FirebaseAuth.instance.currentUser?.uid)!,userId: userId!,)), // Replace HomeScreen() with your home screen widget
  //                                       );
  //                                     },
  //                                   ),
  //                                   SizedBox(width: 5),
  //                                   IconButton(
  //                                     onPressed: () {
  //                                       makePhoneCall(PhoneNumber);
  //                                     },
  //                                     icon: Icon(
  //                                       Icons.phone,
  //                                       color: Color(0xFFBBA2BF),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 40),
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.calendar_today,
  //                 color: Color(0xFFBBA2BF),
  //               ),
  //               SizedBox(width: 10.0),
  //               Text(
  //                 'Date: $date',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontFamily: "Quantico",
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               SizedBox(width: 10.0),
  //               Icon(
  //                 Icons.access_time,
  //                 color: Color(0xFFBBA2BF),
  //               ),
  //               SizedBox(width: 10.0),
  //               Text(
  //                 'Time: $Time',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontFamily: "Quantico",
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           Container(
  //             margin: EdgeInsets.all(5.0),
  //             padding: EdgeInsets.all(5.0),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 5,
  //                   blurRadius: 7,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: Text(
  //               "$Type",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontFamily: "Quantico",
  //                 color: Colors.black87,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.photo,
  //                 color: Color(0xFFBBA2BF),
  //               ),
  //               SizedBox(width: 10.0),
  //               GestureDetector(
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return AlertDialog(
  //                         content: Container(
  //                           width: double.maxFinite,
  //                           child: Image(
  //                             image: NetworkImage(problemPic, scale: 1.0),
  //                             fit: BoxFit.contain,
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 },
  //                 child: Text(
  //                   'Click to see picture of the problem',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontFamily: "Raleway",
  //                     color: Colors.black87,
  //                     decoration: TextDecoration.underline,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.location_city,
  //                 color: Color(0xFFBBA2BF),
  //               ),
  //               SizedBox(width: 10.0),
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (address.startsWith('https://maps.app.goo.gl/')) {
  //                       // Open Google Maps link
  //                       launch(address);
  //                     }
  //                   },
  //                   child: RichText(
  //                     text: TextSpan(
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontFamily: "Quantico",
  //                         color: Colors.black87,
  //                         decoration: TextDecoration.underline,
  //                       ),
  //                       children: [
  //                         TextSpan(
  //                           text: 'Location : ',
  //                         ),
  //                         TextSpan(
  //                           text: address,
  //                           style: TextStyle(
  //                             color: Colors
  //                                 .blue, // Change the color to indicate it is clickable
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           TypeReq == 'general'
  //               ? Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.attach_money,
  //                           color: Color(0xFFBBA2BF),
  //                         ),
  //                         SizedBox(width: 10.0),
  //                         Text(
  //                           'The range of Commission Fee : ',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontFamily: "Raleway",
  //                             color: Colors.black87,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       width: 300,
  //                       child: TextField(
  //                         decoration: InputDecoration(
  //                           labelText: "Egyptian Pound",
  //                         ),
  //                         onChanged: (value) {
  //                           setState(() {
  //                             textFieldPriceValue = value;
  //                           });
  //                         },
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               : SizedBox(height: 30),
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   try {
  //                     CollectionReference workerResponsesCollection =
  //                         FirebaseFirestore.instance
  //                             .collection('requests')
  //                             .doc(reqId)
  //                             .collection('workerResponses');
  //                     DocumentReference docRef =
  //                         await workerResponsesCollection.add({
  //                       'CommissionFee': textFieldPriceValue,
  //                       'worker': FirebaseAuth.instance.currentUser!.uid
  //                     });
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                       content: Text('SubCollection created.'),
  //                     ));
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                       content: Text('Failed to create subcollection: $e'),
  //                     ));
  //                   }
  //                   if (TypeReq == 'specified') {
  //                     print('yessss specified');

  //                     // Insert worker data into appointments collection
  //                     FirebaseFirestore.instance
  //                         .collection('appointments')
  //                         .doc() // Use .doc() to automatically generate a unique document ID
  //                         // Merge as widget.request doesn't have CommissionFee
  //                         .set({
  //                       ...widget.request ?? {},
  //                       'CommissionFee': 'Open to update Price !',
  //                       'worker': FirebaseAuth.instance.currentUser!.uid
  //                     }).then((_) {
  //                       print(
  //                           'appointment inserted into appointments collection successfully');

  //                       DocumentReference<Map<String, dynamic>> requestDoc =
  //                           FirebaseFirestore.instance
  //                               .collection('requests')
  //                               .doc(reqId);
  //                       requestDoc.delete().then((value) {
  //                         // Document successfully deleted
  //                       }).catchError((error) {
  //                         // An error occurred while deleting the document
  //                         print("Error deleting document: $error");
  //                       });

  //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                         content: Text(
  //                             'Your appointment has been booked successfully!'),
  //                       ));
  //                     }).catchError((error) {
  //                       print(
  //                           'Failed to insert worker data into appointments collection: $error');
  //                     });
  //                   }
  //                   Navigator.pushReplacement(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => HomeWorker(),
  //                       ));
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Color(0xFFBBA2BF),
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 77,
  //                     vertical: 13,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(27),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   "Response",
  //                   style: TextStyle(
  //                     fontSize: 17,
  //                     color: Colors.grey[850],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //     drawer: Menu(
  //       scaffoldKey: _scaffoldKey,
  //     ),
  //   );
  // }
