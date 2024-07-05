import 'dart:io';
import 'package:flutter/material.dart';
import 'colors.dart';

enum TextAlignOption { center, topLeft }

class UiTile extends StatelessWidget {
  final String? imagePath;
  final File? image;
  final NetworkImage? networkImage;
  final String name;
  final String? description;
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
  final bool hasPhotos;
  final double imageHeightRatio;

  UiTile({
    super.key,
    this.imagePath,
    this.image,
    this.networkImage,
    required this.name,
    this.description,
    required this.textAlignment,
    this.width = 300,
    this.height = 200,
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
    this.hasPhotos = false,
    this.imageHeightRatio = .37,
  }) {
    assert(textAlignment == TextAlignOption.center ||
        textAlignment == TextAlignOption.topLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
            if (imagePath != null && imagePath!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: height * imageHeightRatio,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      imagePath!,
                      fit: imageFit,
                    ),
                  ),
                ),
              ),
            if (imagePath == null || imagePath!.isEmpty) const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: textAlignment == TextAlignOption.center
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: name == 'Daily Facts'
                        ? nameTextStyle.copyWith(
                            decoration: TextDecoration.underline,
                          )
                        : nameTextStyle,
                    textAlign: textAlignment == TextAlignOption.center
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        description!,
                        style: descriptionTextStyle,
                        textAlign: textAlignment == TextAlignOption.center
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
