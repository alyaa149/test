// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/pagesUser/userchat.dart';
import 'package:gradd_proj/Pages/pagesUser/workerReview.dart';
import 'package:gradd_proj/Pages/pagesWorker/workerChat.dart';
//import 'package:gradd_proj/Pages/pagesWorker/workerchat.dart';
import 'package:provider/provider.dart';
import '../Domain/customAppBar.dart';
import 'Menu_pages/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class HistoryPage extends StatefulWidget {
  final Map<String, dynamic>? member;

  HistoryPage({Key? key, this.member}) : super(key: key);

  @override
  State<HistoryPage> createState() => _WorkerHistoryPageState();
}

class _WorkerHistoryPageState extends State<HistoryPage> {
  bool isFavorite = false;
  List<String> favorites = [];
  String fname = '';
  String lname = '';
  String desc = '';
  String address = '';
  String type = '';
  String Pic =
      'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518';
  double Rating = 0.0;
  String PhoneNumber = '';
  String? userId = '';
  String Date = '';
  String day = '';
  String Time = '';
  String problemPic =
      'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Appointment%20problem%20pics%2Fno-image.png?alt=media&token=4dbc00cd-249e-4ed7-a055-26614247ccaa';
  String commissionFee = '';
  String workerId = '';
  String appointmentId = '';
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    if (favorites.contains(workerId)) {
      isFavorite = true;
    }
    commissionFeeController.text = commissionFee;
    // Access worker data after the widget is created
    fname = widget.member?['First Name'] ?? '';
    lname = widget.member?['Last Name'] ?? '';
    desc = widget.member?['Description'] ?? '';
    day = widget.member?['day'].toString() ?? '';
    Date = widget.member?['Date'] ?? '';
    Time = widget.member?['Time'] ?? '';
    problemPic = widget.member?['PhotoURL'].isEmpty
        ? 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
        : widget.member?['PhotoURL'];
    commissionFee = widget.member?['CommissionFee'] ?? '';
    address = widget.member?['Address'] ?? 'No address available';
    PhoneNumber = widget.member?['PhoneNumber'] ?? '';
    Rating = (widget.member?['Rating'])?.toDouble() ?? 0.0;
    Pic = widget.member?['Pic'].isEmpty
        ? 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
        : widget.member?['Pic'];
    type = widget.member?['Type'] ?? 'No type available';
    workerId = widget.member?['workerId'] ?? 'worker id not found';
    userId = widget.member?['userId'] ?? 'user id not found';
    appointmentId =
        widget.member?['appointmentId'] ?? ' appointmentId not found';

