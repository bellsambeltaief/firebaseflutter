import 'package:flutter/material.dart';

class TextFileds extends StatefulWidget {
  const TextFileds({
    super.key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.input,
    required this.validate,
  });

  final TextEditingController controller;
  final TextInputType input;
  final String label;
  final String? Function(String?)? validate;

  final bool obscure;

  @override
  State<TextFileds> createState() => _TextFiledsState();
}

class _TextFiledsState extends State<TextFileds> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 10, 73, 167),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: widget.input,
      validator: widget.validate,
    );
  }
}
