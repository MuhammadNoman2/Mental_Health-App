import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/screens/Auth/forgot_password.dart';
import 'package:mental_health_app/screens/Auth/sign_up.dart';
import 'package:mental_health_app/screens/Home/dashboard.dart';
import 'package:mental_health_app/utils/theme/colors.dart';
import 'package:mental_health_app/utils/widgets/custom_button.dart';
import '../../controllers/authController.dart';
import '../../utils/widgets/custom_form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

              children: [
                SizedBox(height: 20),
                // App Logo
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(
                    Icons.self_improvement_rounded,
                    size: 75,
                    color: Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),
                // Form Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            _isPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ForgotPasswordScreen());
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.tealAccent
                                  : Colors.teal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Obx(() => authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : CustomButton(
                        onPressed: authController.handleLogin,

                        isLoading: false, // `CustomButton` handles its loading internally if needed
                        text: 'LOGIN',
                      ),
                      ),
                      const SizedBox(height: 12),

                      Obx(() => authController.isGoogleLoading.value
                          ? const CircularProgressIndicator()
                          : CustomButton(
                        icon: Icons.g_mobiledata,
                        onPressed: authController.handleGoogleLogin,
                        isLoading: false, // `CustomButton` handles its loading internally if needed
                        text: 'Login with Google',
                      ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Sign Up and Guest Options
                GestureDetector(
                  onTap: () {
                    Get.to(SignupScreen());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: TextStyle(
                        color:
                        Get.isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.tealAccent
                                : Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(DashboardScreen());
                  },
                  child: Text(
                    'Continue as Guest',
                    style: TextStyle(
                      fontSize: 16,
                      color: Get.isDarkMode ? Colors.tealAccent : Colors.teal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
