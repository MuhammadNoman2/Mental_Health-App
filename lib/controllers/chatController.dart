import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs; // Current session messages
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  // Firestore and Firebase Auth instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Session management variables
  String? sessionId;
  final RxList<List<Message>> chatHistory = <List<Message>>[].obs; // History of all sessions

  /// Start a new session and generate a unique session ID
  void startNewSession() {
    // Save current session to history
    if (messages.isNotEmpty) {
      chatHistory.add(List<Message>.from(messages));
    }
    messages.clear(); // Clear messages for the new session

    // Generate a new session ID
    sessionId = _firestore.collection('users').doc().id;
  }

  /// Add a bot message to the session
  void addBotMessage(String botMessage) {
    final botMessageModel = Message(
      sender: "Gemini",
      message: botMessage,
      time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
    );
    messages.add(botMessageModel);
  }

  /// Save the entire chat session to Firestore
  Future<void> saveSessionToFirestore() async {
    if (sessionId == null || messages.isEmpty) return;

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not authenticated.");

      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('ChatSessions')
          .doc(sessionId);

      final sessionData = {
        "sessionId": sessionId,
        "messages": messages.map((msg) => {
          "sender": msg.sender,
          "message": msg.message,
          "time": msg.time,
        }).toList(),
        "startTime": DateTime.now().toIso8601String(),
        "endTime": null,
      };

      await docRef.set(sessionData, SetOptions(merge: true));
    } catch (e) {
      errorMessage.value = "Error saving session: $e";
    }
  }

  /// End the session and update Firestore with the end time
  Future<void> endSession() async {
    if (sessionId == null) return;

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not authenticated.");

      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('ChatSessions')
          .doc(sessionId);

      await docRef.update({"endTime": DateTime.now().toIso8601String()});
      sessionId = null; // Clear the session ID after ending
    } catch (e) {
      errorMessage.value = "Error ending session: $e";
    }
  }

  /// Send a user message and process the response from Gemini
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) {
      errorMessage.value = "Message cannot be empty.";
      return;
    }

    // Add user's message to the session
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
      // Send user message to Gemini API
      Gemini.instance.prompt(parts: [
        Part.text("Please provide a detailed response (max 100 words) related to '$userMessage' "),
      ]).then((value) async {
        if (value != null) {
          String botResponse = value.output ?? "No response from Gemini";

          // Add bot response to the session
          final botMessageModel = Message(
            sender: "Gemini",
            message: botResponse,
            time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          );
          messages.add(botMessageModel);

          // Save the updated session to Firestore
          await saveSessionToFirestore();
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

  /// Handle mood or category input and start a session
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
}
