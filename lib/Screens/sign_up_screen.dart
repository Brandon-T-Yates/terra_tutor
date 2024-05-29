import 'package:flutter/material.dart';
import '/Global_Elements/user_input_text_field.dart';
import '/Global_Elements/colors.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
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
                    'First & Last Name',
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
                      backgroundColor: const Color(0xFFF2E9D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                    ),
                    onPressed: () {
                      // Add sign-up logic here
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