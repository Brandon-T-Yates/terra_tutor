import 'package:flutter/material.dart';
import '/Global_Elements/bottom_navigation.dart';
import '/Global_Elements/top_navigation.dart';
import '/Global_Elements/colors.dart';
import '/Screens/plant_finder_screen.dart';
import '/Assets/Home_Page_Widgets/daily_facts.dart';
import '/Assets/Home_Page_Widgets/fertilizer_reminder.dart';
import '/Assets/Home_Page_Widgets/plant_photos.dart';
import '/Assets/Home_Page_Widgets/water_reminder.dart';
import '/Assets/Home_Page_Widgets/weather_alerts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: [
                _buildWidgetButton(const DailyFactsWidget()),
                _buildWidgetButton(const FertilizerReminderWidget()),
                _buildWidgetButton(const PlantPhotosWidget()),
                _buildWidgetButton(const WaterReminderWidget()),
                _buildWidgetButton(const WeatherAlertsWidget()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWidgetButton(Widget widget) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          _addedWidgets.add(widget);
        });
      },
      child: widget,
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
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _addedWidgets.map((widget) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        child: widget,
                      );
                    }).toList(),
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
