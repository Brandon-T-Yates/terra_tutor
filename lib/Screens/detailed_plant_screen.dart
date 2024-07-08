import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:terra_tutor/Global_Elements/top_navigation.dart';
import '/Global_Elements/colors.dart';

class PlantDetailsScreen extends StatefulWidget {
  final String scientificName;

//Requires plant's scientific name to be sent to this class
  PlantDetailsScreen({required this.scientificName});

  @override
  _PlantDetailsScreenState createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  Map<String, dynamic>? plantDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlantDetails();
  }

//Ignores SSL certificates if Certification is down or messed up
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = HttpClient(context: context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

//Searches for plant that was sent to class.
  Future<void> fetchPlantDetails() async {
    final String? apiKey = dotenv.env['TREFLE_API_KEY'];
    if (apiKey == null) {
      print('Error: API key is missing');
      return;
    }

    final String apiUrl =
        'https://trefle.io/api/v1/plants/search?token=$apiKey&q=${widget.scientificName}';

    final ioClient = IOClient(createHttpClient(null));

    try {
      print('Fetching plant details from API...');
      final response = await ioClient.get(Uri.parse(apiUrl));
      //On sucess
      if (response.statusCode == 200) {
        print('API call successful');
        final data = json.decode(response.body);
        setState(() {
          plantDetails =
              (data['data'] as List).isNotEmpty ? data['data'][0] : null;
          isLoading = false;
        });
      } else {
        print('Failed to load plant details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plant details: $e');
    } finally {
      ioClient.close();
    }
  }

//IF plant doesn't have any data, exclude from results.
  Widget buildPlantDetail(String title, dynamic value) {
    if (value == null || value.toString().isEmpty || value == 'N/A') {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$title: ${value.toString()}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

//Plant's popup image when pressed
  void showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Make the dialog background transparent
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.uiTile, // Set the background color to uiTile
              borderRadius:
                  BorderRadius.circular(16.0), // Optional: Rounded corners
              border: Border.all(
                  color: AppColors.fontColor), // Optional: Add border
            ),
            padding: EdgeInsets.all(16.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'lib/Assets/images/rose_placeholder.jpg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Places common name inside of box
  Widget buildCommonNameDetail(String value) {
    if (value.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Places scientific name inside of box
  Widget buildScientificNameDetail(String value) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

//Handles lists that get returned in the results.
  String joinList(List<dynamic>? list, String key) {
    if (list == null) return '';
    return list
        .where((item) => item is Map && item.containsKey(key))
        .map((item) => item[key].toString())
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const TopNavigation(
        title: 'Plant Details',
        backButton: true,
        showMenuIcon: true,
      ),
      backgroundColor: AppColors.primaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : plantDetails == null
              ? const Center(
                  child: Text('No details found for the specified plant.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.uiTile,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: AppColors.fontColor),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  if (plantDetails!['image_url'] != null) {
                                    showImagePopup(
                                        context, plantDetails!['image_url']);
                                  }
                                },
                                child: plantDetails!['image_url'] != null
                                    ? Image.network(
                                        plantDetails!['image_url'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'lib/Assets/images/rose_placeholder.jpg',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'lib/Assets/images/rose_placeholder.jpg',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildCommonNameDetail(
                                        plantDetails!['common_name']),
                                    buildScientificNameDetail(
                                        plantDetails!['scientific_name']),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.uiTile,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: AppColors.fontColor),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Unneeded details
                                // buildPlantDetail('ID', plantDetails!['id']),
                                //  buildPlantDetail('Slug', plantDetails!['slug']),
                                buildPlantDetail(
                                    'Year Discovered', plantDetails!['year']),
                                buildPlantDetail('Bibliography',
                                    plantDetails!['bibliography']),
                                buildPlantDetail(
                                    'Author', plantDetails!['author']),
                                buildPlantDetail(
                                    'Status', plantDetails!['status']),
                                buildPlantDetail('Rank', plantDetails!['rank']),
                                buildPlantDetail('Family Common Name',
                                    plantDetails!['family_common_name']),
                                buildPlantDetail(
                                    'Family', plantDetails!['family']),
                                buildPlantDetail(
                                    'Genus ID', plantDetails!['genus_id']),
                                buildPlantDetail(
                                    'Genus', plantDetails!['genus']),
                                buildPlantDetail(
                                    'Duration',
                                    (plantDetails!['duration'] as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Edible Part',
                                    (plantDetails!['edible_part'] as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Edible', plantDetails!['edible']),
                                buildPlantDetail(
                                    'Vegetable', plantDetails!['vegetable']),
                                buildPlantDetail('Observations',
                                    plantDetails!['observations']),
                                buildPlantDetail('Common Names',
                                    plantDetails!['common_names']?.toString()),
                                buildPlantDetail('Distribution',
                                    plantDetails!['distribution']?.toString()),
                                buildPlantDetail(
                                    'Synonyms',
                                    joinList(
                                        plantDetails!['synonyms'], 'name')),
                                buildPlantDetail('Sources',
                                    joinList(plantDetails!['sources'], 'name')),
                                buildPlantDetail(
                                    'Flower Images',
                                    joinList(plantDetails!['images']?['flower'],
                                        'url')),
                                buildPlantDetail(
                                    'Leaf Images',
                                    joinList(plantDetails!['images']?['leaf'],
                                        'url')),
                                buildPlantDetail(
                                    'Habit Images',
                                    joinList(plantDetails!['images']?['habit'],
                                        'url')),
                                buildPlantDetail(
                                    'Fruit Images',
                                    joinList(plantDetails!['images']?['fruit'],
                                        'url')),
                                buildPlantDetail(
                                    'Bark Images',
                                    joinList(plantDetails!['images']?['bark'],
                                        'url')),
                                buildPlantDetail(
                                    'Other Images',
                                    joinList(plantDetails!['images']?['other'],
                                        'url')),
                                buildPlantDetail(
                                    'Distribution Native',
                                    joinList(
                                        plantDetails!['distributions']
                                            ?['native'],
                                        'name')),
                                buildPlantDetail(
                                    'Distribution Introduced',
                                    joinList(
                                        plantDetails!['distributions']
                                            ?['introduced'],
                                        'name')),
                                buildPlantDetail(
                                    'Distribution Doubtful',
                                    joinList(
                                        plantDetails!['distributions']
                                            ?['doubtful'],
                                        'name')),
                                buildPlantDetail(
                                    'Distribution Absent',
                                    joinList(
                                        plantDetails!['distributions']
                                            ?['absent'],
                                        'name')),
                                buildPlantDetail(
                                    'Distribution Extinct',
                                    joinList(
                                        plantDetails!['distributions']
                                            ?['extinct'],
                                        'name')),
                                buildPlantDetail(
                                    'Flower Color',
                                    (plantDetails!['flower']?['color'] as List?)
                                        ?.join(', ')),
                                buildPlantDetail('Flower Conspicuous',
                                    plantDetails!['flower']?['conspicuous']),
                                buildPlantDetail('Foliage Texture',
                                    plantDetails!['foliage']?['texture']),
                                buildPlantDetail(
                                    'Foliage Color',
                                    (plantDetails!['foliage']?['color']
                                            as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Foliage Leaf Retention',
                                    plantDetails!['foliage']
                                        ?['leaf_retention']),
                                buildPlantDetail(
                                    'Fruit or Seed Conspicuous',
                                    plantDetails!['fruit_or_seed']
                                        ?['conspicuous']),
                                buildPlantDetail(
                                    'Fruit or Seed Color',
                                    (plantDetails!['fruit_or_seed']?['color']
                                            as List?)
                                        ?.join(', ')),
                                buildPlantDetail('Fruit or Seed Shape',
                                    plantDetails!['fruit_or_seed']?['shape']),
                                buildPlantDetail(
                                    'Fruit or Seed Persistence',
                                    plantDetails!['fruit_or_seed']
                                        ?['seed_persistence']),
                                buildPlantDetail(
                                    'Specifications Ligneous Type',
                                    plantDetails!['specifications']
                                        ?['ligneous_type']),
                                buildPlantDetail(
                                    'Specifications Growth Form',
                                    plantDetails!['specifications']
                                        ?['growth_form']),
                                buildPlantDetail(
                                    'Specifications Growth Habit',
                                    plantDetails!['specifications']
                                        ?['growth_habit']),
                                buildPlantDetail(
                                    'Specifications Growth Rate',
                                    plantDetails!['specifications']
                                        ?['growth_rate']),
                                buildPlantDetail(
                                    'Specifications Average Height',
                                    plantDetails!['specifications']
                                            ?['average_height']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Specifications Maximum Height',
                                    plantDetails!['specifications']
                                            ?['maximum_height']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Specifications Nitrogen Fixation',
                                    plantDetails!['specifications']
                                        ?['nitrogen_fixation']),
                                buildPlantDetail(
                                    'Specifications Shape and Orientation',
                                    plantDetails!['specifications']
                                        ?['shape_and_orientation']),
                                buildPlantDetail(
                                    'Specifications Toxicity',
                                    plantDetails!['specifications']
                                        ?['toxicity']),
                                buildPlantDetail(
                                    'Growth Days to Harvest',
                                    plantDetails!['growth']?['days_to_harvest']
                                        ?.toString()),
                                buildPlantDetail('Growth Description',
                                    plantDetails!['growth']?['description']),
                                buildPlantDetail('Growth Sowing',
                                    plantDetails!['growth']?['sowing']),
                                buildPlantDetail(
                                    'Growth pH Maximum',
                                    plantDetails!['growth']?['ph_maximum']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Growth pH Minimum',
                                    plantDetails!['growth']?['ph_minimum']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Growth Light',
                                    plantDetails!['growth']?['light']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Growth Atmospheric Humidity',
                                    plantDetails!['growth']
                                            ?['atmospheric_humidity']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Growth Months',
                                    (plantDetails!['growth']?['growth_months']
                                            as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Bloom Months',
                                    (plantDetails!['growth']?['bloom_months']
                                            as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Fruit Months',
                                    (plantDetails!['growth']?['fruit_months']
                                            as List?)
                                        ?.join(', ')),
                                buildPlantDetail(
                                    'Row Spacing',
                                    plantDetails!['growth']?['row_spacing']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Spread',
                                    plantDetails!['growth']?['spread']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Minimum Precipitation',
                                    plantDetails!['growth']
                                            ?['minimum_precipitation']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Maximum Precipitation',
                                    plantDetails!['growth']
                                            ?['maximum_precipitation']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Minimum Root Depth',
                                    plantDetails!['growth']
                                            ?['minimum_root_depth']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Minimum Temperature',
                                    plantDetails!['growth']
                                            ?['minimum_temperature']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Maximum Temperature',
                                    plantDetails!['growth']
                                            ?['maximum_temperature']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Soil Nutriments',
                                    plantDetails!['growth']?['soil_nutriments']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Soil Salinity',
                                    plantDetails!['growth']?['soil_salinity']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Soil Texture',
                                    plantDetails!['growth']?['soil_texture']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Soil Humidity',
                                    plantDetails!['growth']?['soil_humidity']
                                        ?.toString()),
                                buildPlantDetail(
                                    'Synonyms',
                                    joinList(
                                        plantDetails!['synonyms'], 'name')),
                                buildPlantDetail('Sources',
                                    joinList(plantDetails!['sources'], 'name')),
                              ],
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
