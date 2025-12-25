import 'package:mini_chat_application/bloc/users/users_event.dart';
import 'package:mini_chat_application/bloc/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/chat_model.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersState([])) {
    on<AddUser>((event, emit) {
      emit(
        UsersState([
          ...state.chats,
          ChatSession(userName: event.name, messages: []),
        ]),
      );
    });

    on<AddMessage>((event, emit) {
      final updated = state.chats.map((chat) {
        if (chat.userName == event.userName) {
          return ChatSession(
            userName: chat.userName,
            messages: [...chat.messages, event.message],
          );
        }
        return chat;
      }).toList();

      emit(UsersState(updated));
    });
  }
}