import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FlowerBoxDetailPage extends StatefulWidget {
  final FlowerBox flowerBox;

  FlowerBoxDetailPage({required this.flowerBox});

  @override
  FlowerBoxDetailPageState createState() => FlowerBoxDetailPageState();
}

class FlowerBoxDetailPageState extends State<FlowerBoxDetailPage> {
  List<String> commonVeggies = [
    'Type name',
    'Carrot',
    'Tomato',
    'Lettuce',
    'Pepper',
    'Cucumber',
    'Spinach',
    'Onion',
    'Garlic',
    'Potato',
    'Broccoli',
    'Cauliflower',
    'Eggplant',
    'Zucchini',
    'Radish',
    'Celery',
    'Peas',
    'Beans',
    'Sweet Corn',
    'Pumpkin',
    'Squash',
    'Beetroot',
    'Bell Pepper',
    'Brussels Sprouts',
    'Kale',
    'Leek',
    'Okra',
    'Parsnip',
    'Rhubarb',
    'Turnip',
    'Artichoke',
    'Asparagus'
  ];

  List<String> commonFruits = [
    'Type name',
    'Apple',
    'Banana',
    'Strawberry',
    'Grapes',
    'Orange',
    'Lemon',
    'Blueberry',
    'Watermelon',
    'Pineapple',
    'Mango',
    'Peach',
    'Plum',
    'Cherry',
    'Pear',
    'Raspberry',
    'Blackberry',
    'Fig',
    'Pomegranate',
    'Kiwi',
    'Avocado'
  ];

  List<String> commonFlowers = [
    'Type name',
    'Rose',
    'Tulip',
    'Daisy',
    'Sunflower',
    'Lily',
    'Daffodil',
    'Marigold',
    'Orchid',
    'Lavender',
    'Carnation',
    'Chrysanthemum',
    'Iris',
    'Peony',
    'Begonia',
    'Jasmine',
    'Poppy',
    'Petunia',
    'Hibiscus',
    'Dahlia',
    'Azalea',
    'Violet'
  ];

  String selectedType = 'Vegetable';
  String selectedVeggie = '';
  int selectedRow = -1;
  int selectedCol = -1;

  List<String> getCurrentList() {
    switch (selectedType) {
      case 'Fruit':
        return commonFruits;
      case 'Flower':
        return commonFlowers;
      default:
        return commonVeggies;
    }
  }

  void addPlant(int row, int col) {
    setState(() {
      selectedVeggie = ''; // Reset the selected veggie
      selectedRow = row;
      selectedCol = col;
    });
  }

  void selectVeggie(String veggie) {
    setState(() {
      widget.flowerBox.plants[selectedRow][selectedCol] = veggie;
      selectedRow = -1;
      selectedCol = -1;
    });
  }

  void saveFlowerBox() {
    bool isComplete = widget.flowerBox.plants
        .every((row) => row.every((plant) => plant != null));

    if (isComplete) {
      Navigator.of(context).pop(widget.flowerBox);
    } else {
      showIncompleteDialog();
    }
  }

  void showIncompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Provider.of<ThemeNotifier>(context).getTheme();
        return AlertDialog(
          title: Text('Incomplete Flower Box'),
          content: Text(
              'Your flower box is not complete. Are you sure you want to save?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(widget.flowerBox);
              },
              child: Text('Save Anyway'),
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();
    final currentList = getCurrentList();

    // Split the list into chunks of 4 for 4 rows
    List<List<String>> splitList = [];
    for (var i = 0; i < currentList.length; i += 4) {
      splitList.add(currentList.sublist(
          i, i + 4 > currentList.length ? currentList.length : i + 4));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Garden Details"),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(16.0),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.flowerBox.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            for (int row = 0;
                                row < widget.flowerBox.length;
                                row++)
                              Row(
                                children: [
                                  for (int col = 0;
                                      col < widget.flowerBox.width;
                                      col++)
                                    Container(
                                      width:
                                          100, // Set a fixed width for each cell
                                      height:
                                          60, // Set a fixed height for each cell
                                      margin: EdgeInsets.all(4.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: selectedRow == row &&
                                                selectedCol == col
                                            ? theme.primaryColorLight
                                            : theme.cardColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: InkWell(
                                        onTap: () => addPlant(row, col),
                                        child: Center(
                                          child: AutoSizeText(
                                            widget.flowerBox.plants[row][col] ??
                                                '+',
                                            style: TextStyle(
                                              color: theme
                                                  .textTheme.bodyMedium?.color,
                                            ),
                                            maxLines: 1,
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
                ),
              ),
            ),
          ),
          if (selectedRow != -1 && selectedCol != -1)
            Container(
              height: 250, // Adjusted height to fit within screen
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0), // Padding on left and right
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: <String>['Vegetable', 'Fruit', 'Flower']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: splitList.map((chunk) {
                          return Column(
                            children: chunk.map((plant) {
                              return Container(
                                width: 120, // Make the buttons wider
                                height: 40, // Set the original height
                                margin: EdgeInsets.all(
                                    4.0), // Space between buttons
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    backgroundColor:
                                        theme.cardColor, // Use theme.cardColor
                                  ),
                                  onPressed: () {
                                    if (plant == 'Type name') {
                                      showCustomPlantDialog(context);
                                    } else {
                                      selectVeggie(plant);
                                    }
                                  },
                                  child: AutoSizeText(
                                    plant,
                                    style: TextStyle(
                                      color: selectedVeggie == plant
                                          ? theme.textTheme.bodyMedium?.color
                                          : theme.textTheme.bodyMedium?.color,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: saveFlowerBox,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Shows list of commonly used plants and handles save and cancel actions
  void showCustomPlantDialog(BuildContext context) {
    final _plantController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (context) {
        final theme = Provider.of<ThemeNotifier>(context).getTheme();

        return AlertDialog(
          title: Text('Type Plant Name'),
          content: TextField(
            controller: _plantController,
            decoration: InputDecoration(labelText: 'Plant Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_plantController.text);
                selectVeggie(_plantController.text);
              },
              child: Text('Save'),
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
          ],
        );
      },
    );
  }
}
