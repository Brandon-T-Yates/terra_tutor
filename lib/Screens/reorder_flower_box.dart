// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Screens/flower_box.dart';

class ReorderFlowerBoxesPage extends StatefulWidget {
  final List<FlowerBox> flowerBoxes;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderFlowerBoxesPage({
    super.key,
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
        title: const Text('Reorder Flower Boxes'),
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
