import 'package:flutter/material.dart';

// Enum for input box uses
enum UserInputOption { name, emailAddress, visualPassword, datetime }

// User input boxes
class UserInputTextBox extends StatelessWidget {
  final String hint;
  final double height;
  final double width;
  final Color boxColor;
  final Color fontColor;
  final double borderRadius;
  final UserInputOption inputOption;
  final TextEditingController controller;

  const UserInputTextBox({
    super.key,
    required this.hint,
    required this.height,
    required this.width,
    required this.fontColor,
    required this.boxColor,
    required this.borderRadius,
    required this.inputOption,
    required this.controller,
  });

  TextInputType _getKeyboardType() {
    switch (inputOption) {
      case UserInputOption.name:
        return TextInputType.name;
      case UserInputOption.emailAddress:
        return TextInputType.emailAddress;
      case UserInputOption.visualPassword:
        return TextInputType.visiblePassword;
      case UserInputOption.datetime:
        return TextInputType.datetime;
      default:
        return TextInputType.text;
    }
  }

  bool _isPassword() {
    return inputOption == UserInputOption.visualPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: _getKeyboardType(),
        maxLines: 1,
        obscureText: _isPassword(),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
          hintText: hint,
          hintStyle: TextStyle(color: fontColor),
        ),
      ),
    );
  }
}
