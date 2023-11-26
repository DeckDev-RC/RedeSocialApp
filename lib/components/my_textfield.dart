import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
          style: TextStyle(color: Colors.grey[500]!),
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]!),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: hintText,
            //hintStyle: TextStyle(
            //color: Theme.of(context).hintColor,
          )),
    );
  }
}
