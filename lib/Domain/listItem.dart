// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListItem extends StatelessWidget {
  final Map<String, dynamic> Member;
  final int pageIndex;
  final Widget? trailingWidget;
  final Function() onPressed;

  const ListItem({
    Key? key,
    required this.Member,
    required this.pageIndex,
    this.trailingWidget,
    required this.onPressed,
  }) : super(key: key);

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
          title:Row(
  children: [
    Expanded(
      child: Text(
        '${Member['First Name']} ${Member['Last Name']}' ?? 'N/A',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          fontFamily: "Quantico",
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis, // Handle overflow if necessary
      ),
    ),
  ],
),
 subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shouldDisplayWorkerType)
                Text(
                  Member['Type'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Quantico",
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Member['PhoneNumber'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Quantico",
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    width: 15,
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
                    ignoreGestures: true,
                    onRatingUpdate: (rating) => print(rating),
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
                    borderRadius: BorderRadius.circular(27),
                  ),
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
            child: trailingWidget,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
