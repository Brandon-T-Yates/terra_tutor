import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Screens/add_flower_box_dialog.dart';
import 'package:terra_tutor/Screens/flower_box_detail.dart';

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

  //Maping json list of current flowers
  factory FlowerBox.fromJson(Map<String, dynamic> json) {
    return FlowerBox(
      name: json['name'],
      length: json['length'],
      width: json['width'],
    )..plants = List<List<String?>>.from(
        json['plants'].map((x) => List<String?>.from(x)));
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

  @override
  void initState() {
    super.initState();
    loadFlowerBoxes();
  }

  //Load the current flower boxes from shared prefs
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

  // Save current flower to shared prefs
  Future<void> saveFlowerBoxes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('flower_boxes', json.encode(flowerBoxes));
  }

  //Addds a flowerbox to the home page/ main garden
  void addFlowerBox(FlowerBox flowerBox) {
    setState(() {
      flowerBoxes.add(flowerBox);
    });
    saveFlowerBoxes();
  }

  //Edit flower boxes in case of mistake
  void editFlowerBox(int index, FlowerBox flowerBox) {
    setState(() {
      flowerBoxes[index] = flowerBox;
    });
    saveFlowerBoxes();
  }

  //Remove flower boxes
  void deleteFlowerBox(int index) {
    setState(() {
      flowerBoxes.removeAt(index);
    });
    saveFlowerBoxes();
  }

  //Change order of current flower boxes
  void reorderFlowerBox(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final FlowerBox item = flowerBoxes.removeAt(oldIndex);
      flowerBoxes.insert(newIndex, item);
      saveFlowerBoxes();
    });
  }

  //Seperate into lists so that four boxes can be displayed on each page.
  List<FlowerBox> getCurrentPageItems() {
    final startIndex = _currentPage * 4;
    final endIndex = (_currentPage + 1) * 4;
    return flowerBoxes.sublist(startIndex,
        endIndex > flowerBoxes.length ? flowerBoxes.length : endIndex);
  }

  //Flips to the next page of flower boxes
  void nextPage() {
    setState(() {
      if ((_currentPage + 1) * 4 < flowerBoxes.length) {
        _currentPage++;
      }
    });
  }

  //Returns to the previous page of flower boxes
  void previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
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
                  Text(
                    'Gardens',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0), // Adding horizontal padding
                    width:
                        160.0, // Adjusting width to accommodate the icons and padding
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
                          leading: Icon(Icons.drag_handle,
                              color: theme.primaryColor),
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
                                'Size: ${flowerBox.length} x ${flowerBox.width}',
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
                          child: Row(
                            children: [
                              for (int row = 0; row < flowerBox.length; row++)
                                Column(
                                  children: [
                                    for (int col = 0;
                                        col < flowerBox.width;
                                        col++)
                                      Container(
                                        width:
                                            100, // Set a fixed width for each cell
                                        height:
                                            60, // Set a fixed height for each cell
                                        margin: EdgeInsets.all(4.0),
                                        padding: EdgeInsets.all(16.0),
                                        color: theme.cardColor,
                                        child: Center(
                                          child: AutoSizeText(
                                            flowerBox.plants[row][col] ?? '',
                                            style: TextStyle(
                                              color: theme
                                                  .textTheme.bodyMedium?.color,
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

  //Shows the dialog to add a new flower box
  void showAddFlowerBoxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddFlowerBoxDialog(onAddFlowerBox: navigateToFlowerBoxDetail);
      },
    );
  }

  //Go back to the edit page with current flower box details
  void navigateToEditFlowerBoxDetail(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FlowerBoxDetailPage(flowerBox: flowerBoxes[index]),
      ),
    ).then((result) {
      if (result != null) {
        editFlowerBox(index, result);
      }
    });
  }

  // Navigates to the edit page of the flower box
  void navigateToFlowerBoxDetail(FlowerBox flowerBox) {
    Navigator.of(context).pop(); // Close the dialog first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowerBoxDetailPage(flowerBox: flowerBox),
      ),
    ).then((result) {
      if (result != null) {
        addFlowerBox(result);
      }
    });
  }
}

//REORDER class that changes the position of each flower box
class ReorderFlowerBoxesPage extends StatefulWidget {
  final List<FlowerBox> flowerBoxes;
  final void Function(int oldIndex, int newIndex) onReorder;

  ReorderFlowerBoxesPage({
    required this.flowerBoxes,
    required this.onReorder,
  });

  @override
  _ReorderFlowerBoxesPageState createState() => _ReorderFlowerBoxesPageState();
}

class _ReorderFlowerBoxesPageState extends State<ReorderFlowerBoxesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reorder Flower Boxes'),
        backgroundColor: theme.primaryColor,
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            widget.onReorder(oldIndex, newIndex);
          });
        },
        children: [
          for (int index = 0; index < widget.flowerBoxes.length; index++)
            ListTile(
              key: ValueKey(widget.flowerBoxes[index]),
              leading: Icon(Icons.drag_handle, color: theme.primaryColor),
              title: Text(
                widget.flowerBoxes[index].name,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              subtitle: Text(
                'Size: ${widget.flowerBoxes[index].length} x ${widget.flowerBoxes[index].width}',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
