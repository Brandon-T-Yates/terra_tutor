import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart'; // Adjust the import to your file structure

class Weather {
  final String description;
  final double temperature;
  final double feelsLike;
  final double chanceOfRain;

  Weather({
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.chanceOfRain,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    double calculateChanceOfRain(Map<String, dynamic> json) {
      if (json.containsKey('rain') && json['rain'].containsKey('1hr')) {
        return json['rain']['1hr'].toDouble();
      } else if (json.containsKey('rain') && json['rain'].containsKey('3hr')) {
        return json['rain']['3hr'].toDouble() / 3.0;
      } else {
        return 0.0;
      }
    }

    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      chanceOfRain: calculateChanceOfRain(json),
    );
  }
}

class WeatherService {
  static String get apiKey {
    return dotenv.env['OPEN_WEATHER_MAP'] ?? '';
  }

  static const String baseUrl =
      'http://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=imperial'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class CityInputDialog {
  static Future<String?> show(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cityName = prefs.getString('city_name');

    // If city name is already stored, return it directly without showing the dialog
    if (cityName != null) {
      return cityName;
    }

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController textController = TextEditingController();
        final theme = Provider.of<ThemeNotifier>(context).getTheme();

        return AlertDialog(
          backgroundColor: theme.cardColor, // Use the themed card color
          title: Center(
            child: Text(
              'Enter City Name',
              style: theme.textTheme.bodyLarge, // Use themed text color
            ),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "City Name",
              hintStyle: theme.textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey), // Hint text themed
            ),
            style: theme.textTheme.bodyLarge, // Input text color
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                foregroundColor:
                    theme.textTheme.bodyLarge?.color ?? Colors.black,
                side: BorderSide(
                    color: theme.textTheme.bodyLarge?.color ?? Colors.black),
                fixedSize: const Size(100, 25),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('Cancel', style: theme.textTheme.bodyLarge),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                foregroundColor:
                    theme.textTheme.bodyLarge?.color ?? Colors.black,
                side: BorderSide(
                    color: theme.textTheme.bodyLarge?.color ?? Colors.black),
                fixedSize: const Size(100, 25),
              ),
              onPressed: () {
                cityName = textController.text;
                prefs.setString('city_name',
                    cityName!); // Save the city name to SharedPreferences
                Navigator.of(context).pop(cityName);
              },
              child: Text('OK', style: theme.textTheme.bodyLarge),
            ),
          ],
        );
      },
    );
  }
}
