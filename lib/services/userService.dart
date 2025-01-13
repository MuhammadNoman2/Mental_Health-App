import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Map<String, dynamic>> chatHistory = <Map<String, dynamic>>[].obs;

  final RxBool isFetchingHistory = false.obs;
  final RxString fetchErrorMessage = "".obs;

  var userName = "Loading...".obs; // Observable for user name
  var email = "umair@gmail.com".obs; // Observable for email

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data (name and email) when the controller initializes
  }

  /// Fetch user data (name and email) from Firestore
  Future<void> fetchUserData() async {
    try {
      final String uid = _auth.currentUser!.uid; // Get the current user's UID
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userName.value = userDoc['fullName'] as String? ?? "User"; // Update userName
        email.value = userDoc['email'] as String? ?? "Unknown"; // Update email
      } else {
        userName.value = "User"; // Default if no document found
        email.value = "Unknown"; // Default if no email found
      }
    } catch (e) {
      userName.value = "Error"; // Handle errors gracefully
      email.value = "Error"; // Handle errors gracefully
    }
  }

  /// Fetch chat history from Firestore
  Future<void> fetchChatHistory() async {
    try {
      isFetchingHistory.value = true;
      fetchErrorMessage.value = "";

      final String uid = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('ChatSessions')
          .orderBy('timestamp', descending: true)
          .get();

      chatHistory.value = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      fetchErrorMessage.value = "Failed to fetch chat history: $e";
    } finally {
      isFetchingHistory.value = false;
    }
  }
}
