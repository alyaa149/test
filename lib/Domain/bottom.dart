


import 'package:flutter/material.dart';




import 'package:gradd_proj/Pages/SocialMedia_pages/adminchat.dart';
import 'package:gradd_proj/Pages/SocialMedia_pages/posts.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/favorites.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/home.dart';
import 'package:gradd_proj/Pages/pagesUser/BNavBarPages/notificationsUser.dart';



import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../Pages/pagesUser/BNavBarPages/adminUserChar.dart';
// Main Navigation Screen
class BottomNavBarUser extends StatefulWidget {
  const BottomNavBarUser({Key? key}) : super(key: key);

  @override
  State<BottomNavBarUser> createState() => _BottomNavBarUserState();
}

class _BottomNavBarUserState extends State<BottomNavBarUser> {
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> screens() {
    return  [
       const Home(),
       Favorites(),
        UserAdminChat(),
       Notifiction(),
       const Posts(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.black87,
        
        inactiveColorPrimary: Colors.white,
        iconSize: 28,
        textStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: "Favorites",
        activeColorPrimary: Colors.black87,
        inactiveColorPrimary: Colors.white,
        iconSize: 28,
        textStyle:  const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),

      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.support_agent),
        title: "Admin Chat",
        activeColorPrimary: Colors.black87,
        inactiveColorPrimary: Colors.white,
        iconSize: 28,
        textStyle:  const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications),
        title: "Notifications",
        activeColorPrimary: Colors.black87,
        inactiveColorPrimary: Colors.white,
        iconSize: 28,
        textStyle:  const TextStyle(fontSize: 23,fontWeight: FontWeight.w900),
      ),
       PersistentBottomNavBarItem(
          icon: const Icon(Icons.handshake),
          title: "Ask",
          iconSize: 28,
        textStyle:  const TextStyle(fontSize: 15,fontWeight: FontWeight.w900),
          activeColorPrimary: Colors.black87,
          inactiveColorPrimary: Colors.white),       
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: screens(),
      items: navBarItems(),
    //  popAllScreensOnTapAnyTabs: true,
     
      popAllScreensOnTapOfSelectedTab: false,
      controller: _controller,
      navBarStyle: NavBarStyle.style1,
      
      backgroundColor:const Color.fromARGB(255, 173, 148, 177),   
      hideNavigationBarWhenKeyboardShows: true,
      resizeToAvoidBottomInset: false,   
      
    );
  }
}