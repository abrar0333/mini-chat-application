import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatRepository {
  Future<String> fetchRandomMessage();
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<String> fetchRandomMessage() async {
    final res = await http.get(
      Uri.parse("https://dummyjson.com/quotes/random"),
    );

    final data = jsonDecode(res.body);
    return data['quote'];
  }
}