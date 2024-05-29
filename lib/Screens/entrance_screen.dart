import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';

class EntranceScreen extends StatelessWidget {
  const EntranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFADC2AF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset(
                'lib/Assets/images/placeholderlogo.png',
                height: 200.0, // Increased size for the logo
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Terra Tutor',
              style: TextStyle(
                fontSize: 50.0, // Increased font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80.0),
            const Text(
              '“Learn to Grow”',
              style: TextStyle(
                fontSize: 24.0, // Increased font size
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 150, // Set a fixed width for the buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFF2E9D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFF2E9D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 75.0),
          ],
        ),
      ),
    );
  }
}
