import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 226, 195, 230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome on Board!\n\n We would simply like to introduce you\n to our MR.House Application.\n\nA handy man in your hand.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF824E8B),
              fontFamily: 'Raleway'
            ),
            textAlign: TextAlign.center,
            ),
            Container(
              width: 300,
              height: 300,
              child: Lottie.asset('assets/animations/Animation - 1712493962435.json')),
          ],
        ),
      ),
    );
  }
}
