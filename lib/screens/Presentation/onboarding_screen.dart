import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/screens/Auth/login.dart';
import 'package:mental_health_app/utils/theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/img.png',
      'text': 'Connect with your inner self.\nDiscover the power of self-awareness and mindfulness.',
    },
    {
      'image': 'assets/images/img_1.png',
      'text': 'Find peace and clarity.\nLet us guide you towards mental tranquility and focus.',
    },
    {
      'image': 'assets/images/img_2.png',
      'text': 'We are here to help you!\nTogether, we overcome the challenges of mental stress.',
    },
    {
      'image': 'assets/images/img_5.png',
      'text': 'Your journey matters.\nStart today, for a brighter and healthier tomorrow.',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _onboardingData[index]['image']!,
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _onboardingData[index]['text']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? (Get.isDarkMode ? Colors.white : Colors.black)
                      : (Get.isDarkMode ? Colors.grey : Colors.grey[400]),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentIndex == _onboardingData.length - 1) {
                    // Navigate to the next screen
                    Get.to(LoginScreen());
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Get.isDarkMode ? Colors.teal[200] : Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _currentIndex == _onboardingData.length - 1
                      ? 'Start'
                      : 'Next',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
