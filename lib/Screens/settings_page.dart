// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Global_Elements/colors.dart';
import '/Screens/profile_page.dart';
import '/Global_Elements/top_navigation.dart';
import 'entrance_screen.dart'; // Make sure to import your entrance screen

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'Default';

  void setSelectedTheme(String theme) {
    setState(() {
      selectedTheme = theme;
    });
    themeSelectionFunctionality(theme);
  }

  void themeSelectionFunctionality(String theme) {
    switch (theme) {
      case 'Default':
        // Functionality for Default theme
        print('Default theme selected');
        break;
      case 'Tropical Garden':
        // Functionality for Tropical Garden theme
        print('Tropical Garden theme selected');
        break;
      case 'Woodland Forest':
        // Functionality for Woodland Forest theme
        print('Woodland Forest theme selected');
        break;
      case 'High Desert':
        // Functionality for High Desert theme
        print('High Desert theme selected');
        break;
      case 'Redwood Forest':
        // Functionality for Redwood Forest theme
        print('Redwood Forest theme selected');
        break;
      case 'Arctic Garden':
        // Functionality for Arctic Garden theme
        print('Arctic Garden theme selected');
        break;
      default:
        print('Unknown theme selected');
    }
  }

  //When theme is selected this builds the output.
  Widget buildThemeOption(String theme) {
    return GestureDetector(
      onTap: () => setSelectedTheme(theme),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedTheme == theme)
              const Icon(
                Icons.check,
                color: Colors.black,
              ),
            const SizedBox(width: 8.0),
            Text(
              theme,
              style: TextStyle(
                fontSize: 20,
                fontWeight: selectedTheme == theme
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigation(
        title: 'Settings',
        backButton: true,
        showMenuIcon: false,
      ),
      body: Container(
        color: AppColors.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
                child: const Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const ListTile(
                title: Text(
                  'Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                onTap: null, // Implement notification functionality.
              ),
              const ListTile(
                title: Text(
                  'Themes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                onTap: null,
              ),
              const SizedBox(height: 16),
              buildThemeOption('Default'),
              buildThemeOption('Tropical Garden'),
              buildThemeOption('Woodland Forest'),
              buildThemeOption('High Desert'),
              buildThemeOption('Redwood Forest'),
              buildThemeOption('Arctic Garden'),
              const SizedBox(height: 32),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.deleteButton,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(100, 25),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EntranceScreen()),
                  );
                },
                child: const Text(
                  'Logout',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
