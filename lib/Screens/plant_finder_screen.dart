import 'package:flutter/material.dart';
import '/Global_Elements/colors.dart';
import '/Global_Elements/top_navigation.dart';
import '/Global_Elements/bottom_navigation.dart'; // Ensure this import points to the correct location

class PlantFinderScreen extends StatefulWidget {
  const PlantFinderScreen({super.key});

  @override
  _PlantFinderPageState createState() => _PlantFinderPageState();
}

class _PlantFinderPageState extends State<PlantFinderScreen> {
  int _selectedIndex = 2; // Index for BottomNavigationBar

  // State default variables for plant name, description, and image
  String plantName = 'Rose';
  String plantDescription =
      'Roses are one of the oldest flowers on Earth. Fossil evidence suggests that roses are at least 35 million years old!';
  String plantImage = 'lib/Assets/images/rose_placeholder.jpg';

  void _onItemTapped(int index) {
    // Handle navigation based on selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  void onBackButtonPressed() {
    // Placeholder for back button functionality
  }

  void onShuffleButtonPressed() {
    // Placeholder for shuffle button functionality
  }

  void onForwardButtonPressed() {
    // Placeholder for forward button functionality
  }

  void onCameraButtonPressed() {
    // Placeholder for camera button functionality
  }

  void updatePlant(String name, String description, String image) {
    setState(() {
      plantName = name;
      plantDescription = description;
      plantImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Get current screen size for later
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
                        icon: const Icon(Icons.camera_alt,
                            color: AppColors.fontColor),
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
                    //TODO: Switch out Icons.arrow_back with custom image.
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.fontColor),
                    onPressed: () {
                      updatePlant(
                        'Previous Plant', // Example name
                        'Description of the previous plant.', // Example description
                        'lib/Assets/images/previous_plant.jpg', // Example image path
                      );
                    },
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
                    //TODO: Switch out Icons.shuffle with custom image.
                    icon: const Icon(Icons.shuffle, color: AppColors.fontColor),
                    onPressed: () {
                      updatePlant(
                        'Random Plant', // Example name
                        'Description of a random plant.', // Example description
                        'lib/Assets/images/random_plant.jpg', // Example image path
                      );
                    },
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
                    //TODO: Switch out Icons.forward with custom image.
                    icon: const Icon(Icons.arrow_forward,
                        color: AppColors.fontColor),
                    onPressed: () {
                      updatePlant(
                        'Next Plant', // Example name
                        'Description of the next plant.', // Example description
                        'lib/Assets/images/next_plant.jpg', // Example image path
                      );
                    },
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
                                  child: Image.asset(
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
                            color: AppColors.fontColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          plantDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.fontColor,
                          ),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
