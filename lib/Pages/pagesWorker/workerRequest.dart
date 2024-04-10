

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Domain/WokerBottomNavBar.dart';

class WorkerRequest extends StatefulWidget {
  const WorkerRequest({Key? key}) : super(key: key);

  @override
  _WorkerRequestState createState() => _WorkerRequestState();
}

class _WorkerRequestState extends State<WorkerRequest> {
  bool isAvailable24H = false;
  bool _isSendingRequest = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              //purple foreground
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SvgPicture.asset(
                  "assets/images/foregroundPurpleSmall.svg",
                  fit: BoxFit.cover,
                ),
              ),

              //Mr. house word
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset("assets/images/MR. House.svg"),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              ListView(
                padding: const EdgeInsets.symmetric(vertical: 100),
                children: [
                  FriendPost(
                    proName: 'Hi MR Mohamed!',
                  ),
                ],
              ),

              // Add Post Fields and Button
              Positioned(
                top: 200,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Describe Yourself.......',
                              border: InputBorder.none,
                            ),
                            minLines: 3,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // القطعة المضافة بين الحقل النصي وعنصر "proName"
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 350,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: const Text('Carpenters'),
                                    onTap: () {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  // Add other ListTiles here
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding:


const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Select Your Job',
                              style: TextStyle(fontSize: 13),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () async {},
                            icon: const Icon(Icons.photo),
                            label: const Text('Upload Your National ID card',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: isAvailable24H
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              setState(() {
                                isAvailable24H = !isAvailable24H;
                              });
                            },
                          ),
                          const Text(
                            'Are You Available 24H',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              _sendRequest();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBBA2BF),
                            ), // Change button color
                            child: const Text(
                              'Send Request',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


// Add AlertDialog here
              _isSendingRequest
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Wait for getting the response...'),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(), // This SizedBox hides the AlertDialog when not needed
            ],
          ),
        ),
      ),
    );
  }

  //post layer
  Widget FriendPost({
    required String proName,
  }) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        proName,
                        style: const TextStyle(
                          fontSize: 30.0,
                          //  fontWeight: FontWeight.bold,
                          height: 3.0,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    const SizedBox(height: 45.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Function to simulate sending request
  void _sendRequest() {
    setState(() {
      _isSendingRequest = true;
    });
    // Simulating a response after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isSendingRequest = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBarWorker()),
      );
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}