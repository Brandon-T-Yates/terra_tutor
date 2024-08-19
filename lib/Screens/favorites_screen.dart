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

  @override
  void initState() {
    super.initState();
    _loadFavorites();
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

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteFlowersJson =
        _favoritedFlowers.map((flower) => json.encode(flower)).toList();
    await prefs.setStringList('favoritedFlowers', favoriteFlowersJson);
  }

  // Add new favorite to the top
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
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeFromFavorites(index),
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
