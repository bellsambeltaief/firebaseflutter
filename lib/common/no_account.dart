import 'package:flutter/material.dart';

class NoAccount extends StatelessWidget {
  final String text1;
  final String text2;
  final void Function() onTap;
  const NoAccount({
    super.key,
    required this.text1,
    required this.text2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: text1,
              style: const TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: text2,
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
