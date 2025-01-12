class Message {
  final String sender;
  final String message;
  final String time;

  Message({required this.sender, required this.message, required this.time});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] ?? 'Gemini',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'time': time,
    };
  }
}
