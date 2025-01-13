import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/screens/Wellness/widgets/mindfullness.dart';

import 'widgets/resourses/books.dart';
import 'widgets/resourses/hotline.dart';
import 'widgets/resourses/therapist.dart';
import 'widgets/selfcare/break.dart';
import 'widgets/selfcare/diet.dart';
import 'widgets/selfcare/excercise.dart';
import 'widgets/selfcare/hydration.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Wellness",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mindfulness Section
                _buildMindfulnessSection(),
                const SizedBox(height: 20),
                // Self-Care Section
                _buildSelfCareSection(),
                const SizedBox(height: 20),
                // Resources Section
                _buildResourcesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMindfulnessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mindfulness",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.self_improvement, color: Colors.blue, size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Daily Guided Meditation",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "10-15 min sessions to relax your mind.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Get.to(()=> MindfulnessScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Start Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelfCareSection() {
    final List<Map<String, dynamic>> selfCareTips = [
      {
        "title": "Stay Hydrated",
        "icon": Icons.water_drop,
        "navigateTo": () => Get.to(const HydrationScreen()), // Function that navigates
      },
      {
        "title": "Take a Break",
        "icon": Icons.beach_access,
        "navigateTo": () => Get.to(const BreaksScreen()),
      },
      {
        "title": "Eat Healthy",
        "icon": Icons.restaurant,
        "navigateTo": () => Get.to(const DietScreen()),
      },
      {
        "title": "Exercise Regularly",
        "icon": Icons.directions_run,
        "navigateTo": () => Get.to(const ExerciseScreen()),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Self-Care Tips",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3,
          ),
          itemCount: selfCareTips.length,
          itemBuilder: (context, index) {
            final tip = selfCareTips[index];
            return GestureDetector(
              onTap: () => tip["navigateTo"](), // Call the navigation function
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tip["icon"],
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tip["title"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }


  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Helpful Resources",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildResourceTile(
              "Mental Health Hotline",
              "Call for immediate help.",
              Icons.phone,
              onTap: () => Get.to(() => const HotlineScreen()),
            ),
            _buildResourceTile(
              "Therapists Near You",
              "Find professionals to talk to.",
              Icons.map,
              onTap: () => Get.to(() => const TherapistsScreen()),
            ),
            _buildResourceTile(
              "Self-Help Books",
              "Recommended readings for wellness.",
              Icons.book,
              onTap: () => Get.to(() => const BooksScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceTile(String title, String subtitle, IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
