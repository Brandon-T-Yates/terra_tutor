// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Camera Permission denied even if allow button is pressed. This might be due to emulator.
// Later testing on non emulated device will be done later.
class PermissionHandler {
  static Future<void> showCameraPermissionPrompt(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Camera Permission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('This app needs access to your camera to take photos.'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Deny'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      PermissionStatus status = await Permission.camera.request();
                      if (status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera permission granted')),
                        );
                      } else if (status.isDenied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera permission denied')),
                        );
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    },
                    child: const Text('Allow'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Location permission code added. When "Allow" button pressed, location permission denied.
  // Further test is requeired on non-emulated device.

  static Future<void> showLocationPermissionPrompt(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Permission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('This app needs access to your location to provide location-based services.'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Deny'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      PermissionStatus status = await Permission.location.request();
                      if (status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Location permission granted')),
                        );
                      } else if (status.isDenied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Location permission denied')),
                        );
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    },
                    child: const Text('Allow'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


