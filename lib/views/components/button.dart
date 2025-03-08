import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final double height;
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 50,
    this.backgroundColor = Colors.black,
    this.borderColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 500, minHeight: height),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor), // Warna border
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
