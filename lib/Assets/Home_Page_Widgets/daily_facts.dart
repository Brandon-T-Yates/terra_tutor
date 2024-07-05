import 'package:flutter/material.dart';
import '/Global_Elements/ui_tiles.dart';

class DailyFactsWidget extends StatelessWidget {
  const DailyFactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UiTile(
      name: 'Daily Facts',
      imagePath: 'lib/Assets/images/facts.png',
      description: '',
      textAlignment: TextAlignOption.center,
    );
  }
}
