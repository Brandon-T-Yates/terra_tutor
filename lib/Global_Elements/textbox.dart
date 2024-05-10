import 'package:flutter/material.dart';

// File for reuseable textboxes for the Global UI Elements of the project.

class CustomTextField extends StatelessWidget
{
  final String text;
  final double height;
  final double width;
  final Color boxColor;
  final Color fontColor;

  const CustomTextField
  ({super.key, 
    required this.text, 
    required this.height, 
    required this.width,
    required this.fontColor,
    required this.boxColor,
  }); 
  

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
    (
      height: height,
      width: width,
      child: TextField
      (
        keyboardType: TextInputType.multiline,
        maxLines: null,
        expands: true,
        decoration: InputDecoration
        (
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