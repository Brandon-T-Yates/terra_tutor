import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:terra_tutor/Screens/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * 1.2,
          ),
        ),
        backgroundColor: AppColors.navBar,
        centerTitle: true,
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
                   Navigator.pushNamed(context, '/profile');
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
