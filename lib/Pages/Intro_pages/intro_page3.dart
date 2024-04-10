import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 226, 195, 230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('What about my data?\n\nOh! Don\'t worry!\n\nMR.House uses high security functions\nto make sure your information is\nsecured and safe.',
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
              child: Lottie.asset('assets/animations/Animation - 1712497344685.json')
              ),
          ],
        ),
      ),
    );
  }
}