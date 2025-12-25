import '../../model/chat_model.dart';

class ChatState {
  final List<ChatMessage> messages;

  ChatState({required this.messages});

  factory ChatState.initial() {
    return ChatState(messages: []);
  }
}