import 'package:mini_chat_application/bloc/users/users_bloc.dart';
import 'package:mini_chat_application/repository/chat_repo.dart';
import 'package:mini_chat_application/repository/meaning_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersBloc extends Mock implements UsersBloc {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockMeaningRepository extends Mock implements MeaningRepository {}