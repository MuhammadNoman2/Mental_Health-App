import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../models/message.dart';

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  // Chat history for all sessions
  final RxList<List<Message>> chatHistory = <List<Message>>[].obs;

  // Process mood or category and start a new session
  void processMoodOrCategory(String userInput) {
    String initialMessage = "";

    switch (userInput) {
      case "Relationship":
        initialMessage = "How can I help you in your relationship?";
        break;
      case "Career":
        initialMessage = "How can I assist you with your career?";
        break;
      case "Education":
        initialMessage = "How can I support you in your education?";
        break;
      case "Other":
        initialMessage = "How can I help you with your situation?";
        break;
      case "Badly":
        initialMessage = "Oh sorry to hear that you're sad today. Nothing to worry, I am here to help. Tell me how I can make you happy.";
        break;
      case "Fine":
        initialMessage = "That's great to hear! I'm happy you're feeling good today. What can I help you with?";
        break;
      case "Well":
        initialMessage = "You're feeling at ease. That's wonderful! How can I support you today?";
        break;
      case "Angry":
        initialMessage = "It seems like you're upset. I'm here to listen. Let's talk about what’s bothering you.";
        break;
      case "Excellent":
        initialMessage = "That's great to hear! I'm happy you're feeling excellent today. How can I support you today?";
        break;
      default:
        initialMessage = "How can I assist you today?";
    }

    startNewSession();
    addBotMessage(initialMessage);
  }

  // Start a new session and save the previous one
  void startNewSession() {
    if (messages.isNotEmpty) {
      chatHistory.add(List<Message>.from(messages));
    }
    messages.clear();
  }

  // Add a bot message
  void addBotMessage(String botMessage) {
    final botMessageModel = Message(
      sender: "Gemini",
      message: botMessage,
      time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
    );
    messages.add(botMessageModel);
  }

  // Send a user message and fetch a response from Gemini
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) {
      errorMessage.value = "Message cannot be empty.";
      return;
    }

    final userMessageModel = Message(
      sender: "You",
      message: userMessage,
      time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
    );
    messages.add(userMessageModel);

    messageController.clear();
    isLoading.value = true;
    errorMessage.value = "";

    try {
      Gemini.instance.prompt(parts: [
        Part.text("Please provide a detailed response (max 100 words) related to '$userMessage'. Keep it focused on the context."),
      ]).then((value) {
        if (value != null) {
          String botResponse = value.output ?? "No response from Gemini";

          final botMessageModel = Message(
            sender: "Gemini",
            message: botResponse,
            time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          );
          messages.add(botMessageModel);
        } else {
          errorMessage.value = "No response from Gemini.";
        }
      });
    } catch (e) {
      errorMessage.value = "Failed to connect to Gemini: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
