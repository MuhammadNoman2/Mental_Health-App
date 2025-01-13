import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eat Healthy"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 100,

                  backgroundImage: AssetImage("assets/images/diet.png"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benefits of a Healthy Diet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Eating nutritious food helps maintain energy, improves mood, and reduces the risk of chronic diseases.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Healthy Eating Tips:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Include fruits and vegetables."),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Reduce sugar and salt intake."),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text("Stay consistent with meal timings."),
            ),
          ],
        ),
      ),
    );
  }
}
