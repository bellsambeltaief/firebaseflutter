import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onTap;
  const Button({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      ),
      child: Text(label),
    );
  }
}
