import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/colors.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';

class EntranceScreen extends StatelessWidget {
  const EntranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBar,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double logoHeight =
                constraints.maxHeight * 0.25; // 25% of the screen height
            double fontSizeTitle =
                constraints.maxWidth * 0.1; // 10% of the screen width
            double fontSizeSubtitle =
                constraints.maxWidth * 0.05; // 5% of the screen width
            double buttonWidth =
                constraints.maxWidth * 0.3; // 30% of the screen width
            double buttonHeight =
                constraints.maxHeight * 0.05; // 5% of the screen height

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'lib/Assets/images/placeholderlogo.png',
                      height: logoHeight,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Terra Tutor',
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 40.0), // Adjusted to provide better spacing
                Text(
                  '“Learn to Grow”',
                  style: TextStyle(
                    fontSize: fontSizeSubtitle,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
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
                      backgroundColor: AppColors.uiTile,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: AppColors.uiTile,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                const SizedBox(
                    height: 60.0), // Adjusted to match the overall spacing
              ],
            );
          },
        ),
      ),
    );
  }
}
