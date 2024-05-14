import 'package:flutter/material.dart';

// File for reuseable textboxes for the Global UI Elements of the project.

class CustomTextField extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Color boxColor;
  final Color fontColor;

  const CustomTextField({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    required this.fontColor,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        readOnly: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          border: const OutlineInputBorder(),
          hintText: text,
          hintStyle: TextStyle(color: fontColor),
        ),
      ),
    );
  }
}

// Enum for input box uses
enum UserInputOption { name, emailAddress, visualPassword, datetime }

// User imput boxes
class UserInputTextBox extends StatelessWidget {
  final String hint;
  final double height;
  final double width;
  final Color boxColor;
  final Color fontColor;
  final UserInputOption inputOption;
  final TextEditingController controller;

  const UserInputTextBox
  ({
    super.key,
    required this.hint,
    this.height = 35.0,
    this.width = 300.0,
    required this.fontColor,
    required this.boxColor,
    required this.inputOption,
    required this.controller,
  });

  TextInputType _getKeyboardType() 
  {
    switch (inputOption) 
    {
      case UserInputOption.name:
        return TextInputType.name;
      case UserInputOption.emailAddress:
        return TextInputType.emailAddress;
      case UserInputOption.visualPassword:
        return TextInputType.visiblePassword;
      case UserInputOption.datetime:
        return TextInputType.datetime;
    }
  }

  bool _isPassword() 
  {
    return inputOption == UserInputOption.visualPassword;
  }

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
    (
      height: height,
      width: width,
      child: TextField
      (
        controller: controller,
        keyboardType: _getKeyboardType(),
        maxLines: 1,
        obscureText: _isPassword(),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration
        (
          filled: true,
          fillColor: boxColor,
          border: const OutlineInputBorder
          (
            borderRadius: BorderRadius.all
            (
              Radius.circular(12),
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: fontColor),
        ),
      ),
    );
  }
}
