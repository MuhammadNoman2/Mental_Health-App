import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/controllers/authController.dart';
import 'package:mental_health_app/screens/Auth/login.dart';
import 'package:mental_health_app/screens/Home/dashboard.dart';
import 'package:mental_health_app/utils/theme/colors.dart';
import 'package:mental_health_app/utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_form_fields.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
final AuthController authController = Get.put(AuthController());
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Get.isDarkMode
                ? [darkGradientStart, darkGradientEnd]
                : [lightGradientStart, lightGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // App Logo
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(
                    Icons.self_improvement_rounded,
                    size: 50,
                    color: Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Join us today and take your first \n step towards mental health.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                Container( margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Get.isDarkMode
                            ? Colors.black.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomFormField(
                        controller: authController.fullNameController,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.emailAddress,
                      ),
            
                const SizedBox(height: 20),
                      CustomFormField(
                        controller: authController.emailController,
                        hintText: 'Email Address',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                const SizedBox(height: 20),
                CustomFormField(
                  controller: authController.passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: _isPasswordHidden,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: authController.confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock,
                  obscureText: _isPasswordHidden,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    authController.signUpUser();
                  }, isLoading: authController.isLoading.value,

                ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginScreen());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
