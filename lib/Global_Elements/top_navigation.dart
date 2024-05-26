import 'package:flutter/material.dart';
import 'settings_page.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color iconColor;

  const TopNavigation({
    this.backgroundColor = const Color(0xFFADC2AF),
    this.iconColor = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Terra Tutor",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      backgroundColor: backgroundColor,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          color: iconColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
