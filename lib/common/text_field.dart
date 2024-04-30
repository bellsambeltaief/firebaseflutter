import 'package:flutter/material.dart';

class TextFileds extends StatefulWidget {
  const TextFileds({
    super.key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.input,
    required this.validate,
    this.maxLength,
    this.minlength,
    this.error,
  });

  final TextEditingController controller;
  final TextInputType input;
  final String label;
  final String? Function(String?)? validate;
  final String? error;
  final bool obscure;
  final int? maxLength;
  final int? minlength;

  @override
  State<TextFileds> createState() => _TextFiledsState();
}

class _TextFiledsState extends State<TextFileds> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
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
          minLines: widget.minlength,
          maxLength: widget.maxLength,
          keyboardType: widget.input,
          validator: widget.validate,
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
              ),
            ),
          ),
      ],
    );
  }
}
