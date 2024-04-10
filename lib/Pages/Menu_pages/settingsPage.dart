import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradd_proj/Pages/Menu_pages/premissionsPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Domain/customAppBar.dart';
import '../../Domain/themeNotifier.dart';
import 'menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFBBA2BF),
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showSearchBox: false,
        ),
        body: SingleChildScrollView(
          child: Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return Column(
                children: [
                  ListTile(
                    title: Text("Dark Mode"),
                    trailing: Switch(
                      value: themeNotifier.isDarkModeEnabled,
                      onChanged: (value) {
                        themeNotifier.toggleDarkMode(value);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PremissionsPage(
                            fromOnboarding: false,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text("Permissions"),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
