import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/top_navigation.dart';
import 'entrance_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/Global_Elements/app_permission_prompts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late BuildContext _dialogContext;
  String _firstName = 'Placeholder';
  String _lastName = 'Placeholder';
  String _userEmail = 'Placeholder';
  String _username = 'Placeholder';
  String? _profileImageURL;
  bool _userNameChanged = false;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _emailChangePerformed = false;
  bool _canChangeEmail = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dialogContext = context;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        _firstName = userData['firstName'] ?? 'First Name not available';
        _lastName = userData['lastName'] ?? 'Last Name not available';
        _userEmail = userData['email'] ?? 'Email not available';
        _username = userData['username'] ?? 'Username not available';
        _profileImageURL = userData['profilePicture'];
        setState(() {});
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImageURL = null;
      });
      File imageFile = File(pickedFile.path);
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) return;
        String fileName = 'profile_pictures/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(imageFile);
        String downloadURL = await snapshot.ref.getDownloadURL();
        await firestore.collection('users').doc(user.uid).update({'profilePicture': downloadURL});
        setState(() {
          _profileImageURL = downloadURL;
        });
      } catch (e) {
        print('Failed to upload Image: $e');
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

   Future<void> _resetPassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          Timestamp? lastResetTimestamp = userData['lastPasswordReset'];

          if (lastResetTimestamp != null) {
            DateTime lastResetTime = lastResetTimestamp.toDate();
            DateTime now = DateTime.now();
            if (now.difference(lastResetTime).inSeconds < 1) {
              showDialog(
                context: _dialogContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppColors.navBar,
                    title: const Text(
                      'Password Reset',
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      'You can only request a password reset once per hour. Please try again later.',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.uiTile,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            fixedSize: const Size(100, 25),
                          ),
                          child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
                        ),
                      ),
                    ],
                  );
                },
              );
              return;
            }
          }

          await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'lastPasswordReset': Timestamp.now(),
          });

          showDialog(
            context: _dialogContext,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppColors.navBar,
                title: const Text(
                  'Password Reset',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'A reset link has been sent to your email. Please follow the instructions to reset your password! :)',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const EntranceScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.uiTile,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        fixedSize: const Size(100, 25),
                      ),
                      child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      showDialog(
        context: _dialogContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.navBar,
            title: const Text(
              'Error',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Error: ${e.toString()}',
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.uiTile,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: const Size(100, 25),
                  ),
                  child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _changeEmail() async {
    if (!mounted) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if email can be changed
        if (!_canChangeEmail) {
          if (!mounted) return;
          ScaffoldMessenger.of(_dialogContext).showSnackBar(
            const SnackBar(
              content: Text('You cannot change your email again until you log out and back in.'),
            ),
          );
          return;
        }

        TextEditingController passwordController = TextEditingController();

        await showDialog(
          context: _dialogContext,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.navBar,
              title: const Center(child: Text('Change Email')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: Text('Please enter your current password for verification:')),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
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
                  child: const Text('Cancel', style: TextStyle(color: AppColors.fontColor)),
                ),
                TextButton(
                  onPressed: () async {
                    if (passwordController.text.isNotEmpty) {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: passwordController.text,
                      );

                      await user.reauthenticateWithCredential(credential);
                      if (!mounted) return;
                      Navigator.of(context).pop();

                      // Show dialog to get new email address
                      TextEditingController newEmailController = TextEditingController();
                      await showDialog(
                        context: _dialogContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.navBar,
                            title: const Center(child: Text('Enter New Email')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Center(child: Text('Please enter your new email address:')),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: newEmailController,
                                  decoration: InputDecoration(
                                    hintText: "New email",
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
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
                                child: const Text('Cancel', style: TextStyle(color: AppColors.fontColor)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (newEmailController.text.isNotEmpty) {
                                    // Send verification email to new email address
                                    await user.verifyBeforeUpdateEmail(newEmailController.text);
                                    if (!mounted) return;
                                    // Update local UI state with new email
                                    setState(() {
                                      _userEmail = newEmailController.text;
                                    });
                                    setState(() {
                                      _emailChangePerformed = true;
                                    });
                                    // Disable further email changes until logout/login
                                    setState(() {
                                      _canChangeEmail = false;
                                    });
                                    Navigator.of(context).pop(); 
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Email update verification sent to new email address.'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter your new email address.'),
                                      ),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.uiTile,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black),
                                  fixedSize: const Size(100, 25),
                                ),
                                child: const Text('Save', style: TextStyle(color: AppColors.fontColor)),
                              ),
                            ],
                          );
                        },
                      );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your password.'),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.uiTile,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: const Size(100, 25),
                  ),
                  child: const Text('Next', style: TextStyle(color: AppColors.fontColor)),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showDialog(
        context: _dialogContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.navBar,
            title: const Center(child: Text('Error')),
            content: Center(child: Text('Error: ${e.message}')),
            actions: [
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
                child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: _dialogContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.navBar,
            title: const Center(child: Text('Error')),
            content: Center(child: Text('Error: $e')),
            actions: [
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
                child: const Text('OK', style: TextStyle(color: AppColors.fontColor)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleAvatarTap() async {
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
              onTap: _pickImage,
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
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _profileImageURL != null
                      ? NetworkImage(_profileImageURL!)
                      : null,
                  backgroundColor: Colors.grey,
                  child: _profileImageURL == null
                      ? const Icon(Icons.camera_alt, size: 70, color: Colors.black)
                      : null,
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
                                            _username = usernameController.text;
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
                'Username: $_username',
                style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _userEmail,
              style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: _resetPassword,
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
              onPressed: _changeEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiTile,
                foregroundColor: AppColors.fontColor,
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(200, 50),
              ),
              child: const Text('Change Email', style: TextStyle(fontSize: 18)),
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