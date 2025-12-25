import '../../model/chat_model.dart';

abstract class UsersEvent {}

class AddUser extends UsersEvent {
  final String name;
  AddUser(this.name);
}

class AddMessage extends UsersEvent {
  final String userName;
  final ChatMessage message;

  AddMessage(this.userName, this.message);
}