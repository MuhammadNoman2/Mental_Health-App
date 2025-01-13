import 'package:flutter/material.dart';

class TherapistsScreen extends StatelessWidget {
  const TherapistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final therapists = [
      {"name": "Dr. Sarah Johnson", "designation": "Clinical Psychologist", "location": "New York, NY"},
      {"name": "Dr. Michael Lee", "designation": "Therapist", "location": "Los Angeles, CA"},
      {"name": "Dr. Emma Brown", "designation": "Counselor", "location": "Chicago, IL"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Therapists Near You"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: therapists.length,
        itemBuilder: (context, index) {
          final therapist = therapists[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              therapist["name"]!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${therapist["designation"]!}, ${therapist["location"]!}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          );
        },
      ),
    );
  }
}