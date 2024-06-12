import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/top_navigation.dart';
import 'entrance_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/Global_Elements/app_permission_prompts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late BuildContext _dialogContext;
  String _firstName = 'Placeholder';
  String _lastName = 'Placeholder';
  String _userEmail = 'Placeholder';
  String _username = 'Placeholder';
  bool _userNameChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dialogContext = context;
    // Fetch user data when the widget is built
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user document from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Check if user document exists
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        // Fetch user's first name, last name, and email from Firestore
        _firstName = userData['firstName'] ?? 'First Name not available';
        _lastName = userData['lastName'] ?? 'Last Name not available';
        _userEmail = userData['email'] ?? 'Email not available';
        _username = userData['username'] ?? 'Username not available';

        // Update the UI with fetched data
        setState(() {});
      }
    }
  }

  void _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        await user.delete();

        ScaffoldMessenger.of(_dialogContext).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EntranceScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_dialogContext).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var username = _username;

    Future<void> _pickImage() async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
            // Handle the selected image file
            File imageFile = File(image.path);
            // Update the profile picture logic goes here
            // For example, upload the image to Firebase Storage and update the user's profile picture URL in Firestore
        }
    }

    Future<void> _handleAvatarTap() async {
        bool permissionGranted = await PermissionHandler.showMediaFilePermissionPrompt(context);
        if (permissionGranted) {
            _pickImage();
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Media file access denied')),
            );
        }
    }

    return Scaffold(
      appBar: const TopNavigation(
        title: 'Profile Page',
        backButton: true,
        showMenuIcon: false,
      ),
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: /*_handleAvatarTap*/_pickImage,  // _handleAvatarTap menbtos is not openingmedia file. Revise later.
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.camera_alt, size: 70, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Text(
              '$_firstName $_lastName',
              style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _userNameChanged
                  ? null
                  : () {
                      TextEditingController usernameController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.navBar,
                            title: const Text('Change Username', textAlign: TextAlign.center),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Would you like to change your username?\n'
                                  '*Note you can only do this once.*',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter new username",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
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
                                    child: const Text('Cancel', style: TextStyle(color: AppColors.fontColor)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(width: 30),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.uiTile,
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(color: Colors.black),
                                      fixedSize: const Size(100, 25),
                                    ),
                                    child: const Text('Save', style: TextStyle(color: AppColors.fontColor)),
                                    onPressed: () async {
                                      if (usernameController.text.isNotEmpty) {
                                        User? user = FirebaseAuth.instance.currentUser;
                                        if (user != null) {
                                          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                                            'username': usernameController.text,
                                          });
                                          setState(() {
                                            _userNameChanged = true;
                                            _username = usernameController.text; // Update the local username variable
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Username updated successfully')),
                                          );
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
              child: Text(
                'Username: $_username', // Display the current username
                style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _userEmail,
              style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
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
                        'This action is irreversible.\n'
                        'All of your data will be deleted and cannot be recovered.',
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
                                _deleteAccount();
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
