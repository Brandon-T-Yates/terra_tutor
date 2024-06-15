import 'package:flutter/material.dart';
import '/Global_Elements/bottom_navigation.dart';
import '/Global_Elements/top_navigation.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/ui_tiles.dart';
import '/Screens/plant_finder_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; 
  final List<Widget> _addedWidgets = []; 

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Flower Box Page')),
    Center(child: Text('')),
    PlantFinderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.navBar,
          title: const Center(child: Text('Add Widgets')),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _addedWidgets.add(UiTile(
                        imagePath: 'lib/Assets/images/image.png',
                        name: 'Widget $index',
                        description: '',
                        textAlignment: TextAlignOption.topLeft,
                      ));
                    });
                  },
                  child: UiTile(
                    imagePath: 'lib/Assets/images/image.png',
                    name: 'Widget $index',
                    description: '', 
                    textAlignment: TextAlignOption.topLeft,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigation(
        title: 'Terra Tutor',
        showMenuIcon: true,
      ),
      body: Container(
        color: AppColors.primaryColor,
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            if (_selectedIndex == 1)
              SingleChildScrollView(
                child: Container(
                  color: AppColors.primaryColor,
                  child: Wrap(
                    children: _addedWidgets,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _onAddButtonPressed,
              tooltip: 'Add',
              backgroundColor: AppColors.navBar,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}