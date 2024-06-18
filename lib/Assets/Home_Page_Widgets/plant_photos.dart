import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/Global_Elements/ui_tiles.dart';
import '/Global_Elements/colors.dart';

class PlantPhotosWidget extends StatefulWidget {
  const PlantPhotosWidget({super.key});

  @override
  PlantPhotosWidgetState createState() => PlantPhotosWidgetState();
}

class PlantPhotosWidgetState extends State<PlantPhotosWidget> {
  bool hasPhotos = false;
  late File _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (hasPhotos) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppColors.navBar,
                title: const Center(child: Text('Plant Photos')),
                content: const Text('Here are your plant photos!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppColors.navBar,
                title: const Center(child: Text('Plant Photos')),
                content: const Text(
                  'No photos here, but you can add some if you want. :)',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _getImageFromGallery();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: UiTile(
        name: 'Plant Photos',
        image: 'lib/Assets/images/camera.png',
        textAlignment: TextAlignOption.center,
        description: '',
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // Handles saving or displaying the image as needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected from gallery')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    });
  }
}
