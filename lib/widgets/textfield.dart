import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final InputDecoration inputDecoration;
  final String hintText;
  final Function(String) onChange;
  final Function(String) validator;
  final bool obscureText;

  TextInput(
      {this.inputDecoration,
      this.hintText,
      this.onChange,
      this.validator,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: inputDecoration.copyWith(hintText: hintText),
      validator: validator,
      onChanged: onChange,
      obscureText: obscureText,
    );
  }
}

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0)),
    errorStyle: TextStyle(color: Colors.black));
