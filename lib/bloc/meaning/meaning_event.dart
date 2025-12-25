abstract class MeaningEvent {}

class FetchMeaning extends MeaningEvent {
  final String word;
  FetchMeaning(this.word);
}
