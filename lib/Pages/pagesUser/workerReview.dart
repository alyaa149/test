// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gradd_proj/Domain/customAppBar.dart';
import 'package:gradd_proj/Domain/user_provider.dart';
import 'package:gradd_proj/Pages/Menu_pages/menu.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/favorites.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/req.dart';
import 'package:gradd_proj/Pages/toqaHistoryUser.dart';
import 'package:gradd_proj/Pages/pagesUser/userchat.dart';

import 'package:provider/provider.dart';

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
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final TextEditingController _reviewController = TextEditingController();
  bool isFavorite = false;
  List<String> favorites = [];
  List<String> reviews = [];
  List<String> reviewsUsers = [];
  Favorites fav = Favorites();
  List<String> firstNames = [];
  List<String> lastNames = [];
  List<String> PicOfUserReview = [];
  bool userIsExist = false;

  @override
  void initState() {
    super.initState();
    fetchReviews();
    fetchFavorites();
    if (favorites.contains(workerId)) {
      isFavorite = true;
    }
    // Access worker data after the widget is created
    fname = widget.worker?['First Name'] ?? '';
    lname = widget.worker?['Last Name'] ?? '';
    Type = widget.worker?['Type'] ?? 'no';
    PhoneNumber = widget.worker?['PhoneNumber'] ?? '';
    Rating = (widget.worker?['Rating'])?.toDouble() ?? 0.0;
    Pic = widget.worker?['Pic'].isEmpty
        ? 'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'
        : widget.worker?['Pic'];
    PhotoURL = widget.worker?['PhotoURL'] ?? 'no' as String;
    if (widget.previousPage != 'WorkersList' && widget.previousPage != 'Fav') {
      date = widget.worker?['Date'] ?? 'no';
    }
    print('$currentUserId  currentUserId');
  }

  Future<void> fetchReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? userReviews = snapshot.data()?['reviews'];
        if (userReviews != null) {
          List<String> reviews =
              userReviews.values.map((value) => value.toString()).toList();
          reviewsUsers = userReviews.keys.toList(); // This line is changed
          await getInfoOfUserReview(reviewsUsers.cast<String>());
          print("print reviewsUsers $reviewsUsers");
          print("print reviews $reviews");
          setState(() {
            this.reviews = reviews;
          });
        }
      }
    } catch (error) {
      print("Error fetching reviews: $error");
    }
  }

  Future<void> getInfoOfUserReview(List<String> reviewsUsers) async {
    try {
      List<String> newFirstNames = [];
      List<String> newLastNames = [];
      List<String> newPicOfUserReview = [];

      for (String userId in reviewsUsers) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists && userIsExist == false) {
          // Store the retrieved data in separate lists
          newFirstNames.add(userDoc.data()?['First Name'] ?? '');
          newLastNames.add(userDoc.data()?['Last Name'] ?? '');
          newPicOfUserReview.add(userDoc.data()?['Pic'] ?? '');
        } else {
          print('User document for $userId does not exist');
        }
      }

      setState(() {
        firstNames = newFirstNames;
        lastNames = newLastNames;
        PicOfUserReview = newPicOfUserReview;
      });

      // Printing firstNames
      print('print First Names: $firstNames');

      // Printing lastNames
      print('print Last Names: $lastNames');

      // Printing picUrls
      print('print Pic URLs: $PicOfUserReview');
    } catch (error) {
      print("Error fetching user information: $error");
    }
  }

  void submitReview() async {
    String newReview = _reviewController.text;
    if (newReview.isNotEmpty) {
      try {
        // Replace 'workerId' with the actual worker ID
        DocumentReference<Map<String, dynamic>> workerDoc = FirebaseFirestore
            .instance
            .collection('workers')
            .doc(widget.workerId);

        // Get the current reviews map
        Map<String, dynamic>? currentReviews =
            (await workerDoc.get()).data()?['reviews'];

        // Check if the current user has already submitted a review
        bool hasReviewed = currentReviews?.containsKey(currentUserId) ?? false;

        // If the user has already reviewed, update the review; otherwise, create a new one
        if (hasReviewed) {
          // Update the existing review
          userIsExist == true;
        } else {
          userIsExist == false;
        }
        currentReviews?[currentUserId] = newReview;

        await workerDoc.update({'reviews': currentReviews});

        // Clear the text field and fetch the updated reviews
        _reviewController.clear();
        // fetchReviews();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('submit is done successfully!')));
      } catch (error) {
        print("Error submitting review: $error");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('review not be sent')));
      }
    }
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

  void updateFavoritesInFirestore() {
    // Update favorites list in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId) // Replace with the actual user ID
        .update({'favorits': favorites});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fname = '';
  String lname = '';
  String Type = '';
  String Pic = '';
  String PhotoURL = '';
  double Rating = 0.0;
  String PhoneNumber = '';
  String? workerId = '';

  Timestamp date = Timestamp(0, 0);
  @override
  Widget build(BuildContext context) {
    double newRating = 0;
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
                        radius: 30,
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
                                SizedBox(width: 100),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (favorites.contains(widget.workerId)) {
                                        // Remove worker ID from favorites list
                                        favorites.remove(widget.workerId);
                                      } else {
                                        // Add worker ID to favorites list
                                        favorites.add(widget.workerId!);
                                      }
                                      isFavorite =
                                          !isFavorite; // Toggle favorite state
                                    });
                                    updateFavoritesInFirestore();
                                  },
                                  child: Container(
                                    child: Icon(
                                      favorites.contains(widget.workerId)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Color(0xFFBBA2BF),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '$PhoneNumber',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Quantico",
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                // Add Spacer to push the IconButton to the end

                                IconButton(
                                  icon: Icon(
                                    Icons.chat_bubble,
                                    color: Color(0xFFBBA2BF),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserChat(workerId:widget.workerId!,userId:currentUserId)), // Replace HomeScreen() with your home screen widget
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    makePhoneCall(PhoneNumber);
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    color: Color(0xFFBBA2BF),
                                  ),
                                )
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
              'Rating:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RatingBarIndicator(
                    rating: Rating as double? ?? 0.0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Color(0xFFBBA2BF),
                    ),
                    itemCount: 5,
                    itemSize: 40.0,
                    direction: Axis.horizontal,
                    unratedColor: Colors.grey.shade300,
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Rate the worker Now !',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Raleway",
                  color: Colors.black87,
                  decoration: TextDecoration.underline),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            Text(
              'Leave one review for the worker:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                  decoration: TextDecoration.underline),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Enter your review/comments here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null, // Allow multiple lines for longer comments
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFFBBA2BF), // Change the background color here
                    ),
                    child: Text(
                      'Submit Review',
                      style: TextStyle(
                        color: Colors
                            .grey[850], // Optionally change the text color
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Text(
              'Reviews:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 220, // Adjust the height according to your layout
              child: reviews.isEmpty
                  ? Center(
                      child: Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Raleway",
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: reviews.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        dynamic review = reviews[index];
                        print('print 2222 firstNames $firstNames');
                        return Container(
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
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: index < PicOfUserReview.length
                                  ? NetworkImage(PicOfUserReview[index])
                                      as ImageProvider<Object>?
                                  : AssetImage(
                                      'https://firebasestorage.googleapis.com/v0/b/mrhouse-daf9c.appspot.com/o/Profile%20Pictures%2Fprofile.png?alt=media&token=db788fd3-0ec9-4e9a-9ddb-f22e2d5b5518'),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${firstNames[index]} ${lastNames[index]}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Raleway",
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(review),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
                                  serviceId: widget.serviceId!,
                                  workerId:widget.workerId!
                                )),
                      );
                    } else {
                      // Insert worker data into appointments collection
                      FirebaseFirestore.instance
                          .collection('appointments')
                          .doc() // Use .doc() to automatically generate a unique document ID
                          .set(widget.worker!)
                          .then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                         DocumentReference<Map<String, dynamic>>
                            requestDoc = FirebaseFirestore
                                .instance
                                .collection('requests')
                                .doc(widget.requestId);
                                requestDoc.delete().then((value) {
  // Document successfully deleted
}).catchError((error) {
  // An error occurred while deleting the document
  print("Error deleting document: $error");
});

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
                SizedBox(
                  height: 250,
                )
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

  Future<double> updateRating(double RatingOfUser) async {
    try {
      // Get the current rating and number of ratings from Firestore
      DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
          .collection("workers")
          .doc(widget.workerId)
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
          .collection("workers")
          .doc(widget.workerId)
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
}
