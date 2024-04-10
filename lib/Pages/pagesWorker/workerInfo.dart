// Remove the unused import statements
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Domain/customAppBar.dart';
import '../Menu_pages/menu.dart';
import 'History.dart';


class Workererinfo extends StatefulWidget {
  const Workererinfo({Key? key}) : super(key: key);

  @override
  _WorkererinfoState createState() => _WorkererinfoState();
}

class _WorkererinfoState extends State<Workererinfo> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey,showSearchBox: false,),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [

              // Profile Information Details
              Positioned(
                top: MediaQuery.of(context).size.height * 0.10,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      // Profile Image
                      const CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            AssetImage("assets/images/profile.png"),
                      ),
                      const SizedBox(height: 5),

                      // Worker Name
                      const Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // About
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16), // Increased the left margin
                            child: const ListTile(
                              leading: Icon(Icons.info),
                              title: Text(
                                "About",
                                style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Make the "About" title bold
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

// Worker About Text
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16), // Increased the left margin
                            child: const Text(
                              "Lorem ipsum dolor sit amet, sed scelerisque eros consectetur.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Worker Contact Information
                          // phoneNum
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16), // Increased the left margin
                            child: const ListTile(
                              leading: Icon(Icons.phone),
                              title: Text(
                                "Phone Number:",
                                style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Make the phone number title bold
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

// Worker num Text
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16), // Increased the left margin
                            child: const Text(
                              "01224047524",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16), // Increased the left margin
                                child: const ListTile(
                                  leading: Icon(Icons.mail),
                                  title: Text(
                                    "Email:",
                                    style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold, // Make the email title bold
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Worker email Text
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16), // Increased the left margin
                                child: const Text(
                                  "johndoe@example.com",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),

// Rating and Stars
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.star,
                                  color: Color.fromRGBO(74, 74, 74, 1),
                                  size: 25), // Filled with black
                              title: Text(
                                "Rating:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                // Add your rating logic here, e.g., display stars based on a rating value
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star_border, color: Colors.yellow),
                                Icon(Icons.star_border, color: Colors.yellow),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      const SizedBox(
                        height: 20,
                        child: Row(
                          children: [],
                        ),
                      ),

                      // Social Media Icons in Row
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Show Orders Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HistoryWorker ()));
                                // Add your logic for the "Show Orders" button here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFBBA2BF), // Light purple color
                              ),
                              child: const Text(
                                'Show Orders',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            // WhatsApp
                            IconButton(
                              onPressed: () {
                                // Add your WhatsApp logic here
                              },
                              icon: _buildSocialMediaIcon(0),
                            ),

                            // Messenger
                            IconButton(
                              onPressed: () {
                                // Add your Messenger logic here
                              },
                              icon: _buildSocialMediaIcon(1),
                            ),

                            // Telegram
                            IconButton(
                              onPressed: () {
                                // Add your Telegram logic here
                              },
                              icon: _buildSocialMediaIcon(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Menu(scaffoldKey: _scaffoldKey,),
      ),
    );
  }

  Widget _buildSocialMediaIcon(int index) {
    List<IconData> icons = [
      FontAwesomeIcons.whatsapp,
      FontAwesomeIcons.facebookMessenger,
      FontAwesomeIcons.telegram,
    ];

    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.lightBlue,
    ];

    return FaIcon(
      icons[index],
      size: 30,
      color: colors[index],
    );
    
  }
}
