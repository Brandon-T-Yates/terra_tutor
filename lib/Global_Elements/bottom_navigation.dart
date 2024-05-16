import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final Color selectedItemColor;
  final Color backgroundColor;

  const BottomNavigation({
    required this.selectedIndex,
    required this.onTap,
    this.selectedItemColor = const Color.fromARGB(255, 242, 233, 216),
    this.backgroundColor = const Color(0xFFADC2AF),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
      selectedItemColor: selectedItemColor,
      onTap: onTap,
      backgroundColor: backgroundColor,
    );
  }
}
