import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradd_proj/Pages/Intro_pages/intro_page1.dart';
import 'package:gradd_proj/Pages/Intro_pages/intro_page2.dart';
import 'package:gradd_proj/Pages/Intro_pages/intro_page3.dart';
import 'package:gradd_proj/Pages/Intro_pages/intro_page4.dart';
import 'package:gradd_proj/Pages/Menu_pages/premissionsPage.dart';
import 'package:gradd_proj/Pages/Menu_pages/settingsPage.dart';
import 'package:gradd_proj/Pages/welcome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //controller to keep track which page we're on
  PageController _controller = PageController();

  //keep track if we're on the last page
  bool onLastPage = false;

  // Flag to track whether to show back arrow
  bool _showBackArrow = false; 

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        // Set _showBackArrow to true if not on the first page
        _showBackArrow = _controller.page != 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        //pages
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 3);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
            IntroPage4(),
            ],
        ),
        // Back arrow
          if (_showBackArrow)
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  // Navigate back to the previous page
                  if (_controller.page != null && _controller.page! > 0) {
                    _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF824E8B),
                ),
              ),
            ),
        //dot containers
        Container(
          alignment: Alignment(0, 0.75),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //skip
            if(onLastPage != true)
            GestureDetector(
                onTap: () {
                  _controller.jumpToPage(3);
                },
                child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF824E8B),                        
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Skip',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      ),
                      ),
                 ),

            //indicators
            SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: WormEffect(
                dotColor: Colors.white,
                activeDotColor: Color(0xFF824E8B),),
                ),

            //next or done
            onLastPage
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PremissionsPage(fromOnboarding: true,);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF824E8B),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Go to Premissions',
                       style: TextStyle(
                        color: Colors.white,
                        ),
                        )
                      ),
                  )
                : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF824E8B),                        
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      )
                      ),
                  )
          ]),
        )
      ],
    ));
  }
}
