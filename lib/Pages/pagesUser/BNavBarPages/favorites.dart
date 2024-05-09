import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/workerslist.dart';

import '../../../Domain/customAppBar.dart';
import '../../../Domain/listItem.dart';
import '../../Menu_pages/menu.dart';
import '../workerReview.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> favoriteWorkerIds = [];
  Stream<QuerySnapshot>?
      _workerStream; // nullable to avoid early initialization

  @override
  void initState() {
    super.initState();
    fetchFavoriteWorkerIds();
  }

  String? currentUserId;
  void fetchFavoriteWorkerIds() async {
    currentUserId = await FirebaseAuth.instance.currentUser?.uid ?? "";

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get(); // get the specific document from users collection

    if (docSnapshot.exists) {
      final favoriteWorkers =
          docSnapshot.data()!['favorits']; //get the  Favorites list
      if (favoriteWorkers is List) {
        setState(() {
          favoriteWorkerIds = favoriteWorkers
              .map((workerId) => workerId.toString())
              .toList(); //hatly el worker elly el workreFavId=workerId
          if (favoriteWorkerIds.isNotEmpty) {
            // Initialize stream only if non-empty
            _workerStream = FirebaseFirestore.instance
                .collection('workers')
                .where(FieldPath.documentId, whereIn: favoriteWorkerIds)
                .snapshots(includeMetadataChanges: true);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: true,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Workers List
              Positioned(
                top: 10,
                right: 5,
                left: 5,
                bottom: 0,
                child: _workerStream != null // Check for stream existence
                    ? StreamBuilder<QuerySnapshot>(
                        stream: _workerStream!,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final workers = snapshot.data!.docs.toList();

                            // Filter out workers whose IDs are not in favoriteWorkerIds
                            final filteredWorkers = workers.where((doc) {
                              final workerId = doc.id;
                              return favoriteWorkerIds.contains(workerId);
                            }).toList();

                            if (filteredWorkers.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: filteredWorkers.length,
                                itemBuilder: (context, itemCount) {
                                  final doc = filteredWorkers[itemCount];
                                  final dynamic workerData = doc.data();
                                  final firstName =
                                      workerData['First Name'] as String?;
                                  final lastName =
                                      workerData['Last Name'] as String?;
                                  final desc = workerData['Type'] as String?;
                                  final pic = workerData['Pic'] as String?;
                                  final Service =
                                      workerData['Service'] as String?;
                                  final number =
                                      workerData['PhoneNumber'] as String?;
                                  final ratingInt = workerData['Rating'] is int
                                      ? workerData['Rating'] as int
                                      : 0;
                                  final rating = (ratingInt).toDouble();
                                  final workerId = doc.id;
                                  if (workerData != null &&
                                      workerData is Map<String, dynamic>) {
                                    return ListItem(
                                      Member: {
                                        'First Name': firstName ?? 'N/A',
                                        'Last Name': lastName ?? 'N/A',
                                        'Type': desc ?? 'N/A',
                                        'Pic': pic ?? 'N/A',
                                        'PhoneNumber': number ?? 'N/A',
                                        'Rating': rating,
                                      },
                                      trailingWidget: IconButton(
                                        onPressed: () => toggleFavoriteWorker(
                                            doc.id, currentUserId!),
                                        icon: Icon(
                                          favoriteWorkerIds.contains(doc.id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: const Color(0xFFBBA2BF),
                                          size: 20,
                                        ),
                                      ),
                                      pageIndex: 1,
                                      onPressed: () => navigateToPage1(
                                        context,
                                        WorkerReview(
                                          previousPage: 'Fav',
                                          worker: workerData,
                                          workerId: workerId,
                                          serviceId: Service,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(); // Return an empty container
                                  }
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No Favorite Workers Found",
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: "Raleway"),
                                ),
                              );
                            }
                          } else {
                            return const CircularProgressIndicator(); // Show loading indicator
                          }
                        },
                      )
                    : Container(
                        child: const Center(
                          child: Text(
                            "No Favorite Workers Found",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "Raleway"),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }

  void toggleFavoriteWorker(String workerId, String currentUserId) async {
    setState(() {
      if (favoriteWorkerIds.contains(workerId)) {
        favoriteWorkerIds.remove(workerId);
      } else {
        favoriteWorkerIds.add(workerId);
      }
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'favorits': favoriteWorkerIds});

      if (!favoriteWorkerIds.contains(workerId)) {
        setState(() {
          _workerStream = _workerStream?.where((snapshot) {
            // Iterate through documents in the QuerySnapshot
            for (var doc in snapshot.docs) {
              if (doc.id != workerId) {
                // Keep the document if it's not the one to be removed
                return true;
              }
            }
            return false; // If not found, remove from the stream
          });
        });
      }
    } catch (e) {
      // Handle any errors that occur during the update
      print('Failed to update favorites: $e');
      setState(() {
        // Revert the changes to the favoriteWorkerIds list
        if (favoriteWorkerIds.contains(workerId)) {
          favoriteWorkerIds.remove(workerId);
        } else {
          favoriteWorkerIds.add(workerId);
        }
      });
    }
  }
}
