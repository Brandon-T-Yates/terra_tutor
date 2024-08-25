// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Global_Elements/user_input_text_field.dart';
import 'package:provider/provider.dart';
import '/Global_Elements/theme_data.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('savedEmail');
    if (savedEmail != null) {
      emailController.text = savedEmail;
      setState(() {
        rememberMe = true;
      });
    }
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('savedEmail', email);
    } else {
      await prefs.remove('savedEmail');
    }
  }

  void signIn(BuildContext context) async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        // Save email if "Remember me" is checked
        await _saveEmail(email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed in!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email and password cannot be empty'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        title:
            const Text('Sign in', style: TextStyle(color: Colors.transparent)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: theme.primaryColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Email',
                        style:
                            theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Password',
                        style:
                            theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
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
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CheckboxListTile(
                    title: Text(
                      'Remember me',
                      style: theme.textTheme.bodyLarge,
                    ),
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: theme.checkboxTheme.fillColor
                            ?.resolve({WidgetState.selected}) ??
                        theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Stack(
                  children: [
                    const SizedBox(
                      width: 300,
                      height: 60,
                    ),
                    Positioned(
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () => signIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Log in',
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                color: theme.textTheme.bodyLarge?.color),
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
