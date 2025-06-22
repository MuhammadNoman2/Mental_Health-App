import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
            child: Obx(() => Image.asset(
              _controller.selectedAI.value == "Gemini"
                  ? 'assets/images/img_8.png'
                  : 'assets/images/your_psychologist.png',
            ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => Text(
              _controller.selectedAI.value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
              onSelected: (String ai) {
                _controller.selectedAI.value = ai;
                _controller.messages.clear(); // Clear chat when switching AI
                _controller.startNewSession(); // Reset session
              },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Gemini',
                child: Text('Gemini AI'),
              ),
              const PopupMenuItem(
                value: 'Your Psychologist',
                child: Text('Your Psychologist'),
              ),
            ],
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
          final isFromTriotech = message.sender == "Your Psychologist";

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                  _formatMessageTime(message.time),
                        style: TextStyle(
                          color: isSentByMe ? Colors.white70 : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // Show solution button only for Triotech AI
                      if (isFromTriotech)
                        TextButton.icon(
                          onPressed: () async {
                            final solution = await _controller.getTriotechSolution();

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Suggested Solution"),
                                content: SingleChildScrollView(
                                  child: MarkdownBody(
                                    data: solution,
                                    styleSheet: MarkdownStyleSheet(
                                      h1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      p: TextStyle(fontSize: 14, height: 1.5),
                                      strong: TextStyle(fontWeight: FontWeight.w600),
                                      blockquote: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(Icons.lightbulb_outline, size: 16, color: Colors.deepPurple),
                          label: Text(
                            "View Solution",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                    ],
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
  String _formatMessageTime(String rawTime) {
    try {
      // If the time is only in "HH:mm" format (like "14:17")
      if (rawTime.contains(":")) {
        // Adding the current date to make it a full datetime
        final now = DateTime.now();
        final fullDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $rawTime';
        final dateTime = DateTime.parse(fullDate); // Parsing the combined date and time
        return DateFormat('hh:mm a').format(dateTime); // Format as 12-hour time with AM/PM
      }

      // If the format is something else (e.g., full datetime), handle that here
      final dateTime = DateTime.parse(rawTime);
      return DateFormat('hh:mm a').format(dateTime);

    } catch (e) {
      return rawTime; // Return original time if format error occurs
    }
  }

}
