import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../controllers/feedback_controller.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  final FeedbackController feedbackController = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: Obx(() => feedbackController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Your Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _responseController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Your Feedback",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty &&
                      _responseController.text.isNotEmpty) {
                    feedbackController.submitFeedback(
                        _emailController.text,
                        _responseController.text);
                  } else {
                    Get.snackbar("Error", "All fields are required",
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: Text("Submit"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  foregroundColor:  Get.isDarkMode ? Colors.black : Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
