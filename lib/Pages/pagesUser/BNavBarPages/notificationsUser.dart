import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Domain/customAppBar.dart';
import '../../Menu_pages/menu.dart';


class Notifiction extends StatelessWidget {
  final VoidCallback? onNotificationPageOpen;
  Notifiction({Key? key,this.onNotificationPageOpen}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Inside your Notifiction class

// Function to mark a notification as read
void markNotificationAsRead(String notificationId) {
  FirebaseFirestore.instance
      .collection('Notifications')
      .doc(notificationId)
      .update({'isRead': true})
      .then((_) {
    // Notification marked as read successfully
    // Update UI or perform other actions as needed
  }).catchError((error) {
    // Handle error
    print('Failed to mark notification as read: $error');
  });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 20,
              left: 6,
              child: Text(
                "Today : ",
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
              top: 60,
              right: 5,
              left: 5,
              bottom: 0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Notifications')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final notificationDocs = snapshot.data!.docs;
                  final todayNotifications = notificationDocs.where((doc) =>
                      isToday((doc.data() as dynamic)['timestamp'].toDate()));

                  return ListView.builder(
                    itemCount: todayNotifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          todayNotifications.elementAt(index).data() as dynamic;
                          final userName = notification['commenterName'];
                          final commentText = notification['commentText'];
                          if(userName == null || commentText == null) {
                        // Handle null values gracefully, such as skipping this notification
                        return SizedBox.shrink();
                      }
                      final message = '$userName commented $commentText';
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(31, 125, 124, 124),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.black26,
                              width: 2.0,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(2),
                            leading: const Column(),
                            title: RichText(
                              text: TextSpan(
                                text: message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Raleway",
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
