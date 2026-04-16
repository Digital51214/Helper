import 'package:flutter/material.dart';

class CustomWidgets extends StatelessWidget {
  final String title;

  const CustomWidgets({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ws = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          height: ws.width * 0.13, // 👈 responsive size
          width: ws.width * 0.13,
          decoration: BoxDecoration(
            color: Color(0xFFE4F9FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Padding(
                padding: EdgeInsets.only(
                  left: ws.width * 0.02,
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: ws.width * 0.055, // 👈 responsive icon
                ),
              ),
              color: Colors.black,
            ),
          ),
        ),

        SizedBox(width: ws.width * 0.03), // 👈 responsive spacing

        Text(
          title,
          style: TextStyle(
            fontFamily: 'B',
            fontWeight: FontWeight.w700,
            fontSize: ws.width * 0.045, // 👈 responsive text
          ),
        ),
      ],
    );
  }
}
