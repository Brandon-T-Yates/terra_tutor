import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   _getLocationAndFetchWeather();
  // }

  // Future<void> _getLocationAndFetchWeather() async {
  //   // Check if location services are enabled.
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   // Check location permission status.
  //   PermissionStatus permission = await Permission.location.status;
  //   if (permission.isDenied) {
  //     permission = await Permission.location.request();
  //     if (permission.isDenied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission.isPermanentlyDenied) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // Fetch the current position of the device.
  //   final position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     futureWeather = WeatherService().fetchWeather(position.latitude, position.longitude);
  //   });
  // }

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

