// import 'package:flutter/material.dart';

// import 'package:grad_proj/Pages/pagesWorker/History.dart';
// import 'package:grad_proj/Pages/pagesWorker/home.dart';


// class Menuw extends StatelessWidget {
//   const Menuw({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // title: const Text('Flutter Drawer Example'),
//           ),
//       drawer: Drawer(
//         child: FractionallySizedBox(
//           alignment: Alignment.topCenter,
//           child: Container(
//             color:
//                 const Color(0xFFBBA2BF), // Set the background color to purple
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
//                   alignment: Alignment.topRight,
//                   child: IconButton(
//                     icon: const Icon(Icons.close_rounded),
//                     onPressed: () {
//                       Navigator.pop(context); // Close the drawer
//                     },
//                   ),
//                 ),
//                 DrawerHeader(
//                   decoration: const BoxDecoration(
//                     color:
//                         Color(0xFFBBA2BF), // Set the desired background color
//                   ),
//                   child: Container(
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundImage: AssetImage('assets/images/profile.png'),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Mohamed Ahmed',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.home),
//                   title: const Text(
//                     'Home',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) =>  HomeWorker()));
//                     // Handle profile tap
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.person_outlined),
//                   title: const Text(
//                     'Profile',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   onTap: () {
//                     // Handle profile tap
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.table_view_outlined),
//                   title: const Text(
//                     'Appointements',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => HistoryWorker()));
//                     // Handle reservations tap
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.info_outline),
//                   title: const Text(
//                     'AboutApp',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   onTap: () {
//                     // Handle information tap
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.settings_outlined),
//                   title: const Text(
//                     'Settings',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   onTap: () {
//                     // Handle settings tap
//                   },
//                 ),
//                 const Divider(),
//                 Padding(
//                   padding: const EdgeInsets.only(right:70,left: 70),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: const Color.fromARGB(234, 0, 0, 0),
//                         backgroundColor: Colors.white,
//                       ),
//                       child: const Text('Log Out'),
//                       onPressed: () {
//                         // Handle log out button tap
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
