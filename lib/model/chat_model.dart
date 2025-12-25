class ChatMessage {
  final String text;
  final bool isSender;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isSender,
    required this.time,
  });
}

class ChatSession {
  final String userName;
  final List<ChatMessage> messages;

  ChatSession({
    required this.userName,
    required this.messages,
  });

  ChatMessage? get lastMessage =>
      messages.isNotEmpty ? messages.last : null;
}