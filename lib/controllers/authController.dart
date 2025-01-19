import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/screens/Home/dashboard.dart';

import '../screens/Auth/login.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var isLoading = false.obs; // Observable for button loading state

  final RxList<Map<String, dynamic>> chatHistory = <Map<String, dynamic>>[].obs;

  final RxBool isFetchingHistory = false.obs;
  final RxString fetchErrorMessage = "".obs;

  var userName = "".obs; // Observable for user name
  var email = "".obs; // Observable for email
  var profileImage = "".obs;
  var isGoogleSignIn = false.obs;
  var dateOfBirth = ''.obs;
  var gender = ''.obs;
  var phoneNumber = ''.obs;
  var isDataSaved = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data (name and email) when the controller initializes
    loadPersonalInfo();
  }

  void signUpUser() async {
    isLoading.value = true;

    final String fullName = fullNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // Validation
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackbar("Error", "Please fill in all fields.");
      isLoading.value = false;
      return;
    }
    if (!GetUtils.isEmail(email)) {
      showSnackbar("Error", "Enter a valid email address.");
      isLoading.value = false;
      return;
    }
    if (password != confirmPassword) {
      showSnackbar("Error", "Passwords do not match.");
      isLoading.value = false;
      return;
    }
    if (password.length < 6) {
      showSnackbar("Error", "Password must be at least 6 characters long.");
      isLoading.value = false;
      return;
    }

    try {
      // Firebase Signup
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        }, SetOptions(merge: true));

    Get.to(()=> DashboardScreen());

      isLoading.value = false;
      clearFields();
      showSnackbar("Success", "Account created successfully.");
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      showSnackbar("Error", e.message ?? "An error occurred.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An unexpected error occurred.");
    }
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  // **Login Functionality**
  Future<void> loginUser() async {
    isLoading.value = true;

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Error", "Please fill in all fields.");
      isLoading.value = false;
      return;
    }
    if (!GetUtils.isEmail(email)) {
      showSnackbar("Error", "Enter a valid email address.");
      isLoading.value = false;
      return;
    }

    try {
      // Firebase Login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from the appropriate collection
      String collection = 'users';
      DocumentSnapshot userDoc = await _firestore
          .collection(collection)
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Navigate to the corresponding dashboard
       Get.to(()=> DashboardScreen());
        isLoading.value = false;
       clearFields();
        showSnackbar("Success", "Login successful.");
      } else {
        isLoading.value = false;
        showSnackbar("Error", "User data not found.");
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      showSnackbar("Error", e.message ?? "An error occurred.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An unexpected error occurred.");
    }
  }


  void updateProfileImage(String newImagePath) {
    profileImage.value = newImagePath;
  }

  Future<void> googleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var isLoading = false.obs;

    isLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        showSnackbar("Error", "Google Sign-In was canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      String collection = 'users';
      final userDoc = await _firestore.collection(collection).doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // Create new user if not exists
        await _firestore.collection(collection).doc(userCredential.user!.uid).set({
          'fullName': userCredential.user!.displayName ?? "No Name",
          'email': userCredential.user!.email ?? "No Email",
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      // Update UserController with Google Sign-In information
      updateProfileImage(googleUser.photoUrl ?? "");
      userName.value = googleUser.displayName ?? "No Name";
      email.value = googleUser.email ?? "No Email";
      isGoogleSignIn.value = true;

      // Navigate to the corresponding dashboard
      Get.to(() => DashboardScreen());
      isLoading.value = false;
      showSnackbar("Success", "Google Sign-In successful.");
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      showSnackbar("Error", e.message ?? "An error occurred.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An unexpected error occurred.");
    }
  }

  // **Logout Functionality**
  Future<void> logoutUser() async {
    isLoading.value = true;

    try {
      // If the user is signed in with Google, sign out from Google as well
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase Auth
      await _auth.signOut();
      clearFields();
      // Navigate to the login or welcome screen after logout
      Get.offAll(() => LoginScreen()); // This clears the entire navigation stack and redirects to the LoginScreen.

      isLoading.value = false;
      showSnackbar("Success", "Logged out successfully.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An error occurred during logout.");
    }
  }


  // Load user data from Firestore
  Future<void> loadPersonalInfo() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

    dateOfBirth.value = userDoc['dateOfBirth'] ?? '';
    gender.value = userDoc['gender'] ?? '';
    phoneNumber.value = userDoc['phoneNumber'] ?? '';
  }

  // Save user data to Firestore
  Future<void> savePersonalInfo(String dob, String Gender, String phone) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'dateOfBirth': dob,
      'gender': gender,
      'phoneNumber': phone,
    });

    dateOfBirth.value = dob;
    gender.value = Gender;
    phoneNumber.value = phone;
    isDataSaved.value = true;
  }




  /// Fetch user data (name and email) from Firestore
  Future<void> fetchUserData() async {
    try {
      final String uid = _auth.currentUser!.uid; // Get the current user's UID
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userName.value = userDoc['fullName'] as String? ?? "Guest"; // Update userName
        email.value = userDoc['email'] as String? ?? "Unknown"; // Update email
      } else {
        userName.value = "Guest"; // Default if no document found
        email.value = ""; // Default if no email found
      }
    } catch (e) {
      userName.value = "Guest"; // Handle errors gracefully
      email.value = ""; // Handle errors gracefully
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
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      fetchErrorMessage.value = "Kindly, Login to backup your data";
    } finally {
      isFetchingHistory.value = false;
    }
  }

  void clearFields(){
    // Clear user-specific data or session details
    emailController.clear();
    fullNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}