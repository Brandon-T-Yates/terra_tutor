import 'package:flutter/material.dart';
import '/Global_Elements/ui_tiles.dart';

class WaterReminderWidget extends StatelessWidget {
  const WaterReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UiTile(
      name: 'Water Reminder',
      image: 'lib/Assets/images/watering.png',
      textAlignment: TextAlignOption.center,
      description: '',
    );
  }
}
