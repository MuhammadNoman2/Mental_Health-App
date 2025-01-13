import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Regularly"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Why Exercise Matters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Regular physical activity boosts your mood, strengthens your body, and promotes long-term health.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset("assets/images/exercise1.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Simple Exercises to Start:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Morning stretches."),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Daily walks or jogging."),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Short home workouts."),
            ),
          ],
        ),
      ),
    );
  }
}
