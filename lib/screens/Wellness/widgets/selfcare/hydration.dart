import 'package:flutter/material.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stay Hydrated"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Why is Hydration Important?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Staying hydrated is essential for maintaining energy levels, improving brain function, and supporting your overall health. "
                  "Ensure you drink at least 8 glasses of water daily.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/hydration.png'), // Replace with an actual image asset.

          ],
        ),
      ),
    );
  }
}
