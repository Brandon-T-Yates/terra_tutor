import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AllPlantsPage extends StatefulWidget {
  final List<String> allPlants;

  const AllPlantsPage({super.key, required this.allPlants});

  @override
  AllPlantsPageState createState() => AllPlantsPageState();
}

class AllPlantsPageState extends State<AllPlantsPage> {
  late List<String> plants;
  List<Map<String, dynamic>> _favoritedFlowers = [];

  final Map<String, Map<String, String>> plantCareInfo = {
    // Vegetables
    'Carrot': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Tomato': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Lettuce': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Partial shade'
    },
    'Pepper': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Cucumber': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Spinach': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Partial shade'
    },
    'Onion': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Garlic': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Potato': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Broccoli': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Cauliflower': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Eggplant': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Zucchini': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Radish': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Celery': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Partial shade'
    },
    'Peas': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Beans': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Sweet Corn': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Pumpkin': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Squash': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Beetroot': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Bell Pepper': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Brussels Sprouts': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Kale': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Partial shade'
    },
    'Leek': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Okra': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Parsnip': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Rhubarb': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Partial shade'
    },
    'Turnip': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Artichoke': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Asparagus': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },

    // Fruits
    'Apple': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Banana': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Strawberry': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Grapes': {
      'water': 'Every 5-7 days',
      'fertilize': 'Every 4-6 weeks',
      'sunlight': 'Full sun'
    },
    'Orange': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Lemon': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Blueberry': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Watermelon': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Pineapple': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Mango': {
      'water': 'Every 5-7 days',
      'fertilize': 'Every 4-6 weeks',
      'sunlight': 'Full sun'
    },
    'Peach': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Plum': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Cherry': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Pear': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Raspberry': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Blackberry': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Fig': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Pomegranate': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },
    'Kiwi': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Avocado': {
      'water': 'Every 7-10 days',
      'fertilize': 'Every 6-8 weeks',
      'sunlight': 'Full sun'
    },

    // Flowers
    'Rose': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Tulip': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Daisy': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Sunflower': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Lily': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Daffodil': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Marigold': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Orchid': {
      'water': 'Every 3-4 days',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Partial shade'
    },
    'Lavender': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Carnation': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Chrysanthemum': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Iris': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Peony': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Begonia': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Partial shade'
    },
    'Jasmine': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Poppy': {
      'water': 'Every day',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Full sun'
    },
    'Petunia': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Hibiscus': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Dahlia': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Full sun'
    },
    'Azalea': {
      'water': 'Every 2-3 days',
      'fertilize': 'Every 4 weeks',
      'sunlight': 'Partial shade'
    },
    'Violet': {
      'water': 'Every day',
      'fertilize': 'Every 2 weeks',
      'sunlight': 'Partial shade'
    },
  };

  @override
  void initState() {
    super.initState();
    plants = widget.allPlants.toSet().toList(); // Remove duplicates
    _loadAllPlants();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAllPlants();
  }

  Future<void> _loadAllPlants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sharedPrefsPlants = prefs.getStringList('allPlants');

    if (sharedPrefsPlants != null) {
      setState(() {
        plants = widget.allPlants + sharedPrefsPlants;
        plants = plants.toSet().toList(); // Remove duplicates
        plants = plants.reversed.toList();
      });
    } else {
      setState(() {
        plants = widget.allPlants.toSet().toList(); // Remove duplicates
        plants = plants.reversed.toList();
      });
    }
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteFlowersJson = prefs.getStringList('favoritedFlowers');
    if (favoriteFlowersJson != null) {
      setState(() {
        _favoritedFlowers = favoriteFlowersJson
            .map((flower) => json.decode(flower) as Map<String, dynamic>)
            .toList();
      });
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteFlowersJson =
        _favoritedFlowers.map((flower) => json.encode(flower)).toList();
    await prefs.setStringList('favoritedFlowers', favoriteFlowersJson);
  }

  void _toggleFavorite(String plantName) {
    final plant = {
      'name': plantName,
      'description': plantCareInfo[plantName]?['sunlight'] ?? '',
      'image':
          'lib/Assets/images/flowergeneral.png', // Add actual image path or URL
    };

    setState(() {
      if (_favoritedFlowers.any((flower) => flower['name'] == plantName)) {
        _favoritedFlowers.removeWhere((flower) => flower['name'] == plantName);
      } else {
        _favoritedFlowers.add(plant);
      }
      _saveFavorites();
    });
  }

  bool _isFavorited(String plantName) {
    return _favoritedFlowers.any((flower) => flower['name'] == plantName);
  }

  Future<void> refreshLoadAllPlants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sharedPrefsPlants = prefs.getStringList('allPlants');

    if (sharedPrefsPlants != null) {
      setState(() {
        plants = widget.allPlants + sharedPrefsPlants;
        plants = plants.toSet().toList(); // Remove duplicates
        plants = plants.reversed.toList();
      });
    } else {
      setState(() {
        plants = widget.allPlants.toSet().toList(); // Remove duplicates
        plants = plants.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Plants'),
        backgroundColor: theme.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshLoadAllPlants();
        },
        child: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final String item = plants.removeAt(oldIndex);
              plants.insert(newIndex, item);
            });
          },
          children: [
            for (int index = 0; index < plants.length; index++)
              Card(
                key: ValueKey('$index-${plants[index]}'),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ExpansionTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.drag_handle, color: theme.cardColor),
                      IconButton(
                        icon: Icon(
                          _isFavorited(plants[index])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isFavorited(plants[index])
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(plants[index]),
                      ),
                    ],
                  ),
                  title: Text(
                    plants[index],
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_drop_down, color: theme.cardColor),
                  children: <Widget>[
                    if (plantCareInfo[plants[index]] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.water, color: theme.cardColor),
                                const SizedBox(width: 10),
                                Text(
                                  'Watering:',
                                  style: TextStyle(
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    plantCareInfo[plants[index]]!['water']!,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.grass, color: theme.cardColor),
                                const SizedBox(width: 10),
                                Text(
                                  'Fertilizing:',
                                  style: TextStyle(
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    plantCareInfo[plants[index]]!['fertilize']!,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.wb_sunny, color: theme.cardColor),
                                const SizedBox(width: 10),
                                Text(
                                  'Sunlight:',
                                  style: TextStyle(
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    plantCareInfo[plants[index]]!['sunlight']!,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
