import 'package:flutter/material.dart';
import '../Screens/settings_page.dart';
import 'colors.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color iconColor;
  final bool backButton;
  final bool showMenuIcon;
  final String title;

  const TopNavigation({
    required this.title,
    this.backgroundColor = AppColors.navBar,
    this.iconColor = Colors.black,
    this.backButton = false,
    required this.showMenuIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,

        ),
      ),
      backgroundColor: backgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: backButton,
      actions: showMenuIcon
          ? [
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
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
