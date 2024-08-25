// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraScreen extends StatelessWidget {
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final Function(File) onPictureTaken;

  const CameraScreen({
    required this.controller,
    required this.initializeControllerFuture,
    required this.onPictureTaken,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await initializeControllerFuture;
            final image = await controller.takePicture();

            final directory = await getApplicationDocumentsDirectory();
            final imagePath =
                path.join(directory.path, '${DateTime.now()}.png');
            final imageFile = await File(image.path).copy(imagePath);

            print('Picture taken and saved to: $imagePath');
            onPictureTaken(imageFile);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          } catch (e) {
            print('Error taking picture: $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
