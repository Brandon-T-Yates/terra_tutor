import 'package:flutter/material.dart';
import '../Screens/settings_page.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final bool showMenuIcon;

  const TopNavigation({
    required this.title,
    this.backButton = false,
    required this.showMenuIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Directly use the primary color of the theme
    Color backgroundColor = Theme.of(context).primaryColor;
    // Use the icon theme color, falling back to black if not specified
    Color iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          color:
              Theme.of(context).textTheme.headlineLarge?.color ?? Colors.black,
        ),
      ),
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      centerTitle: true,
      automaticallyImplyLeading: backButton,
      actions: showMenuIcon
          ? [
              IconButton(
                icon: const Icon(Icons.menu),
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
