// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:terra_tutor/Screens/flower_box.dart';

class AddFlowerBoxDialog extends StatefulWidget {
  final Function(FlowerBox) onAddFlowerBox;
  final FlowerBox? initialFlowerBox;

  const AddFlowerBoxDialog(
      {super.key, required this.onAddFlowerBox, this.initialFlowerBox});

  @override
  _AddFlowerBoxDialogState createState() => _AddFlowerBoxDialogState();
}

class _AddFlowerBoxDialogState extends State<AddFlowerBoxDialog> {
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
    return AlertDialog(
      title: Text(widget.initialFlowerBox == null
          ? 'Add Flower Box'
          : 'Edit Flower Box'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Flower Box Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              value: _width,
              decoration: const InputDecoration(labelText: 'Width'),
              items: List.generate(6, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                      value: value, child: Text('$value')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _width = value!;
                });
              },
            ),
            DropdownButtonFormField<int>(
              value: _length,
              decoration: const InputDecoration(labelText: 'Length'),
              items: List.generate(6, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                      value: value, child: Text('$value')))
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
