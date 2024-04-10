import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 226, 195, 230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MR.House is a social app that works on easing the connection between\npeople and crafts men around them,\nit allows you to:\n\n1-find workers easily in the category you need\n2-chat with workers befire even arriving\n3-choose the price you want from varity\nof prices',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF824E8B),
                  fontFamily: 'Raleway'),
              textAlign: TextAlign.center,
            ),
            Container(
                width: 400,
                height: 300,
                child: Lottie.asset(
                    'assets/animations/Animation - 1712417251960.json')),
          ],
        ),
      ),
    );
  }
}
