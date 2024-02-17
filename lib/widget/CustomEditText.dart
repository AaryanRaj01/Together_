import 'package:flutter/material.dart';

class CustomEditText extends StatelessWidget {
  final String text;

  const CustomEditText({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
      ),
    );
  }
}
