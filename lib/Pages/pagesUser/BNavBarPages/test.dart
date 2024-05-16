// // ignore_for_file: prefer_const_constructors

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class AdminUserChat extends StatefulWidget {


//   AdminUserChat({Key? key}) : super(key: key);

//   @override
//   _AdminUserChatState createState() => _AdminUserChatState();
// }

// class _AdminUserChatState extends State<AdminUserChat> {
//   List<String> usersNames = [];
//   Map<String, String> userIdMap = {}; // Map to store user IDs with names
//   String _selectedUserName = '';
//   String _selectedUserId = '';
//   String _AdminName = ''; 
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _imagePicker = ImagePicker();
//   late CollectionReference _adminMessagesCollection;
//   CollectionReference? _userMessagesCollection;
//   bool _isEmojiKeyboardVisible = false;
//   List<String> filteredUsersNames = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredUsersNames.addAll(usersNames);
//     _adminMessagesCollection = _firestore.collection('adminsMessages');
//    // _fetchAdminName();
//     _fetchUserNames();
//   }

//   Future<void> _fetchUserNames() async {
//     try {
//       QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
//       usersNames = usersSnapshot.docs.map((doc) {
//         String fullName = '${doc['First Name']} ${doc['Last Name']}';
//         userIdMap[fullName] = doc.id; // Store user ID with the name
//         return fullName;
//       }).toList();
//       setState(() {
//         filteredUsersNames = usersNames;
//       });
//     } catch (error) {
//       print('Error fetching user names: $error');
//     }
//   }

//   void filteredUsersName(String query) {
//     setState(() {
//       filteredUsersNames = usersNames
//           .where((name) => name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _toggleEmojiKeyboard() {
//     setState(() {
//       _isEmojiKeyboardVisible = !_isEmojiKeyboardVisible;
//     });
//   }

//   // Future<void> _fetchAdminName() async {
//   //   try {
//   //     DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admins').doc(widget.adminId).get();
//   //     String firstName = adminSnapshot['First Name']; 
//   //     String lastName = adminSnapshot['Last Name']; 
//   //     String fullName = '$firstName $lastName'; 
//   //     setState(() {
//   //       _AdminName = fullName; 
//   //     });
//   //   } catch (error) {
//   //     print('Error fetching admin name: $error');
//   //   }
//   // }

//   Future<void> _handleImageSelectionAndUpload() async {
//     final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       final File imageFile = File(pickedImage.path);
//       try {
//         final firebase_storage.Reference ref =
//             firebase_storage.FirebaseStorage.instance.ref().child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await ref.putFile(imageFile);
//         final imageUrl = await ref.getDownloadURL();
//         _addImageMessage(imageUrl);
//       } catch (error) {
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   void _addImageMessage(String imageUrl) {
//     if (_userMessagesCollection != null) {
//       _userMessagesCollection!.add({
//         'AUmessage': imageUrl,
//         'sender': 'Admin',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _adminMessagesCollection.add({
//         'AUmessage': imageUrl,
//         'sender': 'Admin',
//         'timestamp': FieldValue.serverTimestamp(),
//         'userId' : FirebaseAuth.instance.currentUser!.uid
//       });
//     }
//   }

//   void _selectUser(String userName) {
//     setState(() {
//       _selectedUserName = userName;
//       _selectedUserId = userIdMap[userName]!;
//       _userMessagesCollection = _firestore.collection('users').doc(_selectedUserId).collection('AUmessages');
//     });
//   }@override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           NavigationRail(
//             backgroundColor: const Color.fromARGB(251, 176, 137, 202),
//             unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
//             unselectedLabelTextStyle: TextStyle(color: Colors.white),
//             selectedIconTheme: IconThemeData(color: Colors.white),
//             // ignore: prefer_const_literals_to_create_immutables
//             destinations: [
//               NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
//               NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Chat")),
//               NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Chat 2")),
//               NavigationRailDestination(icon: Icon(Icons.request_quote), label: Text("Request")),
//               NavigationRailDestination(icon: Icon(Icons.logout), label: Text("Logout")),
//             ],
//             selectedIndex: 0,
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(60.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 200),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: 'Search',
//                                 border: OutlineInputBorder(),
//                                 contentPadding: EdgeInsets.symmetric(vertical: 10.0),
//                                 prefixIcon: Icon(Icons.search),
//                               ),
//                               onChanged: filteredUsersName,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           _AdminName.isNotEmpty ? _AdminName : 'Admin.Name',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       "User Chats:",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
//                     ),
//                     SizedBox(height: 20),
//                     SizedBox(
//                       height: 130,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: filteredUsersNames.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () => _selectUser(filteredUsersNames[index]),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                                   width: 65,
//                                   height: 65,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black12,
//                                         blurRadius: 10,
//                                         spreadRadius: 2,
//                                         offset: Offset(0, 3),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Stack(
//                                     textDirection: TextDirection.rtl,children: [
//                                       Center(
//                                         child: SizedBox(
//                                           height: 65,
//                                           width: 65,
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(30),
//                                             child: Image.asset(
//                                               "assets/doctor4.jpg",
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: const EdgeInsets.all(2),
//                                         padding: const EdgeInsets.all(3),
//                                         height: 20,
//                                         width: 20,
//                                         decoration: const BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                             color: Colors.green,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   filteredUsersNames[index],
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     AppBar(
//                       backgroundColor: const Color(0xFF7165D6),
//                       leadingWidth: 30,
//                       title: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundImage: AssetImage("assets/doctor1.jpg"),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(
//                               _selectedUserName.isNotEmpty ? _selectedUserName : 'User Name',
//                               style: TextStyle(fontSize: 18.5),
//                             ),
//                           ),
//                         ],
//                       ),
//                       actions: [
//                         Padding(
//                           padding: EdgeInsets.only(right: 10),
//                           child: Icon(Icons.more_vert, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     if (_selectedUserId.isNotEmpty && _userMessagesCollection != null)
//                       StreamBuilder<QuerySnapshot>(
//                         stream: _userMessagesCollection!.orderBy('timestamp', descending: true).snapshots(),
//                         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return CircularProgressIndicator();}
//                           if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           }
//                           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                             return Text('No messages');
//                           }
//                           return ListView(
//                             shrinkWrap: true,
//                             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                               final data = document.data() as Map<String, dynamic>;
//                               final sender = data['sender'] as String?;
//                               final message = data['AUmessage'] as String? ?? '';
//                               final isFromAdmin = sender == 'Admin';
//                               return ListTile(
//                                 title: Align(
//                                   alignment: isFromAdmin ? Alignment.topRight : Alignment.topLeft,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: isFromAdmin ? Color(0xFFBBA2BF) : Colors.grey,
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     padding: EdgeInsets.all(10.0),
//                                     child: Text(
//                                       message,
//                                       style: TextStyle(color: isFromAdmin ? Colors.white : Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomSheet: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (_isEmojiKeyboardVisible)
//             SizedBox(
//               height: 250,
//               child: EmojiPicker(
//                 onEmojiSelected: (category, emoji) {
//                   setState(() {
//                     _messageController.text += emoji.emoji;
//                   });
//                 },
//                 // config: Config(
//                 //   columns: 7,
//                 //   emojiSizeMax: 32.0,
//                 //   verticalSpacing: 0,
//                 //   horizontalSpacing: 0,
//                 //   gridPadding: EdgeInsets.zero,
//                 //   initCategory: Category.RECENT,
//                 //   bgColor: Color(0xFFF2F2F2),
//                 //   indicatorColor: Color(0xFF7165D6),
//                 //   iconColor: Colors.grey,
//                 //   iconColorSelected: Color(0xFF7165D6),
//                 //   backspaceColor: Color(0xFF7165D6),
//                 //   recentsLimit: 28,
//                 //   categoryIcons: const CategoryIcons(),
//                 //   buttonMode: ButtonMode.MATERIAL,
//                 // ),
//               ),
//             ),
//           Container(
//             height: 65,
//             decoration: BoxDecoration(color: Colors.white, boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 2,
//                 blurRadius: 10,
//                 offset: const Offset(0, 0),
//               ),
//             ]),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                   child: IconButton(
//                     icon: Icon(Icons.add),
//                     onPressed: _handleImageSelectionAndUpload,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 5),
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.emoji_emotions_outlined,
//                       size: 30,
//                       color: Colors.amber,
//                     ),
//                     onPressed: _toggleEmojiKeyboard,),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8, right: 8),
//                     child: TextFormField(
//                       controller: _messageController,
//                       decoration: const InputDecoration(
//                         hintText: "Type something",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _sendMessage,
//                   child: Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendMessage() {
//     final newMessage = _messageController.text.trim();
//     if (newMessage.isNotEmpty && _userMessagesCollection != null) {
//       _userMessagesCollection!.add({
//         'AUmessage': newMessage,
//         'sender': 'Admin',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _adminMessagesCollection.add({
//         'AUmessage': newMessage,
//         'sender': 'Admin',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _messageController.clear();
//     }
//   }}