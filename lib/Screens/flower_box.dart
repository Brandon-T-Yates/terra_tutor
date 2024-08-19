import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Screens/add_flower_box_dialog.dart';
import 'package:terra_tutor/Screens/flower_box_detail.dart';
import 'package:terra_tutor/Screens/all_plants_page.dart';
import 'package:terra_tutor/Screens/reorder_flower_box.dart';

class FlowerBox {
  String name;
  int length;
  int width;
  List<List<String?>> plants;

  FlowerBox({
    required this.name,
    required this.length,
    required this.width,
  }) : plants = List.generate(length, (index) => List.filled(width, null));

  factory FlowerBox.fromJson(Map<String, dynamic> json) {
    FlowerBox flowerBox = FlowerBox(
      name: json['name'],
      length: json['length'],
      width: json['width'],
    );
    flowerBox.plants = List<List<String?>>.from(
      json['plants'].map((x) => List<String?>.from(x)),
    );
    return flowerBox;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'length': length,
        'width': width,
        'plants': plants,
      };
}

class FlowerBoxHomePage extends StatefulWidget {
  @override
  FlowerBoxHomePageState createState() => FlowerBoxHomePageState();
}

class FlowerBoxHomePageState extends State<FlowerBoxHomePage> {
  List<FlowerBox> flowerBoxes = [];
  int _currentPage = 0;
  bool _isImageView = false;

  @override
  void initState() {
    super.initState();
    loadFlowerBoxes();
  }

