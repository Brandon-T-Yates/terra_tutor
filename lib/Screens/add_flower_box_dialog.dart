import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:provider/provider.dart';

class AddFlowerBoxDialog extends StatefulWidget {
  final Function(FlowerBox) onAddFlowerBox;
  final FlowerBox? initialFlowerBox;

  const AddFlowerBoxDialog(
      {super.key, required this.onAddFlowerBox, this.initialFlowerBox});

  @override
  AddFlowerBoxDialogState createState() => AddFlowerBoxDialogState();
}

class AddFlowerBoxDialogState extends State<AddFlowerBoxDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late int _length;
  late int _width;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialFlowerBox?.name ?? '');
    _length = widget.initialFlowerBox?.length ?? 1;
    _width = widget.initialFlowerBox?.width ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return AlertDialog(
      backgroundColor: theme.primaryColor,
      title: Center(
        child: Text(
          widget.initialFlowerBox == null
              ? 'Add Flower Box'
              : 'Edit Flower Box',
          style: theme.textTheme.headlineLarge,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Flower Box Name',
                labelStyle: theme.textTheme.headlineLarge,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              value: _width,
              decoration: InputDecoration(
                labelText: 'Width',
                labelStyle: theme.textTheme.headlineLarge,
              ),
              items: List.generate(6, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value', style: theme.textTheme.bodyLarge),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _width = value!;
                });
              },
            ),
            DropdownButtonFormField<int>(
              value: _length,
              decoration: InputDecoration(
                labelText: 'Length',
                labelStyle: theme.textTheme.headlineLarge,
              ),
              items: List.generate(6, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value', style: theme.textTheme.bodyLarge),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _length = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.cardColor,
            foregroundColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
            side: BorderSide(
                color: theme.textTheme.bodyLarge?.color ?? Colors.black),
            fixedSize: const Size(100, 25),
          ),
          child: Text('Cancel', style: theme.textTheme.bodyLarge),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newFlowerBox = FlowerBox(
                name: _nameController.text,
                length: _length,
                width: _width,
              );
              widget.onAddFlowerBox(newFlowerBox);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.cardColor,
            foregroundColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
            side: BorderSide(
                color: theme.textTheme.bodyLarge?.color ?? Colors.black),
            fixedSize: const Size(100, 25),
          ),
          child: Text('Save', style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}
