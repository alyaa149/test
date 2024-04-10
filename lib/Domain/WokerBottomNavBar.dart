import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../Pages/SocialMedia_pages/adminchat.dart';
import '../Pages/pagesWorker/home.dart';
import '../Pages/pagesWorker/notificationsWorker.dart';
import '../Pages/SocialMedia_pages/posts.dart';

class BottomNavBarWorker extends StatefulWidget {
  const BottomNavBarWorker({Key? key}) : super(key: key);

  @override
  State<BottomNavBarWorker> createState() => _BottomNavBarWorkerState();
}

class _BottomNavBarWorkerState extends State<BottomNavBarWorker> {
  final _controller = PageController(initialPage: 0);

  int _selectedIndex = 0;

  List<Widget> screens() {
    return [
      HomeWorker(),
      const AdminChat(),
      alartsWorker(),
      const Posts(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: screens(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 65,
        color: Color(0xFFBBA2BF),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFFBBA2BF),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.support_agent, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.handshake, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _controller.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
