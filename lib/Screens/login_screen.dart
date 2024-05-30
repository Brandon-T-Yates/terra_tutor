import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/Global_Elements/user_input_text_field.dart';
import '/Global_Elements/colors.dart';
import 'home_page.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _signIn(BuildContext context) async {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();
        
        // Check if email and password are not empty
        if (email.isNotEmpty && password.isNotEmpty) {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );

          // Optionally, display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully signed in!'),
            ),
          );
        } else {
          // Display error message if email or password is empty
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email and password cannot be empty'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Display error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navBar,
        elevation: 0,
        title: const Text('signin', style: TextStyle(color: Colors.transparent)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: AppColors.navBar,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    UserInputTextBox(
                      hint: '',
                      height: 42,
                      width: MediaQuery.of(context).size.width * 0.80,
                      fontColor: Colors.black,
                      boxColor: Colors.white,
                      borderRadius: 20.0,
                      inputOption: UserInputOption.emailAddress,
                      controller: emailController,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
                  ],
                ),
                const SizedBox(height: 32.0),
                Stack(
                  children: [
                    const SizedBox(
                      width: 300,
                      height: 60,
                    ),
                    Positioned(
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () => _signIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.uiTile,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
