import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_application/bloc/chat/chat_bloc.dart';
import 'package:mini_chat_application/bloc/chat/chat_event.dart';
import 'package:mini_chat_application/bloc/chat/chat_state.dart';
import 'package:mocktail/mocktail.dart';
import 'mocks.dart';


void main() {
  late MockUsersBloc usersBloc;
  late MockChatRepository repository;

  setUp(() {
    usersBloc = MockUsersBloc();
    repository = MockChatRepository();
  });

  group('ChatBloc', () {
    blocTest<ChatBloc, ChatState>(
      'emits sender then receiver message when SendMessage is added',
      build: () {
        when(() => repository.fetchRandomMessage())
            .thenAnswer((_) async => 'Reply from API');

        return ChatBloc(
          userName: 'Alice',
          usersBloc: usersBloc,
          repository: repository,
        );
      },
      act: (bloc) => bloc.add(SendMessage('Hi')),
      expect: () => [
        isA<ChatState>().having(
              (state) => state.messages.length,
          'after sender',
          1,
        ),

        isA<ChatState>().having(
              (state) => state.messages.length,
          'after receiver',
          2,
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'adds receiver message after repository response',
      build: () {
        when(() => repository.fetchRandomMessage())
            .thenAnswer((_) async => 'Reply from API');

        return ChatBloc(
          userName: 'Alice',
          usersBloc: usersBloc,
          repository: repository,
        );
      },
      act: (bloc) => bloc.add(SendMessage('Hello')),
      expect: () => [
        isA<ChatState>().having(
              (state) => state.messages.length,
          'after sender',
          1,
        ),

        isA<ChatState>().having(
              (state) => state.messages.length,
          'after receiver',
          2,
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchRandomMessage()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'receiver message is marked as not sender',
      build: () {
        when(() => repository.fetchRandomMessage())
            .thenAnswer((_) async => 'API message');

        return ChatBloc(
          userName: 'Alice',
          usersBloc: usersBloc,
          repository: repository,
        );
      },
      act: (bloc) => bloc.add(SendMessage('Test')),
      expect: () => [
        isA<ChatState>(),
        isA<ChatState>().having(
              (state) => state.messages.last.isSender,
          'receiver message',
          false,
        ),
      ],
    );
  });
}
