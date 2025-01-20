import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/screens/Home/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Auth/login.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var isGoogleLoading = false.obs;
  var isLoading = false.obs;
  final RxList<Map<String, dynamic>> chatHistory = <Map<String, dynamic>>[].obs;
  final RxBool isFetchingHistory = false.obs;
  final RxString fetchErrorMessage = "".obs;

  var userName = "".obs;
  var email = "".obs;
  var profileImage = "".obs;
  var isGoogleSignIn = false.obs;
  var dateOfBirth = ''.obs;
  var gender = ''.obs;
  var phoneNumber = ''.obs;
  var isDataSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    loadPersonalInfo();
    loadProfileImage();
    autoLogin();
  }

  // Automatically login if the user is already authenticated
  Future<void> autoLogin() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        // Fetch user data from Firestore
        await fetchUserData();

        // Ensure critical data is loaded before routing
        if (userName.value.isNotEmpty) {
          Get.off(() => DashboardScreen());
        } else {
          throw Exception("User data is incomplete.");
        }
      } catch (e) {
        print("Error during auto-login: $e");
        Get.off(() => LoginScreen());
      }
    } else {
      Get.off(() => LoginScreen());
    }
  }

  // Sign Up
  Future<void> signUpUser() async {
    isLoading.value = true;
    final String fullName = fullNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      // Fetch user data after signup
      await fetchUserData(); // Add this line to fetch user data

      Get.to(() => DashboardScreen());
      isLoading.value = false;
      clearFields();
      showSnackbar("Success", "Account created successfully.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An error occurred.");
    }
  }

  // Show Snackbar
  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  // Login
  Future<void> loginUser() async {
    isLoading.value = true;
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Fetch user data after login
      await fetchUserData(); // Add this line to fetch user data

      if (userDoc.exists) {
        Get.to(() => DashboardScreen());
        isLoading.value = false;
        clearFields();
        showSnackbar("Success", "Login successful.");
      } else {
        isLoading.value = false;
        showSnackbar("Error", "User data not found.");
      }
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An unexpected error occurred.");
    }
  }

  // Google Sign-In
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

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': userCredential.user!.displayName ?? "No Name",
          'email': userCredential.user!.email ?? "No Email",
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      updateProfileImage(googleUser.photoUrl ?? "");
      userName.value = googleUser.displayName ?? "No Name";
      email.value = googleUser.email ?? "No Email";
      isGoogleSignIn.value = true;

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

  // Logout
  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      await clearProfileImage();
      clearUserData();
      clearFields();
      clearPersonalInfo();
      Get.offAll(() => LoginScreen());
      isLoading.value = false;
      showSnackbar("Success", "Logged out successfully.");
    } catch (e) {
      isLoading.value = false;
      showSnackbar("Error", "An error occurred during logout.");
    }
  }

  // Load User Data
  Future<void> loadPersonalInfo() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        dateOfBirth.value = userDoc['dateOfBirth']?.toString() ?? '';
        gender.value = userDoc['gender']?.toString() ?? '';
        phoneNumber.value = userDoc['phoneNumber']?.toString() ?? '';
      } else {
        dateOfBirth.value = '';
        gender.value = '';
        phoneNumber.value = '';
      }
    } catch (e) {
      print('Error loading personal info: $e');
    }
  }

  // Save Personal Info
  Future<void> savePersonalInfo(String dob, String gender, String phone) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      await _firestore.collection('users').doc(uid).update({
        'dateOfBirth': dob,
        'gender': gender,
        'phoneNumber': phone,
      });
      Get.back();

      dateOfBirth.value = dob;
      this.gender.value = gender;
      phoneNumber.value = phone;
      isDataSaved.value = true;

      Get.snackbar(
          backgroundColor: Colors.green.shade200,
          snackPosition: SnackPosition.BOTTOM,
          'Profile Updated',
          'Profile successfully updated');
    } catch (e) {
      print('Error saving personal info: $e');
    }
  }

  // Fetch User Data
  // Fetch User Data
  // Fetch Basic User Data
  Future<void> fetchUserData() async {
    try {
      print('Processing fetching basic user data');
      final String uid = _auth.currentUser!.uid;
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Fetch user data only if it exists in Firestore
        userName.value = userDoc['fullName']?.toString() ?? "No Name";
        email.value = userDoc['email']?.toString() ?? "Unknown Email";

        // Debug print to check data retrieval
        print("Basic user data fetched: ${userName.value}, ${email.value}");

        // Now call to fetch additional info
        fetchAdditionalUserInfo();
      } else {
        // If userDoc doesn't exist, fallback to default values
        print("User document does not exist in Firestore.");
        userName.value = "Guest";
        email.value = "Unknown";
      }
    } catch (e) {
      // Handle any exceptions that occur during data fetch
      print("Error fetching user data: $e");
      userName.value = "Guest";  // Fallback to default if fetching fails
      email.value = "";
    }
  }

// Fetch Additional User Info
  // Fetch Additional User Info
  Future<void> fetchAdditionalUserInfo() async {
    try {
      final String uid = _auth.currentUser!.uid;
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      // Safely cast the data to Map<String, dynamic> before checking for keys
      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Check if optional fields exist before assigning values
        dateOfBirth.value = userData.containsKey('dateOfBirth')
            ? userData['dateOfBirth']?.toString() ?? ''
            : '';
        gender.value = userData.containsKey('gender')
            ? userData['gender']?.toString() ?? ''
            : '';
        phoneNumber.value = userData.containsKey('phoneNumber')
            ? userData['phoneNumber']?.toString() ?? ''
            : '';

        // Debug print to check additional data
        print("Additional user data fetched: ${dateOfBirth.value}, ${gender.value}, ${phoneNumber.value}");
      }
    } catch (e) {
      print("Error fetching additional user info: $e");
    }
  }

  // Fetch Chat History
  Future<void> fetchChatHistory() async {
    isFetchingHistory.value = true;
    fetchErrorMessage.value = "";

    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot chatDocs = await _firestore
          .collection('users')
          .doc(uid)
          .collection('ChatSessions')
          .get();

      chatHistory.value = chatDocs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      isFetchingHistory.value = false;
    } catch (e) {
      isFetchingHistory.value = false;
      fetchErrorMessage.value = "Error loading chat history.";
    }
  }

  // Clear User Data
  void clearUserData() {
    userName.value = "";
    email.value = "";
    profileImage.value = "";
    isGoogleSignIn.value = false;
  }

  // Add this function to clear personal info
  void clearPersonalInfo() {
    dateOfBirth.value = '';
    gender.value = '';
    phoneNumber.value = '';
  }

  // Clear Text Fields
  void clearFields() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    confirmPasswordController.clear();
  }

  // Update Profile Image
  Future<void> updateProfileImage(String imageUrl) async {
    profileImage.value = imageUrl;

    // Save to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', imageUrl);
  }

  Future<void> loadProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    profileImage.value = prefs.getString('profileImage') ?? '';
  }

  Future<void> clearProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImage');
  }
}
