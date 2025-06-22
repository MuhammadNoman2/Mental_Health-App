import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/controllers/authController.dart';
import 'package:mental_health_app/screens/Profile/profile.dart';
import '../Home/dashboard.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  final AuthController authController = Get.put(AuthController());
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

    // Handle auto-login after animation and minimum splash time
    _handleAutoLogin();
  }

  Future<void> _handleAutoLogin() async {
    // Wait for minimum splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // Load user data first
        await authController.fetchUserData();
        await authController.loadPersonalInfo();
        await authController.loadProfileImage();

        // Navigate to dashboard if user data is loaded successfully
        if (authController.userName.value.isNotEmpty) {
          Get.off(() => const DashboardScreen());
        } else {
          // If user data is incomplete, go to onboarding
          Get.off(() => const OnboardingScreen());
        }
      } catch (e) {
        print("Error loading user data: $e");
        // If there's an error, go to onboarding
        Get.off(() => const OnboardingScreen());
      }
    } else {
      // No user logged in, go to onboarding
      Get.off(() => const OnboardingScreen());
    }
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
                    size: 150,
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
              const SizedBox(height: 40),
              // Optional: Add a loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}