import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/chat_model.dart';
import '../../repository/chat_repo.dart';
import '../users/users_bloc.dart';
import '../users/users_event.dart';
import 'chat_event.dart';
import 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String userName;
  final UsersBloc usersBloc;
  final ChatRepository repository;

  ChatBloc({
    required this.userName,
    required this.usersBloc,
    required this.repository,
  }) : super(ChatState.initial()) {
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<ChatState> emit,
      ) async {
    final msg = ChatMessage(
      text: event.text,
      isSender: true,
      time: DateTime.now(),
    );

    usersBloc.add(AddMessage(userName, msg));

    emit(ChatState(messages: [...state.messages, msg]));

    add(ReceiveMessage());
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final text = await repository.fetchRandomMessage();

      final msg = ChatMessage(
        text: text,
        isSender: false,
        time: DateTime.now(),
      );

      usersBloc.add(AddMessage(userName, msg));
      emit(ChatState(messages: [...state.messages, msg]));
    } catch (_) {
      if (kDebugMode) {
        print("error");
      }
    }
  }
}