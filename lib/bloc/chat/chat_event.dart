abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String text;
  SendMessage(this.text);
}

class ReceiveMessage extends ChatEvent {}