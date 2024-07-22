// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/top_navigation.dart';
import 'entrance_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  // ignore: unused_field
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

  Future<void> _reauthenticateUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  TextEditingController passwordController = TextEditingController();
  return showDialog(
    context: _dialogContext,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.navBar,
        title: const Center(child: Text('Re-authenticate')),
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

                try {
                  await user.reauthenticateWithCredential(credential);
                  Navigator.of(context).pop();
                  _showDeleteConfirmationDialog();
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(_dialogContext).showSnackBar(
                    SnackBar(content: Text('Re-authentication failed: ${e.message}')),
                  );
                }
              } else {
                ScaffoldMessenger.of(_dialogContext).showSnackBar(
                  const SnackBar(content: Text('Please enter your password.')),
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

  void _showDeleteConfirmationDialog() {
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
    return Scaffold(
      appBar: const TopNavigation(
        title: 'Profile Page',
        backButton: true,
        showMenuIcon: false,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
                  children: [
                    const TextSpan(text: 'Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${capitalize(_firstName)} ${capitalize(_lastName)}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
                        children: [
                          const TextSpan(text: 'Username: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: _username),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black, size: 18),
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
                                        maxLength: 12,
                                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: AppColors.fontColor),
                  children: [
                    const TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: _userEmail),
                  ],
                ),
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
                  _reauthenticateUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deleteButton,
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(200, 50),
                ),
                child: const Text('Delete Profile', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    );
  }
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}