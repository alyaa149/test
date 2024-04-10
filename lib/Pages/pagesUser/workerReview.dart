// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/favorites.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/req.dart';

class WorkerReview extends StatefulWidget {
  final String previousPage;
  Map<String, dynamic>? worker;
  final String? workerId;
  final String? serviceId;
  final String? requestId;

  WorkerReview(
      {Key? key,
      required this.previousPage,
      this.worker,
      this.workerId,
      this.serviceId,
      this.requestId})
      : super(key: key);

  static String routeName = 'workerreview';

  @override
  _WorkerReviewState createState() => _WorkerReviewState();
}

class _WorkerReviewState extends State<WorkerReview> {
  Favorites fav = Favorites();
  @override
  void initState() {
    super.initState();

    // Access worker data after the widget is created
    fname = widget.worker?['First Name'] ?? '';
    lname = widget.worker?['Last Name'] ?? '';
    Type = widget.worker?['Type'] ?? 'no';
    PhoneNumber = widget.worker?['PhoneNumber'] ?? '';
    Rating = (widget.worker?['Rating'])?.toDouble() ?? 0.0;
    Pic = widget.worker?['Pic'] ?? '' as String;
    PhotoURL = widget.worker?['PhotoURL'] ?? 'no' as String;
    if (widget.previousPage != 'WorkersList' && widget.previousPage != 'Fav') {
      date = widget.worker?['Date'] ?? 'no';
 
    }

    workerId = widget.workerId;

    //  print(
    //             'PhotoURL::::::::::::: $PhotoURL, Emergency::::::: ');
  }

  final TextEditingController _reviewController = TextEditingController();
  List<String> reviews = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fname = '';
  String lname = '';
  String Type = '';
  String Pic = '';
  String PhotoURL = '';
  double Rating = 5.0;
  String PhoneNumber = '';
  String? workerId = '';

  Timestamp date = Timestamp(0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 40,
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
                                  // Wrap the Text widget with Flexible
                                  child: Text(
                                    '$fname' ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Raleway",
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  // Wrap the Text widget with Flexible
                                  child: Text(
                                    '$lname' ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Raleway",
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '$Type',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Raleway",
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // IconButton(
                                //   onPressed: () {
                                //     fav.toggleFavoriteWorker(
                                //         workerId, currentUserId);
                                //   },
                                //   icon: Icon(
                                //     favoriteWorkerIds.contains(doc.id)
                                //         ? Icons.favorite
                                //         : Icons.favorite_border,
                                //     color: const Color(0xFFBBA2BF),
                                //     size: 20,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 5),
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
                                SizedBox(
                                  width: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                    SizedBox(width: 10),
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
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ratings:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    Colors.amber, // Set gold color for the active track
                thumbColor: Colors.amber, // Set gold color for the thumb
                overlayColor: Colors.amber
                    .withOpacity(0.3), // Set gold color for the overlay
                inactiveTrackColor:
                    Colors.grey, // Set grey color for the inactive track
              ),
              child: Slider(
                value: Rating,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) {
                  setState(() {
                    Rating = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rate the Worker:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: Rating as double? ?? 0.0,
                  minRating: 1,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  unratedColor: Colors.grey,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),

                  onRatingUpdate: (Rating) async {
                    // Update the rating in Firestore
                    try {
                      await FirebaseFirestore.instance
                          .collection('workers')
                          .doc(
                              workerId) // Replace with the actual worker's document ID
                          .update({'Rating': Rating});

                      // Provide feedback to the user (optional)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Rating updated successfully!')));
                    } catch (error) {
                      // Handle errors gracefully
                      print('Error updating rating: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update rating.')));
                    }
                  }, // Optional: Keep the update listener if needed
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Leave a Review:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Enter your review/comments here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Allow multiple lines for longer comments
            ),
            ElevatedButton(
              onPressed: () {
                if (_reviewController.text.isNotEmpty) {
                  setState(() {
                    reviews.add(_reviewController.text);
                    _reviewController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBBA2BF),
              ),
              child: Text(
                'Submit Review',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[850],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Reviews:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reviews[index]),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (widget.previousPage == 'WorkersList' ||
                        widget.previousPage == 'Fav') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Req(
                                  serviceId: widget.serviceId,
                                )),
                      );
                    } else {
                      // Insert worker data into appointments collection
                      FirebaseFirestore.instance
                          .collection('appointments')
                          .doc() // Use .doc() to automatically generate a unique document ID

                          .set(widget.worker!)
                          .then((_) {
                        // CollectionReference workerResponsesCollection =
                        //     FirebaseFirestore.instance
                        //         .collection('appointments')
                        //         .doc(widget.requestId)
                        //         .collection('workerResponses');
                        // DocumentReference docRef =
                        //     await workerResponsesCollection
                        //         .add({'gaga': 'gaga'});
                        // Navigate to Home page after inserting data
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Your appointment has been booked successfully!')));
                      }).catchError((error) {
                        print(
                            'Failed to insert worker data into appointments collection: $error');
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBA2BF),
                    padding: EdgeInsets.symmetric(
                      horizontal: 77,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: Text(
                    "Book",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[850],
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
    );
  }
}
