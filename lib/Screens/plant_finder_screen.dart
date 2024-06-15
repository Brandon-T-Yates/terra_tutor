import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retry/retry.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:http/io_client.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/top_navigation.dart';
import '/Global_Elements/bottom_navigation.dart';

class PlantFinderScreen extends StatefulWidget {
  const PlantFinderScreen({super.key});

  @override
  _PlantFinderPageState createState() => _PlantFinderPageState();
}

class _PlantFinderPageState extends State<PlantFinderScreen> {
  int _selectedIndex = 2; // Index for BottomNavigationBar
  //Plant list
  List plants = [];
  int currentPlantIndex = 0;
  // State default variables for plant name, description, and image
  String plantName = 'Rose';
  String plantDescription =
      'Roses are one of the oldest flowers on Earth. Fossil evidence suggests that roses are at least 35 million years old!';
  String plantImage = 'lib/Assets/images/rose_placeholder.jpg';

  @override
  void initState() {
    super.initState();
    fetchRandomPlant();
  }

  void onItemTapped(int index) {
    // Handle navigation based on selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  void onBackButtonPressed() {
    if (currentPlantIndex > 0) {
      currentPlantIndex--;
      updatePlantFromIndex();
    }
  }

  void onShuffleButtonPressed() {
    fetchRandomPlant();
  }

  void onForwardButtonPressed() {
    if (currentPlantIndex < plants.length - 1) {
      currentPlantIndex++;
      updatePlantFromIndex();
    }
  }

  void onCameraButtonPressed() {
    // Placeholder for camera button functionality
  }

// Create an HttpClient that ignores bad certificates
// This is for dev version only. And needs to be reverted once trefle.io updates their certificates
  HttpClient httpClient(SecurityContext? context) {
    final HttpClient client = HttpClient(context: context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  Future<void> fetchRandomPlant() async {
    final String? apiKey = dotenv.env['TREFLE_API_KEY'];
    if (apiKey == null) {
      print('Error: API key is missing');
      return;
    }

    // Use a random page number to get random results from the API
    final randomPage = Random().nextInt(100) + 1;
    final String apiUrl =
        'https://trefle.io/api/v1/plants?token=$apiKey&page=$randomPage';

    final ioClient = IOClient(httpClient(null));

    try {
      print('Fetching data from API...');
      final response = await retry(
        () => ioClient
            .get(Uri.parse(apiUrl))
            //Increased timeout duration
            .timeout(const Duration(seconds: 20)),
        retryIf: (e) => e is http.ClientException || e is TimeoutException,
        maxAttempts: 3,
      );

      if (response.statusCode == 200) {
        print('API call successful');
        final data = json.decode(response.body);
        setState(() {
          plants = data['data'] as List;
          plants.shuffle();
          currentPlantIndex = 0;
          updatePlantFromIndex();
        });
      } else {
        print('Failed to load plant data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plant data: $e');
    } finally {
      ioClient.close();
    }
  }

  void updatePlantFromIndex() {
    if (plants.isNotEmpty) {
      final selectedPlant = plants[currentPlantIndex];
      String imageUrl = selectedPlant['image_url'] ?? '';
      if (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute) {
        imageUrl = 'lib/Assets/images/rose_placeholder.jpg'; // Fallback image
      }

      setState(() {
        plantName = selectedPlant['common_name'] ?? 'Unknown Plant';
        plantDescription =
            selectedPlant['scientific_name'] ?? 'No description available';
        plantImage = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current screen size for later
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const TopNavigation(
        title: 'Plant Finder',
        backButton: false,
        showMenuIcon: true,
      ),
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Container(
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    color: AppColors.uiTile,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.fontColor),
                      suffixIcon: IconButton(
                        icon: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child:
                              Image.asset('lib/Assets/images/camera_100.png'),
                        ),
                        onPressed: onCameraButtonPressed, // Empty functionality
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: AppColors.fontColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(color: AppColors.fontColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Try hitting the random button for a new plant :)',
              style: TextStyle(fontSize: 16.0, color: AppColors.fontColor),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fontColor),
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.uiTile,
                  ),
                  child: IconButton(
                    icon:
                        Image.asset('lib/Assets/images/reverse_arrow_100.png'),
                    onPressed: onBackButtonPressed,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fontColor),
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.uiTile,
                  ),
                  child: IconButton(
                    icon: Image.asset('lib/Assets/images/shuffle_final.png'),
                    onPressed: onShuffleButtonPressed,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fontColor),
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.uiTile,
                  ),
                  child: IconButton(
                    icon:
                        Image.asset('lib/Assets/images/forward_arrow_100.png'),
                    onPressed: onForwardButtonPressed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fontColor),
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.uiTile,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Flexible(
                          child: Stack(
                            children: [
                              Container(
                                height: screenHeight * 0.4,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.fontColor),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: plantImage.startsWith('http')
                                      ? Image.network(
                                          plantImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'lib/Assets/images/default_plant.jpg',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          plantImage,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const Positioned(
                                bottom: 10,
                                right: 10,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          plantName,
                          style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.fontColor),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          plantDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0, color: AppColors.fontColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
