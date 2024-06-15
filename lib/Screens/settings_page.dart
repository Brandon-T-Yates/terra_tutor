import 'package:flutter/material.dart';
import '../Global_Elements/colors.dart';
import '/Screens/profile_page.dart';
import '/Global_Elements/top_navigation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigation(
        title: 'Settings', // Pass the required title here
        backButton: true,
        showMenuIcon: false,
      ),
      body: Container(
        color: AppColors.primaryColor, // Change color after color from palette is decided
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: const Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     'Profile',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: null, // Implement navigation or function here
              // ),
              // TODO: convert the rest of these to be text buttons
              const ListTile(
                title: Text(
                  'Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                onTap: null, // Implement navigation or function here
              ),
              const ListTile(
                title: Text(
                  'Themes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                onTap: null, // Implement navigation or function here
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Default',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tropical Garden',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Woodland Forest',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'High Desert',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Redwood Forest',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Arctic Garden',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
