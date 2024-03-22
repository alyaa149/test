// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListItem extends StatelessWidget {
  final Map<String, dynamic> Member;

  final int pageIndex;
  final Widget? trailingWidget;
  final Function() onPressed;

  const ListItem({
    super.key,
    required this.Member,
    required this.pageIndex,
    this.trailingWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool shouldDisplayWorkerType = pageIndex == 0 || pageIndex == 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Container(
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(2),
          leading: SizedBox(
            width: 60,
            height: 100,
            child: CircleAvatar(
              backgroundColor: Colors.purple,
              radius: 50,
              backgroundImage: NetworkImage(Member['Pic'] ?? ''),
            ),
          ),
          title: Row(
            children: [
              Text(
                Member['First Name'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Raleway",
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Member['Last Name'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Raleway",
                  color: Colors.black,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shouldDisplayWorkerType)
                Text(
                  Member['Description'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Raleway",
                    color: Colors.black87,
                  ),
                ),
              if (!shouldDisplayWorkerType)
                RichText(
                  text: TextSpan(
                    text: 'Price : ',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Quantico",
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: '${Member['CommissionFee']}',
                        style: TextStyle(
                          // Apply your desired text style for the commission fee value
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Member['PhoneNumber'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quantico",
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RatingBar.builder(
                    initialRating: Member['Rating'] as double? ?? 0.0,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    unratedColor: Colors.grey,
                    itemCount: 5,
                    itemSize: 15.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    // Add the ignoreGestures property set to true to disable interactivity
                    ignoreGestures: true,
                    onRatingUpdate: (rating) => print(
                        rating), // Optional: Keep the update listener if needed
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 160,
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 2),
                  decoration: BoxDecoration(
                      color: Color(0xFFBBA2BF),
                      border: Border.all(
                        color: Color.fromARGB(255, 171, 155, 172),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(27)),
                  child: Text(
                    "Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Container(
              padding: EdgeInsets.only(right: 3),
              width: 33,
              child: trailingWidget),
          onTap: onPressed,
        ),
      ),
    );
  }
}
