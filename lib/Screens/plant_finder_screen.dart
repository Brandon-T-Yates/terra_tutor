import 'package:flutter/material.dart';
import '/Global_Elements/colors.dart';
import '/Screens/home_page.dart'; // Add this import for HomePage

class PlantFinderScreen extends StatefulWidget {
  const PlantFinderScreen({super.key});

  @override
  PlantFinderPageState createState() => PlantFinderPageState();
}

class PlantFinderPageState extends State<PlantFinderScreen> {

  // State default variables for plant name, description, and image
  String plantName = 'Rose';
  String plantDescription =
      'Roses are one of the oldest flowers on Earth. Fossil evidence suggests that roses are at least 35 million years old!';
  String plantImage = 'lib/Assets/images/rose_placeholder.jpg';

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
      });
    }
  }

  void onBackButtonPressed() {
    // Placeholder for back button functionality
    fetchFromAPI("back");
  }

  void onShuffleButtonPressed() {
    // Placeholder for shuffle button functionality
    fetchFromAPI("shuffle");
  }

  void onForwardButtonPressed() {
    // Placeholder for forward button functionality
    fetchFromAPI("forward");
  }

  void onCameraButtonPressed() {
    // Placeholder for camera button functionality
  }

  void fetchFromAPI(String type) {
    setState(() {
      if (type == "shuffle") {
        // API Calls here for random plant
        updatePlant(
          'Random Plant', 
          'Description of a random plant.', 
          'lib/Assets/images/rose_placeholder.jpg',
        );
      } else if (type == "back") {
        // API Calls here for previous plant
        updatePlant(
          'Previous Plant', 
          'Description of the previous plant.', 
          'lib/Assets/images/rose_placeholder.jpg',
        );
      } else if (type == "forward") {
        // API Calls here for next plant
        updatePlant(
          'Next Plant', 
          'Description of the next plant.',
          'lib/Assets/images/rose_placeholder.jpg',
        );
      }
    });
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
    // Get current screen size for later
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

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
                      prefixIcon: const Icon(Icons.search, color: AppColors.fontColor),
                      suffixIcon: IconButton(
                        icon: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Image.asset('lib/Assets/images/camera_100.png'),
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
                    // TODO: Switch out Icons.arrow_back with custom image.
                    icon: Image.asset('lib/Assets/images/reverse_arrow_100.png'),
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
                    // TODO: Switch out Icons.shuffle with custom image.
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
                    // TODO: Switch out Icons.forward with custom image.
                    icon: Image.asset('lib/Assets/images/forward_arrow_100.png'),
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
                                  border: Border.all(color: AppColors.fontColor),
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
    );
  }
}