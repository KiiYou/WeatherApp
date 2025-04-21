
import 'package:flutter/material.dart';

class AppBar_Text extends StatelessWidget {
  final String text;
  const AppBar_Text({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}