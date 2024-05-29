import 'package:flutter/material.dart';
import '/Global_Elements/user_input_text_field.dart';
import '/Global_Elements/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    //Top nav bar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title:
            const Text('signin', style: TextStyle(color: Colors.transparent)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      //All Login elmemnts container
      body: Container(
        color: const Color(0xFFADC2AF),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Login text
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //bOX containing email text and input
                const SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Email label
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    //User input text box
                    UserInputTextBox(
                      hint: '', // No hint
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
                // Box containing password text and input
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      //Text and style for password
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    //User input password box
                    UserInputTextBox(
                      hint: '', // No hint
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

                //Login button
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
                        onPressed: () {
                          // Implement login functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2E9D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                        ),
                        //Log in button text
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
                            //Arrow image
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
