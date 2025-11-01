import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final String name;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;

  InputBox({
    required this.name,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    super.key,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.hint,
            ),
          ),
        ],
      ),
    );
  }
}
