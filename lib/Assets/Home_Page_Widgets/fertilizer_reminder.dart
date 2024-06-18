import 'package:flutter/material.dart';
import '/Global_Elements/ui_tiles.dart';

class FertilizerReminderWidget extends StatelessWidget {
  const FertilizerReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UiTile(
      name: 'Fertilizer Reminder',
      image: 'lib/Assets/images/fertilizer.png',
      textAlignment: TextAlignOption.center,
      description: '',
    );
  }
}
