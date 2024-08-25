// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Global_Elements/bottom_navigation.dart';
import '/Global_Elements/top_navigation.dart';
import '/Global_Elements/colors.dart';
import '/Screens/plant_finder_screen.dart';
import '/Assets/Home_Page_Widgets/daily_facts.dart';
import '/Assets/Home_Page_Widgets/fertilizer_reminder.dart';
import '/Assets/Home_Page_Widgets/plant_photos.dart';
import '/Assets/Home_Page_Widgets/water_reminder.dart';
import '/Assets/Home_Page_Widgets/weather_alerts.dart';
import '/Assets/Home_Page_Widgets/add_widget_button.dart';
import '/Global_Elements/ui_tiles.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Screens/flower_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  List<String> _addedWidgetTypes = [];
  SharedPreferences? _prefs;

  final List<Widget> _pages = <Widget>[
    const FlowerBoxHomePage(),
    const Center(child: Text('')),
    const PlantFinderScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  // Load shared preferences
  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    loadWidgets();
  }

  // Load the previous widgets
  void loadWidgets() {
    setState(() {
      _addedWidgetTypes = _prefs?.getStringList('addedWidgets') ?? [];
    });
  }

  // Save widgets to shared prefs after adding
  void saveWidgets() {
    _prefs?.setStringList('addedWidgets', _addedWidgetTypes);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Adding a new widget to homescreen
  void _onAddButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Center(
            child: Text(
              'Add Widgets',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                AddWidgetButton(
                  name: 'Daily Facts',
                  imagePath: 'lib/Assets/images/facts.png',
                  onTap: () {
                    _addWidgetToHome('DailyFactsWidget');
                  },
                ),
                AddWidgetButton(
                  name: 'Fertilizer Reminder',
                  imagePath: 'lib/Assets/images/fertilizer.png',
                  onTap: () {
                    _addWidgetToHome('FertilizerReminderWidget');
                  },
                ),
                AddWidgetButton(
                  name: 'Plant Photos',
                  imagePath: 'lib/Assets/images/camera.png',
                  onTap: () {
                    _addWidgetToHome('PlantPhotosWidget');
                  },
                ),
                AddWidgetButton(
                  name: 'Water Reminder',
                  imagePath: 'lib/Assets/images/watering.png',
                  onTap: () {
                    _addWidgetToHome('WaterReminderWidget');
                  },
                ),
                AddWidgetButton(
                  name: 'Weather Alerts',
                  imagePath: 'lib/Assets/images/weather.png',
                  onTap: () {
                    _addWidgetToHome('WeatherAlertsWidget');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addWidgetToHome(String widgetType) {
    Navigator.of(context).pop();
    setState(() {
      _addedWidgetTypes.add(widgetType);
      saveWidgets();
    });
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<ThemeNotifier>(context).getTheme();
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Theme.of(context).primaryColor,
          ),
          child: AlertDialog(
            title: const Text('Delete Widget'),
            content: const Text('Do you want to delete this widget?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(95, 25),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    String widgetType = _addedWidgetTypes[index];
                    _addedWidgetTypes.removeAt(index);
                    saveWidgets();
                    if (widgetType == 'WeatherAlertsWidget') {
                      _removeCityFromFirebase();
                    }
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(90, 25),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeCityFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.update({'city': FieldValue.delete()});
    }
  }

  void _onWidgetUpdated() {
    setState(() {
      // Refresh the list of widgets
      _addedWidgetTypes = _prefs?.getStringList('addedWidgets') ?? [];
    });
  }

  List<Widget> _buildAddedWidgets() {
    return _addedWidgetTypes.asMap().entries.map((entry) {
      int index = entry.key;
      String widgetType = entry.value;

      Widget widget;
      switch (widgetType) {
        case 'DailyFactsWidget':
          widget = const DailyFactsWidget();
          break;
        case 'FertilizerReminderWidget':
          widget = const FertilizerReminderWidget();
          break;
        case 'PlantPhotosWidget':
          widget = const PlantPhotosWidget(
              imagePath: 'lib/Assets/images/camera.png');
          break;
        case 'WaterReminderWidget':
          widget = WaterReminderWidget(
            onWidgetUpdated: _onWidgetUpdated,
          );
          break;
        case 'WeatherAlertsWidget':
          widget = const WeatherAlertsWidget();
          break;
        default:
          widget = UiTile(
            imagePath: 'lib/Assets/images/image.png',
            name: widgetType,
            description: '',
            textAlignment: TextAlignOption.topLeft,
          );
      }

      return GestureDetector(
        onLongPress: () => showDeleteDialog(index),
        child: widget,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();
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
                    children: _buildAddedWidgets().map((widget) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 32.0,
                          child: widget,
                        ),
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
              heroTag: 'addWidgetFAB',
              onPressed: _onAddButtonPressed,
              tooltip: 'Add',
              backgroundColor: theme.appBarTheme.backgroundColor,
              foregroundColor: theme.iconTheme.color,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
