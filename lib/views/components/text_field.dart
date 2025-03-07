import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool isEmail;
  final bool isPassword;
  final bool isConfirm;
  final TextEditingController? passwordController;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.isEmail = false,
    this.isPassword = false,
    this.isConfirm = false,
    this.passwordController,
  });

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      keyboardType:
          widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: widget.isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
                : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.label} cannot be empty';
        }
        if (widget.isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        if (widget.isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (widget.isConfirm && value != widget.passwordController?.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
