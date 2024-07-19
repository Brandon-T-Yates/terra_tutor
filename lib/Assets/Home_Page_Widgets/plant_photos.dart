import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Global_Elements/ui_tiles.dart';
import '/Global_Elements/colors.dart';

class PlantPhotosWidget extends StatefulWidget {
  final String imagePath;

  const PlantPhotosWidget({super.key, required this.imagePath});

  @override
  PlantPhotosWidgetState createState() => PlantPhotosWidgetState();
}

class PlantPhotosWidgetState extends State<PlantPhotosWidget> {
  bool hasPhotos = false;
  String? _imageUrl;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _imageUrl = userData['plantPhoto'];
          hasPhotos = _imageUrl != null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (hasPhotos) {
          _showUpdateDialog();
        } else {
          _showAddDialog();
        }
      },
      child: UiTile(
        name: 'Plant Photos',
        imagePath: widget.imagePath,
        networkImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
        textAlignment: TextAlignOption.center,
        description: '',
        hasPhotos: hasPhotos,
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.navBar,
          title: const Center(
            child: Text(
              'Plant Photos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            'No photos here, but you can add some if you want. :)',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiTile,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(100, 25),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _pickImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.uiTile,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(100, 25),
                ),
                child: const Text('Add', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.navBar,
          title: const Center(
            child: Text(
              'Update Plant Photo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            'Do you want to update your plant photo?',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiTile,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(100, 25),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _pickImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.uiTile,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(100, 25),
                ),
                child: const Text('Update', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = null;
      });
      File imageFile = File(pickedFile.path);

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        String fileName = 'plant_photos/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(imageFile);
        String downloadURL = await snapshot.ref.getDownloadURL();

        await firestore.collection('users').doc(user.uid).update({'plantPhoto': downloadURL});

        setState(() {
          _imageUrl = downloadURL;
          hasPhotos = true;
        });
      } catch (e) {
        // Handle error
        print('Error uploading image: $e');
      }
    }
  }
}

