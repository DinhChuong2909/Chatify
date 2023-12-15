import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  CustomTextFormField({
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (value) {
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid value';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 36, 1.0),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
