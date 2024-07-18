import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/ui_tile2.0.dart';
import '/Data/weather_api.dart';
//import 'package:permission_handler/permission_handler.dart';

class WeatherAlertsWidget extends StatefulWidget {
  const WeatherAlertsWidget({super.key});

  @override
  WeatherAlertsWidgetState createState() => WeatherAlertsWidgetState();
}

class WeatherAlertsWidgetState extends State<WeatherAlertsWidget> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = WeatherService().fetchWeather('Fort Worth');
  }
  
  @override
  Widget build(BuildContext context) {
    return UiTile2(
      name: 'Weather Alerts',
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

