import 'dart:async';
import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final String title;
  final FutureOr<void> Function()? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const ContainerButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final ws = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (onPressed == null || isLoading)
          ? null
          : () async {
        await onPressed!();
      },
      child: Container(
        height: ws.height * 0.058,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (onPressed == null || isLoading)
              ? Colors.grey
              : backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(ws.width * 0.08),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            height: ws.width * 0.05,
            width: ws.width * 0.05,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
              : Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'B',
              color: textColor,
              fontSize: ws.width * 0.032,
            ),
          ),
        ),
      ),
    );
  }
}