import 'package:flutter/material.dart';
class HotlineScreen extends StatelessWidget {
  const HotlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotlines = [
      {"name": "National Suicide Prevention", "number": "1-800-273-8255"},
      {"name": "Mental Health Support", "number": "1-888-746-7464"},
      {"name": "Substance Abuse Helpline", "number": "1-800-662-4357"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Health Hotlines"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              hotline["name"]!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              hotline["number"]!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                // Handle calling functionality here
              },
            ),
          );
        },
      ),
    );
  }
}