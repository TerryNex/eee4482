import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final String name;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;

  const InputBox({
    required this.name,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    super.key,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  String? _errorText;

  void _validateInput() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            enabled: widget.enabled,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hint,
              errorText: _errorText,
            ),
            onChanged: (_) {
              if (_errorText != null) {
                _validateInput();
              }
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

