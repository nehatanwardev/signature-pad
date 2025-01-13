import 'package:flutter/material.dart';

// Custom button widget
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final Color textColor;

  CustomButton({
    required this.onPressed,
    required this.label,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.17,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
