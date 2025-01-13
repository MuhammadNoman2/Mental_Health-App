import 'package:flutter/material.dart';

class BreaksScreen extends StatelessWidget {
  const BreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Breaks"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Importance of Taking Breaks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Regular breaks improve productivity, reduce stress, and enhance creativity. Step away from your tasks to recharge your mind and body.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Center(
                child: Image.asset("assets/images/yoga.png"),
              ),
              const Text(
                "Effective Break Activities:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text("Stretch your body."),
              ),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text("Take a short walk."),
              ),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text("Practice deep breathing."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
