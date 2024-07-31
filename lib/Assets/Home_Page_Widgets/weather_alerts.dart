import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/ui_tile2.0.dart';
import '/Data/weather_api.dart';

class WeatherAlertsWidget extends StatefulWidget {
  const WeatherAlertsWidget({super.key});

  @override
  WeatherAlertsWidgetState createState() => WeatherAlertsWidgetState();
}

class WeatherAlertsWidgetState extends State<WeatherAlertsWidget> {
  Future<Weather>? futureWeather;

  @override
  void initState() {
    super.initState();
    _promptCityAndFetchWeather();
  }

  Future<void> _promptCityAndFetchWeather() async {
    String? cityName = await CityInputDialog.show(context);
    if (cityName != null) {
      setState(() {
        futureWeather = WeatherService().fetchWeather(cityName);
      });
    }
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
                Text('Chance of Rain: ${weather.chanceOfRain}%'),
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
