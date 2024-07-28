import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CameraService {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
  }

  CameraController? get controller => _controller;

  Future<void> takePicture(Function(File) onPictureTaken) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: Camera not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.png');
      final imageFile = await File(image.path).copy(imagePath);

      onPictureTaken(imageFile);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> identifyPlant(
      File imageFile, Function(Map<String, dynamic>) onPlantIdentified) async {
    final String apiKey = dotenv.env['PLANT_ID_API_KEY']!;
    final String apiUrl = 'https://api.plant.id/v2/identify';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['api_key'] = apiKey
        ..files
            .add(await http.MultipartFile.fromPath('images', imageFile.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        print('API response: $data'); // Log the response data

        if (data['suggestions'] != null && data['suggestions'].isNotEmpty) {
          final plant = data['suggestions'][0]['plant'];
          onPlantIdentified(plant);
        } else {
          print('No suggestions found');
          onPlantIdentified({
            'name': 'Unknown Plant',
            'description': 'No description available',
            'image_url': 'lib/Assets/images/rose_placeholder.jpg',
          });
        }
      } else {
        print('Failed to identify plant: ${responseData.body}');
        onPlantIdentified({
          'name': 'Unknown Plant',
          'description': 'No description available',
          'image_url': 'lib/Assets/images/rose_placeholder.jpg',
        });
      }
    } catch (e) {
      print('Error identifying plant: $e');
      onPlantIdentified({
        'name': 'Unknown Plant',
        'description': 'No description available',
        'image_url': 'lib/Assets/images/rose_placeholder.jpg',
      });
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
