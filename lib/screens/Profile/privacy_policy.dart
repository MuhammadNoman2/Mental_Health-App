import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.blueGrey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Your Privacy is Important",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.security, color: Colors.blue),
                title: Text(
                  "Data Collection",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "We collect data to improve your experience. Your data will not be shared without your consent."),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.shield, color: Colors.green),
                title: Text(
                  "Security",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "We use industry-standard security measures to protect your data."),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.red),
                title: Text(
                  "User Control",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "You have full control over your personal information and can request its deletion."),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.contact_support, color: Colors.orange),
                title: Text(
                  "Contact Us",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "For any privacy-related queries, feel free to reach out to us."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
