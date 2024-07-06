import 'package:flutter/material.dart';
import '/Global_Elements/ui_tiles.dart';
import '/Data/weather_api.dart';

class WeatherAlertsWidget extends StatefulWidget {
  const WeatherAlertsWidget({super.key});

  @override
  _WeatherAlertsWidgetState createState() => _WeatherAlertsWidgetState();
}

class _WeatherAlertsWidgetState extends State<WeatherAlertsWidget> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = WeatherService().fetchWeather('Fort Worth');
  }
  
  @override
  Widget build(BuildContext context) {
    return UiTile(
      name: 'Weather Alerts',
      imagePath: 'lib/Assets/images/weather.png',
      textAlignment: TextAlignOption.center,
      description: '',
      child: FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Weather weather = snapshot.data!;
            return Column(
              children: [
                Text('Description: ${weather.description}'),
                Text('Temperature: ${weather.tempature}°F'),
                Text('Feels Like: ${weather.feelsLike}°F'),
                Text('Humidity: ${weather.humidity}%'),
                Text('Wind Speed: ${weather.windSpeed} MPH'),
              ],
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}

