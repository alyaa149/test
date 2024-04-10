import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradd_proj/Pages/Intro_pages/onboarding_screen.dart';
import 'package:gradd_proj/Pages/welcome.dart';
import 'package:lottie/lottie.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Delay navigation to Welcome page after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => Welcome(),
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBBA2BF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/Animation - 1712668960522.json',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}