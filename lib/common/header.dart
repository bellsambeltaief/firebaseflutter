import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  const Header({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/a.png', // Replace with the path to your logo file
          width: 300, // Set this to the appropriate width for your logo
          height: 120,
          color: Colors.blue, // Set this to the appropriate height for your logo
        ),
        const SizedBox(height: 30),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.blue[900],
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
