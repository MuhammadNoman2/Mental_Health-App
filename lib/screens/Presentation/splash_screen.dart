import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_screen.dart'; // Update with the correct route if needed.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Define the animation with ease-out
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Navigate to the Onboarding screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => const OnboardingScreen());
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ScaleTransition(
                scale: _animation,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.teal[200],
                  child: Icon(
                    Icons.self_improvement_outlined,
                    size: 150, // Increased size for a bold appearance
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Mental Health Smart",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "System App",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
