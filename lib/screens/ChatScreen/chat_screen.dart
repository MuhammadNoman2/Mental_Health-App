import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chatController.dart';

class ChatScreen extends StatefulWidget {
  final String? mood;
  final String? category;
  final String? emoji;

  const ChatScreen({Key? key, this.mood, this.category, this.emoji}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _controller = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    String initialMessage = _getInitialMessage();

    // Delay the process call to avoid updates during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.processMoodOrCategory(initialMessage);
    });
  }

  @override
  void dispose() {
    _controller.startNewSession();
    super.dispose();
  }

  String _getInitialMessage() {
    if (widget.emoji != null) {
      return widget.emoji!;
    }
    return widget.mood ?? widget.category ?? "I'm feeling okay";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: const Color(0xFFE8F0FE),
        child: SafeArea(
          child: Column(
            children: [
              _buildChatAppBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Mood/Category: ${widget.mood ?? widget.category ?? widget.emoji ?? "None"}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: _buildChatList()),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Gemini",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_sharp),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      if (_controller.messages.isEmpty) {
        return Center(
          child: Text("No messages available."),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.messages.length,
        itemBuilder: (context, index) {
          final message = _controller.messages[index];
          final isSentByMe = message.sender == "You";
          return Align(
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isSentByMe ? 15 : 0),
                  bottomRight: Radius.circular(isSentByMe ? 0 : 15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message.time,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller.messageController,
              decoration: InputDecoration(
                hintText: "Write a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _controller.sendMessage(_controller.messageController.text),
            ),
          ),
        ],
      ),
    );
  }
}
