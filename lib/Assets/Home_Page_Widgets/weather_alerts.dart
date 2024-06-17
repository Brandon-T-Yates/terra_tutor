import 'package:flutter/material.dart';
import '/Global_Elements/ui_tiles.dart';

class WeatherAlertsWidget extends StatelessWidget {
  const WeatherAlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UiTile(
      name: 'Weather Alerts',
      image: 'lib/Assets/images/weather.png',
      textAlignment: TextAlignOption.center,
      description: '',
    );
  }
}
