import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gradd_proj/Pages/SignUp_pages/username_page.dart';
import 'package:gradd_proj/Pages/delievryPage.dart';
import 'package:gradd_proj/Pages/welcome.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Domain/customAppBar.dart';
import '../../Domain/themeNotifier.dart';
import 'menu.dart';

class PremissionsPage extends StatefulWidget {
  final bool
      fromOnboarding; // New parameter to indicate coming from onBoarding screen

  const PremissionsPage({Key? key, required this.fromOnboarding})
      : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<PremissionsPage> {
  String micStatus = "";
  String cameraStatus = "";
  String storageStatus = "";
  String locationStatus = "";
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only( top:10),
            child: Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.mic)),
                        title: const Text("Mic Permission"),
                        subtitle: Text("Status of Permission: $micStatus"),
                        onTap: () async {
                          PermissionStatus microphoneStatus =
                              await Permission.microphone.request();
                          if (microphoneStatus == PermissionStatus.granted) {}
                              
                          if (microphoneStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("This permission is recommended.")));
                          }
                              
                          if (microphoneStatus ==
                              PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                        },
                      ),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.camera)),
                        title: const Text("Camera Permission"),
                        subtitle: Text("Status of Permission: $cameraStatus"),
                        onTap: () async {
                          PermissionStatus cameraStatus =
                              await Permission.camera.request();
                          if (cameraStatus == PermissionStatus.granted) {}
                              
                          if (cameraStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("This permission is recommended.")));
                          }
                              
                          if (cameraStatus == PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                        },
                      ),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.storage)),
                        title: const Text("Storage Permission"),
                        subtitle: Text("Status of Permission: $storageStatus"),
                        onTap: () async {
                          PermissionStatus storageStatus =
                              await Permission.storage.request();
                              
                          if (storageStatus == PermissionStatus.granted) {
                            // Permission granted, you can proceed with your logic.
                          } else if (storageStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("This permission is recommended."),
                            ));
                          } else if (storageStatus ==
                              PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                        },
                      ),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.location_on)),
                        title: const Text("Location Permission"),
                        subtitle: Text("Status of Permission: $locationStatus"),
                        onTap: () async {
                          PermissionStatus locationStatus =
                              await Permission.location.request();
                          if (locationStatus == PermissionStatus.granted) {}
                              
                          if (locationStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("This permission is recommended.")));
                          }
                              
                          if (locationStatus ==
                              PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                        },
                      ),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.apps)),
                        title: const Text("All Permissions"),
                        subtitle: const Text("Status of All Permissions"),
                        onTap: () async {
                          Map<Permission, PermissionStatus> status = await [
                            Permission.microphone,
                            Permission.camera,
                            Permission.storage,
                            Permission.location,
                          ].request();
                              
                          debugPrint(status.toString());
                        },
                      ),
                      SizedBox(height: 260,),
                      if (widget
                          .fromOnboarding) // Conditionally show "Done!" button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize:Size(120, 50),
                            backgroundColor: Color(0xFF824E8B),
                            foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DeliveryPage()));
                          },
                          child: Text("Done!",style: 
                          TextStyle(
                            fontSize: 16,
                          ),),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        drawer: Menu(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}
