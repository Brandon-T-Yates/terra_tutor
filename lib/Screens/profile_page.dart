// ignore_for_file: avoid_types_as_parameter_names


import 'package:flutter/material.dart';
import '/Global_Elements/colors.dart';
import 'package:terra_tutor/Global_Elements/top_navigation.dart';
import 'package:terra_tutor/Global_Elements/bottom_navigation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigation(),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onTap: (int) {}, // Waiting on Graham to give me guidance on what this function is for.
      ),
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200, // Radius 40 + border width 4
              height: 200, // Radius 40 + border width 4
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.5, // Border width
                ),
              ),
              child: const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                child: Icon(Icons.camera_alt, size: 70, color: Colors.black),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Name: Placeholder', // Logic will be changed to pull in users name inputted at sign up.
              style: TextStyle(fontSize: 18, color: AppColors.fontColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Username: Placeholder', // Logic will be changed to pull users inputted Username at sign up.
              style: TextStyle(fontSize: 18, color: AppColors.fontColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Email: Placeholder', // Logic will be changed to pull users inputted email at sign up.
              style: TextStyle(fontSize: 18, color: AppColors.fontColor),
            ),
            const SizedBox(height: 130),
            ElevatedButton(
              onPressed: () {
                // Full reset password logic will be added later
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Password Reset'),
                      content: const Text('This feature is still under development.'),
                      actions: [
                        TextButton(
                          child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiTile,
                foregroundColor: AppColors.fontColor,
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(200, 50),
              ),
              child: const Text('Reset Password', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Delete Profile logic will be added later
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: AppColors.navBar,
                      title: const Text(
                        'Delete Profile',
                        textAlign: TextAlign.center,
                      ),
                      content: const Text(
                        'Are you sure you want to delete your profile? '
                        'This action is irreverable.\n'
                        'All of your garden data will be deleted and not recoverable.',
                        textAlign: TextAlign.center,
                        
                        ),
                      actions: [                        
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center,                     
                          children: [
                            TextButton(                              
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.deleteButton,
                                foregroundColor: Colors.white, 
                                side: const BorderSide(color: Colors.black),
                                fixedSize: const Size(100, 25), 
                              ),
                              onPressed: () {
                                // Actual profile delete funtion will be added later.
                                Navigator.of(context).pop();
                              },                              
                              child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(width: 30),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.uiTile,
                                foregroundColor: Colors.black, 
                                side: const BorderSide(color: Colors.black),
                                fixedSize: const Size(100, 25),
                              ),
                              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteButton,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(200, 50),
              ),
              child: const Text('Delete Profile', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
