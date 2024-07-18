import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Weather {
  final String description;
  final double tempature;
  final double feelsLike;
  final double chanceOfRain;

  Weather({
    required this.description,
    required this.tempature,
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
      tempature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      chanceOfRain: calculateChanceOfRain(json),
    );
  }
}

class WeatherService {
  static String get apiKey {
    return dotenv.env['OPEN_WEATHER_MAP'] ?? '';
  }
  static const String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

   Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=imperial'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
