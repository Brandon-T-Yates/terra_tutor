import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavigation({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: 'Flower Box',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color.fromARGB(255, 107, 106, 106),
      backgroundColor: theme.appBarTheme.backgroundColor,
      onTap: onTap,
    );
  }
}
