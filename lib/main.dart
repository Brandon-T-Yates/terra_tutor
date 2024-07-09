import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Screens/splash_screen.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import 'package:terra_tutor/Data/plant_image_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(ThemeNotifier.defaultTheme),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();

    return ChangeNotifierProvider(
      create: (context) => PlantImageProvider(),
      child: MaterialApp(
        theme: theme,
        home: const SplashScreen(),
      ),
    );
  }
}
