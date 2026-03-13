import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  ContainerButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ws = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ws.height * 0.065, // 👈 responsive height
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(ws.width * 0.08), // 👈 responsive radius
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'SB',
              color: Colors.white,
              fontSize: ws.width * 0.045, // 👈 responsive font
            ),
          ),
        ),
      ),
    );
  }
}
