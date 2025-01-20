import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;
  Rx<String> ownerEmail = "flutter.developer342@gmail.com".obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> submitFeedback(String userEmail, String feedback) async {
    isLoading.value = true;
    try {
      // Send feedback to the owner
      await sendEmail(userEmail, feedback);

      // Store feedback locally (e.g., using a service or database)
      await storeFeedback(userEmail, feedback);

      Get.snackbar("Success", "Your feedback has been submitted!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.back(); // Navigate back
    } catch (e) {
      Get.snackbar("Error", "Failed to submit feedback. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendEmail(String userEmail, String feedback) async {
    // Mock email sending logic
    await Future.delayed(Duration(seconds: 2)); // Simulate email sending delay
    print('Sending feedback to ${ownerEmail.value} from $userEmail: $feedback');
  }

  Future<void> storeFeedback(String userEmail, String feedback) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('Feedback')
        .doc(userEmail)
        .set({'FeedBack': feedback});
    print('Storing feedback for $userEmail');
  }
}
