import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Global_Elements/user_input_text_field.dart';
import '/Global_Elements/colors.dart';
import 'home_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SignUpPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBar,
      appBar: AppBar(
        backgroundColor: AppColors.navBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Text(
                    'First Name',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              UserInputTextBox(
                hint: '',
                height: 42.0,
                width: MediaQuery.of(context).size.width * 0.80,
                fontColor: Colors.black,
                boxColor: Colors.white,
                borderRadius: 20.0,
                inputOption: UserInputOption.name,
                controller: firstNameController,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Last Name',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              UserInputTextBox(
                hint: '',
                height: 42.0,
                width: MediaQuery.of(context).size.width * 0.80,
                fontColor: Colors.black,
                boxColor: Colors.white,
                borderRadius: 20.0,
                inputOption: UserInputOption.name,
                controller: lastNameController,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              UserInputTextBox(
                hint: '',
                height: 42.0,
                width: MediaQuery.of(context).size.width * 0.80,
                fontColor: Colors.black,
                boxColor: Colors.white,
                borderRadius: 20.0,
                inputOption: UserInputOption.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Password',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              UserInputTextBox(
                hint: '',
                height: 42.0,
                width: MediaQuery.of(context).size.width * 0.80,
                fontColor: Colors.black,
                boxColor: Colors.white,
                borderRadius: 20.0,
                inputOption: UserInputOption.visualPassword,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              UserInputTextBox(
                hint: '',
                height: 42.0,
                width: MediaQuery.of(context).size.width * 0.80,
                fontColor: Colors.black,
                boxColor: Colors.white,
                borderRadius: 20.0,
                inputOption: UserInputOption.visualPassword,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.uiTile,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                    ),
                    onPressed: () async {
                      final String firstName = firstNameController.text;
                      final String lastName = lastNameController.text;
                      final String email = emailController.text;
                      final String password = passwordController.text;
                      final String confirmPassword = confirmPasswordController.text;

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                          ),
                        );
                        return;
                      }

                      try {
                          UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                          );

                          // Store additional user details in Firestore
                          await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user?.uid)
                            .set({
                              'firstName': firstName,
                              'lastName': lastName,
                              'email': email,
                            });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully signed up!'),
                            ),
                          );

                          // Navigate to the home page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()), // Assuming HomePage is the name of your home page class
                          );
                        } on FirebaseAuthException catch (e) {
                        String message;
                        switch (e.code) {
                          case 'email-already-in-use':
                            message = 'The email address is already in use.';
                            break;
                          case 'invalid-email':
                            message = 'The email address is not valid.';
                            break;
                          case 'operation-not-allowed':
                            message = 'Operation not allowed.';
                            break;
                          case 'weak-password':
                            message = 'The password is too weak.';
                            break;
                          default:
                            message = 'An error occurred.';
                            break;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Icon(Icons.arrow_right_alt, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
