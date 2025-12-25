import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_application/bloc/meaning/meaning_bloc.dart';
import 'package:mini_chat_application/bloc/meaning/meaning_event.dart';
import 'package:mini_chat_application/bloc/meaning/meaning_state.dart';
import 'package:mocktail/mocktail.dart';
import 'mocks.dart';


void main() {
  late MockMeaningRepository repository;

  setUp(() {
    repository = MockMeaningRepository();
  });

  group('MeaningBloc', () {
    blocTest<MeaningBloc, MeaningState>(
      'emits [MeaningLoading, MeaningLoaded] when fetchMeaning succeeds',
      build: () {
        when(() => repository.fetchMeaning('hello'))
            .thenAnswer((_) async => 'a greeting');

        return MeaningBloc(repository);
      },
      act: (bloc) => bloc.add(FetchMeaning('hello')),
      expect: () => [
        isA<MeaningLoading>(),
        isA<MeaningLoaded>().having(
              (state) => state.meaning,
          'meaning',
          'a greeting',
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchMeaning('hello')).called(1);
      },
    );

    blocTest<MeaningBloc, MeaningState>(
      'emits [MeaningLoading, MeaningError] when repository throws',
      build: () {
        when(() => repository.fetchMeaning('asdfgh'))
            .thenThrow(Exception('Not found'));

        return MeaningBloc(repository);
      },
      act: (bloc) => bloc.add(FetchMeaning('asdfgh')),
      expect: () => [
        isA<MeaningLoading>(),
        isA<MeaningError>().having(
              (state) => state.message,
          'error message',
          'Meaning not found',
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchMeaning('asdfgh')).called(1);
      },
    );
  });
}