    print("userrrrrrrrrrrrrr: $userId");
    print('Pic  :   $problemPic');
  }

  void fetchFavorites() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    bool isUser = userProvider.isUser;
    if (isUser == true) {
      // Fetch favorites list from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId) // Replace with the actual user ID
          .get();

      setState(() {
        favorites = List<String>.from(snapshot['favorits'] ?? []);
        isFavorite = favorites.contains(workerId);
      });
    }
  }

  final TextEditingController commissionFeeController = TextEditingController();

  Future<double> updateRating(double RatingOfUser) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    bool isUser = userProvider.isUser;

    try {
      // Get the current rating and number of ratings from Firestore
      DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
          .collection(isUser ? "workers" : "users")
          .doc(isUser ? workerId : userId)
          .get();

      final existingData = workerSnapshot.data() as Map<String, dynamic>? ?? {};
      final currentRating = (existingData['Rating'] ?? 0).toDouble();

      final numberOfRating = (existingData['NumberOfRating'] ?? 0) as int;

      // if RatingOfUser > 2.5, increase the weight and  if RatingOfUser < 2.5, decrease the weight
      double weightFactor =
          RatingOfUser > 2.5 ? RatingOfUser / 5.0 : (5.0 - RatingOfUser) / 5.0;
      // Calculate the new average rating
      double newRating =
          (currentRating * numberOfRating + RatingOfUser * weightFactor) /
              (numberOfRating + 1);
      print(
          "currentRating = $Rating  ,RatingOfUser = $RatingOfUser   ,numberOfRating = $numberOfRating  , newRating = $newRating");

      await FirebaseFirestore.instance
          .collection(isUser ? "workers" : "users")
          .doc(isUser ? workerId : userId)
          .update({
        'Rating': newRating,
        'NumberOfRating': numberOfRating + 1,
      });

      // Provide feedback to the user (optional)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rating updated successfully!'),
      ));
      return newRating;
    } catch (error) {
      // Handle errors gracefully
      print('Error updating rating: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update rating. ')),
      );
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    double newRating = 0;
    final userProvider = Provider.of<UserProvider>(context);
    bool isUser = userProvider.isUser;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
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
              child: Row(
                children: [
                  CircleAvatar(
                    maxRadius: 30.0,
                    minRadius: 30.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(Pic),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: 
                              
                              GestureDetector(
                                onTap: () {
                                  isUser == true ?
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkerReview(
                                              worker: widget.member,
                                              workerId: workerId,
                                              previousPage: 'Fav',
                                            )) // Replace HomeScreen() with your home screen widget
                                  )
                               : null ;
                                },
                                child: Text(
                                  '$fname $lname' ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Quantico",
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Date: $Date $day',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Quantico",
                                color: Colors.black87,
                              ),
                            )),
                            // Conditionally show the favorite icon based on the value of isUser
                            isUser == true
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (favorites.contains(workerId)) {
                                          // Remove worker ID from favorites list
                                          favorites.remove(workerId);
                                        } else {
                                          // Add worker ID to favorites list
                                          favorites.add(workerId);
                                        }
                                        isFavorite =
                                            !isFavorite; // Toggle favorite state
                                      });
                                      updateFavoritesInFirestore();
                                    },
                                    child: Icon(
                                      favorites.contains(workerId)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                  )
                                : SizedBox(), // Use SizedBox to hide the icon if isUser is false
                          ],
                        ),
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
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.chat_bubble,
                                    color: Color(0xFFBBA2BF),
                                  ),
                                  onPressed: () {
                                    isUser == true
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserChat(
                                                      workerId: workerId,
                                                      userId: currentUserId,
                                                    )), // Replace HomeScreen() with your home screen widget
                                          )
                                        : Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkerChat(
                                                      workerId: currentUserId,
                                                      userId: userId!,
                                                    )), // Replace HomeScreen() with your home screen widget
                                          );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall(PhoneNumber);
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFFBBA2BF),
                                  ),
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
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Date: $Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Raleway",
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 10.0),
                Icon(
                  Icons.access_time,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Time: $Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Raleway",
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "$desc",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Raleway",
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.photo,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            width: double.maxFinite,
                            child: Image(
                              image: NetworkImage(problemPic, scale: 1.0),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Click to see picture of the problem',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Raleway",
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: Color(0xFFBBA2BF),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (address.startsWith('https://maps.app.goo.gl/')) {
                        // Open Google Maps link
                        launch(address);
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Quantico",
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                        children: [
                          TextSpan(
                            text: 'Location : ',
                          ),
                          TextSpan(
                            text: address,
                            style: TextStyle(
                              color: Colors
                                  .blue, // Change the color to indicate it is clickable
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Color(0xFFBBA2BF),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'The range of Commission Fee : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Raleway",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        commissionFee = value;
                      });
                    },
                    controller: commissionFeeController,
                    decoration: InputDecoration(
                      labelText: "Egyptian Pound",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('appointments')
                        .doc(appointmentId)
                        .update({
                      'CommissionFee':
                          commissionFee, // Update Firestore document with the new commission fee
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Commission fee updated successfully!')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Failed to update commission fee: $error')),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBA2BF),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            Text(
              'Rate Now !',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Raleway",
                  color: Colors.black87,
                  decoration: TextDecoration.underline),
            ),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: 0.0,
                  minRating: 0,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  unratedColor: Colors.grey.shade300,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xFFBBA2BF),
                  ),
                  onRatingUpdate: (double Rating) async {
                    setState(() {
                      newRating = Rating;
                    });

                    await updateRating(Rating);
                  }, // Optional: Keep the update listener if needed
                ),
                SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      drawer: Menu(
        scaffoldKey: _scaffoldKey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFFBBA2BF),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  void updateFavoritesInFirestore() {
    // Update favorites list in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId) // Replace with the actual user ID
        .update({'favorits': favorites});
  }
}

void makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
