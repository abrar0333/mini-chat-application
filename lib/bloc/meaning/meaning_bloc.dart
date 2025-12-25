import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/meaning_repo.dart';
import 'meaning_event.dart';
import 'meaning_state.dart';


class MeaningBloc extends Bloc<MeaningEvent, MeaningState> {
  final MeaningRepository repository;

  MeaningBloc(this.repository) : super(MeaningInitial()) {
    on<FetchMeaning>(_onFetchMeaning);
  }

  Future<void> _onFetchMeaning(
      FetchMeaning event,
      Emitter<MeaningState> emit,
      ) async {
    emit(MeaningLoading());
    try {
      final meaning = await repository.fetchMeaning(event.word);
      emit(MeaningLoaded(meaning));
    } catch (_) {
      emit(MeaningError("Meaning not found"));
    }
  }
}
