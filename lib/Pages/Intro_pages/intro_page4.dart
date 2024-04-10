import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 226, 195, 230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('We\'re almost there!\n\nMR.House needs some premissions\nto work effecintly',
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
              child: Lottie.asset('assets/animations/Animation - 1712500881068 (1).json')
              ),
          ],
        ),
      ),
    );
  }
}