import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favoritedFlowers = [];
  List<String> _allPlants = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadAllPlants();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteFlowersJson = prefs.getStringList('favoritedFlowers');
    if (favoriteFlowersJson != null) {
      setState(() {
        _favoritedFlowers = favoriteFlowersJson
            .map((flower) => json.decode(flower) as Map<String, dynamic>)
            .toList()
            .reversed
            .toList(); // Reverse the list to show newest first
      });
    }
  }

  Future<void> _loadAllPlants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? allPlantsJson = prefs.getStringList('allPlants');
    if (allPlantsJson != null) {
      setState(() {
        _allPlants = allPlantsJson;
      });
    }
  }

  Future<void> _saveAllPlants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('allPlants', _allPlants);
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteFlowersJson =
        _favoritedFlowers.map((flower) => json.encode(flower)).toList();
    await prefs.setStringList('favoritedFlowers', favoriteFlowersJson);
  }

  void _addToFavorites(Map<String, dynamic> flower) {
    setState(() {
      _favoritedFlowers.insert(0, flower);
    });
    _saveFavorites();
  }

  void _removeFromFavorites(int index) {
    setState(() {
      _favoritedFlowers.removeAt(index);
    });
    _saveFavorites();
  }

  void _addToAllPlants(Map<String, dynamic> flower) {
    setState(() {
      if (!_allPlants.contains(flower['name'])) {
        _allPlants.add(flower['name']);
        _saveAllPlants();
      }
    });
  }

  bool _isInAllPlants(String plantName) {
    return _allPlants.contains(plantName);
  }

  void _removeFromAllPlants(String plantName) {
    setState(() {
      _allPlants.remove(plantName);
      _saveAllPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Flowers'),
      ),
      body: ListView.builder(
        itemCount: _favoritedFlowers.length,
        itemBuilder: (context, index) {
          final flower = _favoritedFlowers[index];
          final isFavorited =
              _favoritedFlowers.any((fav) => fav['name'] == flower['name']);
          final isInAllPlants = _isInAllPlants(flower['name']);

          return Card(
            margin: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: flower['image'].startsWith('http')
                            ? NetworkImage(flower['image'])
                            : AssetImage(flower['image']) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flower['name'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          flower['description'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (isFavorited) {
                        _removeFromFavorites(index);
                      } else {
                        _addToFavorites(flower);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.local_florist,
                      color: isInAllPlants ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      if (isInAllPlants) {
                        _removeFromAllPlants(flower['name']);
                      } else {
                        _addToAllPlants(flower);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
