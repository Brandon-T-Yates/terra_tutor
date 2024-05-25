import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Data/plant_database.dart';

class TrefleApi {
  static String get apiKey {
    return _getApiKey(); // Retrieve API key from .env file
  }

  static String _getApiKey() {
    final Map<String, String> env = Platform.environment;
    return env['TREFLE_API_KEY'] ?? '';
  }
  static const String baseUrl = 'https://trefle.io/api/v1';

  Future<List<Plant>> searchPlants(String query) async {
    final url = Uri.parse('$baseUrl/plants/search?q=$query&token=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((plantData) => Plant.fromJson(plantData)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }
}
