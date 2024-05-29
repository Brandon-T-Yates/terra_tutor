import 'package:flutter/material.dart';
import 'colors.dart';

enum TextAlignOption { center, topLeft }

class UiTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color shadowColor;
  final double spreadRadius;
  final double blurRadius;
  final Offset offset;
  final TextStyle nameTextStyle;
  final TextStyle descriptionTextStyle;
  final BoxFit imageFit;
  final TextAlignOption textAlignment;

  UiTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.textAlignment,
    this.width = 160,
    this.height = 180,
    this.margin = const EdgeInsets.only(left: 30),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor = AppColors.uiTile,
    this.shadowColor = Colors.grey,
    this.spreadRadius = 1,
    this.blurRadius = 7,
    this.offset = const Offset(0, 3),
    this.nameTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.descriptionTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    this.imageFit = BoxFit.cover,
  }) {
    assert(textAlignment == TextAlignOption.center ||
        textAlignment == TextAlignOption.topLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              spreadRadius: spreadRadius,
              blurRadius: blurRadius,
              offset: offset,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: height * 0.35,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: imageFit,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: textAlignment == TextAlignOption.center
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: nameTextStyle,
                      textAlign: textAlignment == TextAlignOption.center
                          ? TextAlign.center
                          : TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: descriptionTextStyle,
                      textAlign: textAlignment == TextAlignOption.center
                          ? TextAlign.center
                          : TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
