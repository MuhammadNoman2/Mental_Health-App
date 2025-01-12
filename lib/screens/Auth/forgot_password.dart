import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/theme/colors.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_form_fields.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Get.isDarkMode
                ? [darkGradientStart, darkGradientEnd]
                : [lightGradientStart, lightGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: Icon(
                      Icons.punch_clock_sharp,
                      size: 50,
                      color: Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Heading
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your registered email to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Get.isDarkMode
                          ? Colors.grey[300]
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email Form Field
                  CustomFormField(
                    controller: emailController,
                    hintText: 'Email Address',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  // Submit Button
                  CustomButton(
                    text: 'Send Reset Link',
                    onPressed: () {
                      // Handle Forgot Password functionality
                    },
                  ),
                  const SizedBox(height: 20),
                  // Back to Login
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color:
                        Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
