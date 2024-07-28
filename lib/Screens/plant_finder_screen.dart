import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/io_client.dart';
import 'package:retry/retry.dart';
import 'dart:math';
import '/Global_Elements/colors.dart';
import '/Screens/detailed_plant_screen.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/camera_screen.dart';

class PlantFinderScreen extends StatefulWidget {
  const PlantFinderScreen({super.key});

  @override
  PlantFinderPageState createState() => PlantFinderPageState();
}

class PlantFinderPageState extends State<PlantFinderScreen> {
  List plants = [];
  int currentPlantIndex = 0;
  List<Map<String, dynamic>> plantHistory = [];
  String plantName = 'Rose';
  String plantDescription =
      'Roses are one of the oldest flowers on Earth. Fossil evidence suggests that roses are at least 35 million years old!';
  String plantImage = 'lib/Assets/images/rose_placeholder.jpg';
  bool isRandomSelected = false;
  String probability = '';
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  List<Map<String, dynamic>> suggestions = [];
  int currentSuggestionIndex = 0;
  bool showArrows = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void onBackButtonPressed() {
    if (plantHistory.isNotEmpty) {
      final previousPlant = plantHistory.removeLast();
      currentPlantIndex = previousPlant['index'];
      plantName = previousPlant['name'];
      plantDescription = previousPlant['description'];
      plantImage = previousPlant['image'];
      setState(() {});
    }
  }

  void onShuffleButtonPressed() {
    saveCurrentPlantState();
    fetchRandomPlant();
  }

  void onForwardButtonPressed() {
    if (currentPlantIndex < plants.length - 1) {
      saveCurrentPlantState();
      currentPlantIndex++;
      updatePlantFromIndex();
    }
  }

  void saveCurrentPlantState() {
    plantHistory.add({
      'index': currentPlantIndex,
      'name': plantName,
      'description': plantDescription,
      'image': plantImage,
    });
  }

