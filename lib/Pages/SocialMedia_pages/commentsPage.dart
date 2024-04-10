import 'package:flutter/material.dart';



import '../../Domain/customAppBar.dart';
import 'editPost.dart';
import '../Menu_pages/menu.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  // comments list
  List<Map<String, String>> comments = [
    {"name": "Mohamed Ahmed", "comment": "معاك الاسطي محمد"},
    {"name": "Ahmed Ramadan", "comment": "كلمني تحت امرك"},
    {"name": "Nawal Zakaria", "comment": "شكرا لحضرتك"},
    {"name": "Amira ElMohamedy", "comment": "تواصل معايا لو سمحت"},
    {"name": "Karim AbdelAziz", "comment": "تواصل على الخاص"},
    {"name": "Nagy Mohamed", "comment": "Done"},
  ];

  //list for the profile pics of the users
  List<String> profilePic = [
    'assets/images/profile.png',
    'assets/images/profile.png',
    'assets/images/profile.png',
    'assets/images/profile.png',
    'assets/images/profile.png',
    'assets/images/profile.png',
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showSearchBox: false),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditPost()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFBBA2BF), // Change button color
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
// Handle delete button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFBBA2BF), // Change button color
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Comments
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final comment = comments[index];
              final profileIndex = index %
                  profilePic
                      .length; // Handle if profilePic list is shorter than comments list
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ]),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFFBBA2BF),
                            radius: 30,
                            backgroundImage:
                                AssetImage(profilePic[profileIndex]),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(31, 125, 124, 124),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment["name"] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  comment["comment"] ?? "",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Handle like button press
                          },
                          child: const Text(
                            "Like",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle reply button press
                          },
                          child: const Text(
                            "Reply",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: Menu(
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}