import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/screens/Home/dashboard.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var isLoading = false.obs; // Observable for button loading state

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

  // **Google Sign-In**
  Future<void> googleSignIn() async {
    isLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        showSnackbar("Error", "Google Sign-In was canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      String collection = 'users';
      final userDoc = await _firestore
          .collection(collection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user if not exists
        await _firestore.collection(collection).doc(userCredential.user!.uid).set({
          'fullName': userCredential.user!.displayName ?? "No Name",
          'email': userCredential.user!.email ?? "No Email",
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      // Navigate to the corresponding dashboard
      Get.to(()=> DashboardScreen());
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
  }