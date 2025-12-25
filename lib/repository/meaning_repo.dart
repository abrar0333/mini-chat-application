import 'dart:convert';
import 'package:http/http.dart' as http;


abstract class MeaningRepository {
  Future<String> fetchMeaning(String word);
}

class MeaningRepositoryImpl implements MeaningRepository {
  @override
  Future<String> fetchMeaning(String word) async {
    final res = await http.get(
      Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/$word",
      ),
    );

    final data = jsonDecode(res.body);
    return data[0]['meanings'][0]['definitions'][0]['definition'];
  }
}