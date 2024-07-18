import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '/Global_Elements/ui_tiles.dart';

class DailyFactsWidget extends StatefulWidget {
  const DailyFactsWidget({super.key});

  @override
  DailyFactsWidgetState createState() => DailyFactsWidgetState();
}

class DailyFactsWidgetState extends State<DailyFactsWidget> {
  late Future<List<String>> plantFacts;
  late Timer timer;
  List<String> facts = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadFactsAndStartTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void loadFactsAndStartTimer() {
    plantFacts = loadPlantFacts();
    plantFacts.then((loadedFacts) {
      setState(() {
        facts = loadedFacts;
        if (facts.isNotEmpty) {
          timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
            setState(() {
              currentIndex = (currentIndex + 1) % facts.length;
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: plantFacts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading plant facts'));
        } else {
          if (facts.isEmpty) {
            facts = snapshot.data!;
          }
          final currentFact =
              facts.isNotEmpty ? facts[currentIndex] : 'No facts available';
          return UiTile(
            name: 'Daily Facts',
            description: currentFact,
            textAlignment: TextAlignOption.center,
            descriptionTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }
      },
    );
  }
}

Future<List<String>> loadPlantFacts() async {
  final String response =
      await rootBundle.loadString('lib/Assets/plant_facts.json');
  final List<dynamic> data = json.decode(response);
  return data.map((fact) => fact['fact'] as String).toList();
}
