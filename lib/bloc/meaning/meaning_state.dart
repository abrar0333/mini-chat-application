abstract class MeaningState {}

class MeaningInitial extends MeaningState {}

class MeaningLoading extends MeaningState {}

class MeaningLoaded extends MeaningState {
  final String meaning;
  MeaningLoaded(this.meaning);
}

class MeaningError extends MeaningState {
  final String message;
  MeaningError(this.message);
}
