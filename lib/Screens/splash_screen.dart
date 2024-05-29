import 'package:flutter/material.dart';
import 'entrance_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from the bottom
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      // Total 5 seconds for animation and pause
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EntranceScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFADC2AF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _textAnimation,
              child: const Padding(
                padding: EdgeInsets.only(
                    bottom: 435.0), // Adjust to match entrance screen position
                child: Text(
                  'Terra Tutor',
                  style: TextStyle(
                    fontSize: 50.0, // Match the EntranceScreen font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 125.0), // Lower the logo slightly
              child: ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Image.asset(
                    'lib/Assets/images/placeholderlogo.png',
                    height: 200.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
