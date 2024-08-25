// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global_Elements/colors.dart';
import '/Screens/profile_page.dart';
import '/Global_Elements/top_navigation.dart';
import 'entrance_screen.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'Default';

  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  Future<void> _loadSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = prefs.getString('selectedTheme') ?? 'Default';
    });
  }

  Future<void> _setSelectedTheme(String theme) async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    setState(() {
      selectedTheme = theme; // Update the selected theme state
    });

    switch (theme) {
      case 'Default':
        themeNotifier.setTheme(ThemeNotifier.defaultTheme);
        break;
      case 'Tropical Garden':
        themeNotifier.setTheme(ThemeNotifier.tropicalGardenTheme);
        break;
      case 'Woodland Forest':
        themeNotifier.setTheme(ThemeNotifier.woodlandForestTheme);
        break;
      case 'High Desert':
        themeNotifier.setTheme(ThemeNotifier.highDesertTheme);
        break;
      case 'Redwood Forest':
        themeNotifier.setTheme(ThemeNotifier.redwoodForestTheme);
        break;
      case 'Arctic Garden':
        themeNotifier.setTheme(ThemeNotifier.arcticGardenTheme);
        break;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedTheme', theme);

    // Navigate back to the home screen
    Navigator.of(context).pop();
  }

  Widget buildThemeOption(String theme) {
    return GestureDetector(
      onTap: () => _setSelectedTheme(theme),
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
