import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler
{
  static Future<void> showCameraPermissionPrompt(BuildContext context) async
  {
    return showModalBottomSheet
    (
      context: context, 
      builder: (BuildContext context)
      {
        return Container
        (
          padding: EdgeInsets.all(20.0),
          height: 200,
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text
              (
                'camera Permission',
                style: TextStyle
                (
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('This app needs access to your camera to take photos.'),
              SizedBox(height: 20),
              Row
              (
                mainAxisAlignment: MainAxisAlignment.end,
                children: 
                [
                  TextButton
                  (
                    onPressed: ()
                    {
                      Navigator.pop(context);
                    },
                  )
                ]
              )
            ]
          )
        );
      }
    );
  }
}
