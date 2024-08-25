// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_tutor/Global_Elements/ui_tile2.0.dart';
import '/Data/weather_api.dart';

class WeatherAlertsWidget extends StatefulWidget {
  const WeatherAlertsWidget({super.key});

  @override
  WeatherAlertsWidgetState createState() => WeatherAlertsWidgetState();
}

class WeatherAlertsWidgetState extends State<WeatherAlertsWidget> {
  Future<Weather>? futureWeather;
  User? user;
  String? cityName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndLoadData();
    });
  }

  Future<void> _checkAuthAndLoadData() async {
    user = FirebaseAuth.instance.currentUser;
    user ??= await _signInAnonymously();
    _loadCityAndFetchWeather();
  }

  Future<User?> _signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  Future<void> _loadCityAndFetchWeather() async {
    cityName = await _getCityFromFirebase();
    if (cityName != null && cityName!.isNotEmpty) {
      setState(() {
        futureWeather = WeatherService().fetchWeather(cityName!);
      });
    } else {
      _promptCityAndFetchWeather();
    }
  }

  Future<void> _promptCityAndFetchWeather() async {
    cityName = await CityInputDialog.show(context);
    if (cityName != null && cityName!.isNotEmpty) {
      await _saveCityToFirebase(cityName!);
      setState(() {
        futureWeather = WeatherService().fetchWeather(cityName!);
      });
    }
  }

  Future<void> _saveCityToFirebase(String cityName) async {
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      await userDoc.set({'city': cityName}, SetOptions(merge: true));
    }
  }

  Future<String?> _getCityFromFirebase() async {
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final docSnapshot = await userDoc.get();
      return docSnapshot.data()?['city'] as String?;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
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
                if (cityName != null)
                  Text('City: $cityName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Description: ${weather.description}'),
                Text('Temperature: ${weather.temperature}°F'),
                Text('Feels Like: ${weather.feelsLike}°F'),
                Text('Chance of Rain: ${weather.chanceOfRain}%'),
              ],
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}