  Future<void> loadFlowerBoxes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('flower_boxes');
    if (savedData != null) {
      setState(() {
        flowerBoxes = List<FlowerBox>.from(
            json.decode(savedData).map((x) => FlowerBox.fromJson(x)));
      });
    }
  }

  Future<void> saveFlowerBoxes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('flower_boxes', json.encode(flowerBoxes));
  }

  void addFlowerBox(FlowerBox flowerBox) {
    setState(() {
      flowerBoxes.add(flowerBox);
    });
    saveFlowerBoxes();
  }

  void editFlowerBox(int index, FlowerBox flowerBox) {
    setState(() {
      flowerBoxes[index] = flowerBox;
    });
    saveFlowerBoxes();
  }

  void deleteFlowerBox(int index) {
    setState(() {
      flowerBoxes.removeAt(index);
    });
    saveFlowerBoxes();
  }

  void reorderFlowerBox(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final FlowerBox item = flowerBoxes.removeAt(oldIndex);
      flowerBoxes.insert(newIndex, item);
    });
    saveFlowerBoxes();
  }

  List<FlowerBox> getCurrentPageItems() {
    final startIndex = _currentPage * 4;
    final endIndex = (_currentPage + 1) * 4;
    return flowerBoxes.sublist(startIndex,
        endIndex > flowerBoxes.length ? flowerBoxes.length : endIndex);
  }

  void nextPage() {
    setState(() {
      if ((_currentPage + 1) * 4 < flowerBoxes.length) {
        _currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  List<String> getAllPlants() {
    List<String> allPlants = [];
    for (var flowerBox in flowerBoxes) {
      for (var row in flowerBox.plants) {
        for (var plant in row) {
          if (plant != null && plant.isNotEmpty) {
            allPlants.add(plant);
          }
        }
      }
    }
    return allPlants;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.swap_horiz),
                        onPressed: () {
                          setState(() {
                            _isImageView = !_isImageView;
                          });
                        },
                        color: theme.primaryColor,
                      ),
                      Text(
                        'Gardens',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.local_florist),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllPlantsPage(allPlants: getAllPlants()),
                            ),
                          );
                        },
                        color: theme.primaryColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 160.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: previousPage,
                                color: Colors.black,
                              ),
                            IconButton(
                              icon: Icon(Icons.list),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReorderFlowerBoxesPage(
                                    flowerBoxes: flowerBoxes,
                                    onReorder: reorderFlowerBox,
                                  ),
                                ),
                              ),
                              color: Colors.black,
                            ),
                            if ((_currentPage + 1) * 4 < flowerBoxes.length)
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: nextPage,
                                color: Colors.black,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: getCurrentPageItems().length,
                itemBuilder: (context, index) {
                  final flowerBox = getCurrentPageItems()[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 8.0,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.drag_handle, color: Colors.white),
                          title: Column(
                            children: [
                              Text(
                                flowerBox.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                              Text(
                                'Size: ${flowerBox.width} x ${flowerBox.length}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                navigateToEditFlowerBoxDetail(
                                    context, index + (_currentPage * 4));
                              } else if (value == 'Delete') {
                                deleteFlowerBox(index + (_currentPage * 4));
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Edit', 'Delete'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              for (int row = 0; row < flowerBox.length; row++)
                                Row(
                                  children: [
                                    for (int col = 0;
                                        col < flowerBox.width;
                                        col++)
                                      Container(
                                        width: 100,
                                        height: 60,
                                        margin: EdgeInsets.all(4.0),
                                        padding: EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Center(
                                          child: _isImageView
                                              ? _getImageForPlant(
                                                  flowerBox.plants[row][col])
                                              : AutoSizeText(
                                                  flowerBox.plants[row][col] ??
                                                      '',
                                                  style: TextStyle(
                                                    color: theme.textTheme
                                                        .bodyMedium?.color,
                                                  ),
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
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            heroTag: 'addFlowerBoxFAB',
            onPressed: () => showAddFlowerBoxDialog(context),
            tooltip: 'Add Flower Box',
            backgroundColor: theme.primaryColor,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void showAddFlowerBoxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddFlowerBoxDialog(
          onAddFlowerBox: (newFlowerBox) {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FlowerBoxDetailPage(flowerBox: newFlowerBox),
              ),
            ).then((result) {
              if (result != null && result is FlowerBox) {
                addFlowerBox(result);
              }
            });
          },
        );
      },
    );
  }

  void navigateToEditFlowerBoxDetail(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FlowerBoxDetailPage(flowerBox: flowerBoxes[index]),
      ),
    ).then((result) {
      if (result != null && result is FlowerBox) {
        editFlowerBox(index, result);
      }
    });
  }

  void navigateToFlowerBoxDetail(FlowerBox flowerBox) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowerBoxDetailPage(flowerBox: flowerBox),
      ),
    ).then((result) {
      if (result != null && result is FlowerBox) {
        addFlowerBox(result);
      }
    });
  }

  Widget _getImageForPlant(String? plant) {
    if (plant == null) {
      return Container();
    }

    final plantImageMap = {
      'Artichoke': 'lib/Assets/images/artichoke.png',
      'Asparagus': 'lib/Assets/images/asperagus.png',
      'Beans': 'lib/Assets/images/beans.png',
      'Beetroot': 'lib/Assets/images/beet.png',
      'Bell Pepper': 'lib/Assets/images/bell_pepper.png',
      'Blueberry': 'lib/Assets/images/blueberry.png',
      'Strawberry': 'lib/Assets/images/strawberry.png',
      'Broccoli': 'lib/Assets/images/broccoli.png',
      'Brussels Sprouts': 'lib/Assets/images/brussel_sprouts.png',
      'Carrot': 'lib/Assets/images/Carrot(1).png',
      'Cauliflower': 'lib/Assets/images/cauliflower.png',
      'Celery': 'lib/Assets/images/celery.png',
      'Sweet Corn': 'lib/Assets/images/corn.png',
      'Cucumber': 'lib/Assets/images/cucumber.png',
      'Eggplant': 'lib/Assets/images/eggplant.png',
      'Watermelon': 'lib/Assets/images/watermelon.png',
      'Garlic': 'lib/Assets/images/garlic.png',
      'Kale': 'lib/Assets/images/kale.png',
      'Lettuce': 'lib/Assets/images/lettuce.png',
      'Okra': 'lib/Assets/images/okra.png',
      'Onion': 'lib/Assets/images/onion.png',
      'Peas': 'lib/Assets/images/peas.png',
      'Pepper': 'lib/Assets/images/pepper.png',
      'Pumpkin': 'lib/Assets/images/pumpkin.png',
      'Potato': 'lib/Assets/images/potato.png',
      'Spinach': 'lib/Assets/images/spinach.png',
      'Squash': 'lib/Assets/images/squash.png',
      'Radish': 'lib/Assets/images/radish(1).png',
      'Tomato': 'lib/Assets/images/tomato.png',
      'Zucchini': 'lib/Assets/images/zucchini.png',

      'Violet': 'lib/Assets/images/violet.png',
      'Hibiscus': 'lib/Assets/images/hibiscus.png',
      'Lavender': 'lib/Assets/images/lavender.png',
      'Orchid': 'lib/Assets/images/orchid.png',
      'Lotus': 'lib/Assets/images/lotus.png',
      'Sunflower': 'lib/Assets/images/sunflower.png',
      'Tulip': 'lib/Assets/images/tulip.png',
      'Rose': 'lib/Assets/images/rose.png',

      'Kiwi': 'lib/Assets/images/kiwi.png',
      'Pomegranate': 'lib/Assets/images/pomegranate.png',
      'Fig': 'lib/Assets/images/fig.png',
      'Blackberry': 'lib/Assets/images/blackberry(2).png',
      'Raspberry': 'lib/Assets/images/raspberry.png',
      'Pear': 'lib/Assets/images/pear.png',
      'Cherry': 'lib/Assets/images/cherry.png',
      'Plum': 'lib/Assets/images/plum.png',
      'Peach': 'lib/Assets/images/peach.png',
      'Mango': 'lib/Assets/images/mango.png',
      'Pineapple': 'lib/Assets/images/pineapple.png',
      'Lemon': 'lib/Assets/images/lemon.png',
      'Grape': 'lib/Assets/images/grapes.png',
      'Banana': 'lib/Assets/images/banana.png',
      'Apple': 'lib/Assets/images/apple.png',
      'Orange': 'lib/Assets/images/orange.png',
      'Avocado': 'lib/Assets/images/avocado.png',
      //Without images
      'Leek': 'lib/Assets/images/veggigeneral.png',
      'Parsnip': 'lib/Assets/images/veggigeneral.png',
      'Rhubarb': 'lib/Assets/images/veggigeneral.png',
      'Turnip': 'lib/Assets/images/veggigeneral.png',

      'Daisy': 'lib/Assets/images/flowergeneral.png',
      'Lily': 'lib/Assets/images/flowergeneral.png',
      'Marigold': 'lib/Assets/images/flowergeneral.png',
      'Carnation': 'lib/Assets/images/flowergeneral.png',
      'Chrysanthemum': 'lib/Assets/images/flowergeneral.png',
      'Iris': 'lib/Assets/images/flowergeneral.png',
      'Peony': 'lib/Assets/images/flowergeneral.png',
      'Begonia': 'lib/Assets/images/flowergeneral.png',
      'Jasmine': 'lib/Assets/images/flowergeneral.png',
      'Poppy': 'lib/Assets/images/flowergeneral.png',
      'Petunia': 'lib/Assets/images/flowergeneral.png',
      'Dahlia': 'lib/Assets/images/flowergeneral.png',
      'Azalea': 'lib/Assets/images/flowergeneral.png',
    };

    if (plantImageMap.containsKey(plant)) {
      return Image.asset(
        plantImageMap[plant]!,
        fit: BoxFit.contain,
      );
    } else {
      return AutoSizeText(
        plant,
        style: TextStyle(
          color: Provider.of<ThemeNotifier>(context)
              .getTheme()
              .textTheme
              .bodyMedium
              ?.color,
        ),
      );
    }
  }
}