  Future<void> onCameraButtonPressed() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _openCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          controller: _controller!,
          initializeControllerFuture: _initializeControllerFuture,
          onPictureTaken: (File imageFile) {
            print('Picture taken callback received.');
            identifyPlant(imageFile);
          },
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      print('Image picked from gallery: ${pickedFile.path}');
      identifyPlant(imageFile);
    }
  }

  Future<void> identifyPlant(File imageFile) async {
    final String apiKey = dotenv.env['PLANT_ID_API_KEY']!;
    final String apiUrl = 'https://api.plant.id/v2/identify';

    print('Identifying plant with image: ${imageFile.path}');

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['api_key'] = apiKey
        ..files
            .add(await http.MultipartFile.fromPath('images', imageFile.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        print('API response: $data');

        if (data['suggestions'] != null && data['suggestions'].isNotEmpty) {
          suggestions = List<Map<String, dynamic>>.from(data['suggestions']);
          currentSuggestionIndex = 0;
          showArrows = true;
          updateDisplayedPlant(suggestions[currentSuggestionIndex]);
        } else {
          print('No suggestions found');
          setState(() {
            plantName = 'Unknown Plant';
            plantDescription = 'No description available';
            plantImage = 'lib/Assets/images/rose_placeholder.jpg';
            showArrows = false;
          });
        }
      } else {
        print('Failed to identify plant: ${responseData.body}');
      }
    } catch (e) {
      print('Error identifying plant: $e');
    }
  }

  void updateDisplayedPlant(Map<String, dynamic> suggestion) {
    setState(() {
      plantName = suggestion['plant_name'] ?? 'Unknown Plant';
      plantDescription = suggestion['plant_details']['scientific_name'] ??
          'No description available';
      probability = (suggestion['probability'] * 100).toStringAsFixed(2);
    });
    fetchWikipediaImage(suggestion['plant_details']['scientific_name']);
  }

  Future<void> fetchPlantImage(String plantName) async {
    final String apiKey = dotenv.env['PLANT_ID_API_KEY']!;
    final String apiUrl =
        'https://api.plant.id/v2/plants/search?query=$plantName&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Plant image API response: $data');

        if (data['plants'] != null && data['plants'].isNotEmpty) {
          final plants = data['plants'] as List;
          final plantImageUrl = plants.first['images'] != null &&
                  plants.first['images'].isNotEmpty
              ? plants.first['images'][0]['url']
              : 'lib/Assets/images/rose_placeholder.jpg';

          setState(() {
            plantImage = plantImageUrl;
          });
        } else {
          print('No plant image found');
          setState(() {
            plantImage = 'lib/Assets/images/rose_placeholder.jpg';
          });
        }
      } else {
        print('Failed to fetch plant image: ${response.body}');
        setState(() {
          plantImage = 'lib/Assets/images/rose_placeholder.jpg';
        });
      }
    } catch (e) {
      print('Error fetching plant image: $e');
      setState(() {
        plantImage = 'lib/Assets/images/rose_placeholder.jpg';
      });
    }
  }

  Future<void> fetchRandomPlant() async {
    final String? apiKey = dotenv.env['TREFLE_API_KEY'];
    if (apiKey == null) {
      print('Error: API key is missing');
      return;
    }

    final randomPage = Random().nextInt(100) + 1;
    final String apiUrl =
        'https://trefle.io/api/v1/plants?token=$apiKey&page=$randomPage';

    final ioClient = IOClient(createHttpClient(null));

    try {
      print('Fetching data from API...');
      final response = await retry(
        () => ioClient
            .get(Uri.parse(apiUrl))
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
          isRandomSelected = true;
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

  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = HttpClient(context: context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  void updatePlantFromIndex() {
    if (plants.isNotEmpty) {
      final selectedPlant = plants[currentPlantIndex];
      String imageUrl = selectedPlant['image_url'] ?? '';
      setState(() {
        plantName = selectedPlant['common_name'] ?? 'Unknown Plant';
        plantDescription =
            selectedPlant['scientific_name'] ?? 'No description available';
        plantImage = imageUrl.isNotEmpty
            ? imageUrl
            : 'lib/Assets/images/rose_placeholder.jpg';
      });
    }
  }

  void navigateToPlantDetails() {
    final selectedPlant = plants[currentPlantIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailsScreen(
          scientificName: selectedPlant['scientific_name'] ?? 'Unknown',
        ),
      ),
    );
  }

  //Suggestion arrows
  void onLeftArrowPressed() {
    if (currentSuggestionIndex > 0) {
      currentSuggestionIndex--;
      updateDisplayedPlant(suggestions[currentSuggestionIndex]);
    }
  }

//Suggestion arrows
  void onRightArrowPressed() {
    if (currentSuggestionIndex < suggestions.length - 1) {
      currentSuggestionIndex++;
      updateDisplayedPlant(suggestions[currentSuggestionIndex]);
    }
  }

  void updatePlant(String name, String description, String image) {
    setState(() {
      plantName = name;
      plantDescription = description;
      plantImage = image;
    });
  }

  Future<void> fetchWikipediaImage(String scientificName) async {
    final String apiUrl =
        'https://en.wikipedia.org/w/api.php?action=query&titles=$scientificName&prop=pageimages&format=json&pithumbsize=500';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];
        final pageKey = pages.keys.first;
        final page = pages[pageKey];

        if (page.containsKey('thumbnail')) {
          final imageUrl = page['thumbnail']['source'];
          setState(() {
            plantImage = imageUrl;
          });
        } else {
          setState(() {
            plantImage = 'lib/Assets/images/rose_placeholder.jpg';
          });
        }
      } else {
        print('Failed to fetch image from Wikipedia: ${response.body}');
        setState(() {
          plantImage = 'lib/Assets/images/rose_placeholder.jpg';
        });
      }
    } catch (e) {
      print('Error fetching image from Wikipedia: $e');
      setState(() {
        plantImage = 'lib/Assets/images/rose_placeholder.jpg';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Provider.of<ThemeNotifier>(context).getTheme();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Container(
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
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
                        onPressed: onCameraButtonPressed,
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
                if (isRandomSelected)
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.fontColor),
                      borderRadius: BorderRadius.circular(16.0),
                      color: theme.cardColor,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                          'lib/Assets/images/reverse_arrow_100.png'),
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
                    color: theme.cardColor,
                  ),
                  child: IconButton(
                    icon: Image.asset('lib/Assets/images/shuffle_final.png'),
                    onPressed: onShuffleButtonPressed,
                  ),
                ),
                if (isRandomSelected) const SizedBox(width: 8.0),
                if (isRandomSelected)
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.fontColor),
                      borderRadius: BorderRadius.circular(16.0),
                      color: theme.cardColor,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                          'lib/Assets/images/forward_arrow_100.png'),
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
                    color: theme.cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: navigateToPlantDetails,
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
                                        ? FadeInImage.assetNetwork(
                                            placeholder:
                                                'lib/Assets/images/rose_placeholder.jpg',
                                            image: plantImage,
                                            fit: BoxFit.cover,
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
                              fontSize: 16.0, color: AppColors.fontColor),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Probability: $probability%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0, color: AppColors.fontColor),
                        ),
                        if (showArrows)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_left,
                                    color: AppColors.fontColor),
                                onPressed: onLeftArrowPressed,
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_right,
                                    color: AppColors.fontColor),
                                onPressed: onRightArrowPressed,
                              ),
                            ],
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
