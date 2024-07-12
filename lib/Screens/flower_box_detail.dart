import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box.dart';
import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box_detail.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Screens/flower_box_detail.dart';
import 'package:terra_tutor/Screens/add_flower_box_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
    'Beetroot'
  ];
  String selectedVeggie = '';
  int selectedRow = -1;
  int selectedCol = -1;

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
        return AlertDialog(
          title: Text('Incomplete Flower Box'),
          content: Text(
              'Your flower box is not complete. Are you sure you want to save?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(widget.flowerBox);
              },
              child: Text('Save Anyway'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Garden Details"),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
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
                                      color: selectedRow == row &&
                                              selectedCol == col
                                          ? theme.primaryColorLight
                                          : theme.cardColor,
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
              padding: const EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: Wrap(
                spacing: 8.0,
                children: commonVeggies.map((veggie) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedVeggie == veggie
                          ? theme.primaryColor
                          : theme.cardColor,
                    ),
                    onPressed: () {
                      if (veggie == 'Type name') {
                        showCustomPlantDialog(context);
                      } else {
                        selectVeggie(veggie);
                      }
                    },
                    child: Text(
                      veggie,
                      style: TextStyle(
                        color: selectedVeggie == veggie
                            ? theme.textTheme.bodyMedium?.color
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  );
                }).toList(),
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
