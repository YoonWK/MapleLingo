//lib/services/ai_handler.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

enum PromptType { initial, followUp }

class AIHandler {
  late String language;
  late String _initialPrompt;

  final String apiKey = 'my api key';

  AIHandler() {
    language = "English";
    _initialPrompt = """
    This is an English vocabulary practice session. I will provide you with a word and its pronunciation in phonetic spelling within parentheses. Please try to pronounce the word and then respond with it. If you get stuck, don't worry, I'll provide hints and ask you to try again. If you pronounce the word correctly I will congratulate you. Let's begin!
    """;
  }

  Future<String> getResponse(String message, PromptType type) async {
    try {
      const url = 'https://api.openai.com/v1/chat/completions';
      const method = 'POST';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final body = {
        'model': 'gpt-3.5-turbo',
        'messages': [
          if (type == PromptType.initial)
            {'role': 'assistant', 'content': _initialPrompt},
          if (type == PromptType.followUp)
            // Follow-up prompt content using previous conversation (implementation needed)
            {
              'role': 'assistant',
              'content': message
            }, //CHANGE:follow up prompt will soon be stored in firebase then the chat history will be here instead
        ],
        //'temperature': 0.2,
      };

      final response = await _sendRequest(url, method, headers, body: body);
      return _handleResponse(response);
    } catch (e) {
      print('Error during AI interaction: $e');
      return 'An error occurred. Please try again later.';
    }
  }

  // Defines the logic for sending HTTP requests
  Future<http.Response> _sendRequest(
      String url, String method, Map<String, String> headers,
      {dynamic body}) async {
    final uri = Uri.parse(url);
    switch (method.toLowerCase()) {
      case 'post':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  String _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final choices = responseBody['choices'] as List;
      if (choices.isNotEmpty) {
        final firstChoice = choices[0];
        final aiResponse = firstChoice['message']['content'].trim();
        return aiResponse;
      } else {
        print('No choices found in response');
        return 'The AI did not generate a response.';
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'An error occurred. Please try again later.';
    }
  }
}
