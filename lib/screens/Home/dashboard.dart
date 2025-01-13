import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/screens/Profile/profile.dart';
import 'package:mental_health_app/screens/Wellness/wellness_screen.dart';

import '../../controllers/chatController.dart';
import '../../services/userService.dart';
import '../ChatScreen/chat_screen.dart';

class DashboardScreen extends StatefulWidget {


  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserController userController = Get.put(UserController());

  String getFormattedDateTime() {
    final DateTime now = DateTime.now();
    return DateFormat("dd-MMM-yy , HH:mm").format(now);
  }

  int _selectedIndex = 0;
  String _selectedMood = "Excellent";

  final List<String> _moods = ["Badly", "Fine", "Well", "Angry", "Excellent"];
  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied_sharp,
    Icons.sentiment_neutral_outlined,
    Icons.mood_bad_outlined,
    Icons.sentiment_satisfied_sharp,
    Icons.sentiment_very_satisfied_sharp,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Get.to(() => ChatScreen());
        break;
      case 2:
        Get.to(() => WellnessScreen());
        break;
      case 3:
        Get.to(() => ProfileScreen());
        break;
      default:
        DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFE8F0FE),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),
              _buildMoodSelector(),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              Expanded(child: _buildChatHistory()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Hi, ${userController.userName.value}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                getFormattedDateTime(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How do you feel?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = _moods[index];
                  });
                  Get.to(() => ChatScreen(mood: _moods[index]));
                },
                child: Column(
                  children: [
                    Icon(
                      _moodIcons[index],
                      size: 40,
                      color: _selectedMood == _moods[index]
                          ? Colors.blue
                          : Colors.brown,
                    ),
                    Text(
                      _moods[index],
                      style: TextStyle(
                        color: _selectedMood == _moods[index]
                            ? Colors.blue
                            : Colors.brown,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final List<Map<String, String>> categories = [
      {"label": "Relationship", "color": "0xFFFEF5D3"},
      {"label": "Career", "color": "0xFFD9F6E7"},
      {"label": "Education", "color": "0xFFFCE4F6"},
      {"label": "Other", "color": "0xFFE0E7FE"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ChatScreen(category: category["label"]!));
                },
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(int.parse(category["color"]!)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      category["label"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistory() {
    final UserController _controller = Get.put(UserController());

    // Fetch chat history when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchChatHistory();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Chat History",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (_controller.isFetchingHistory.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.fetchErrorMessage.value.isNotEmpty) {
              return Center(
                child: Text(
                  _controller.fetchErrorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (_controller.chatHistory.isEmpty) {
              return const Center(
                child: Text(
                  "No chat history available.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.chatHistory.length,
              itemBuilder: (context, sessionIndex) {
                final session = _controller.chatHistory[sessionIndex];
                final messages = session['messages'] as List<dynamic>;

                return GestureDetector(
                  onTap: () {
                    // Navigate to chat screen with specific conversation/session
                    Get.toNamed('/chat', arguments: {
                      'sessionIndex': sessionIndex,
                      'messages': messages,
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session ${sessionIndex + 1}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Iterate through the messages and return a Widget list
                        ...messages.map((message) {
                          final userMessage = message['message'] ?? "No user message";
                          final sender = message['sender'] ?? "Unknown";
                          final time = message['time'] ?? "No time";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$sender ($time): $userMessage",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                            ],
                          );
                        }).toList(), // Convert the iterable to a list of widgets
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wellness"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
