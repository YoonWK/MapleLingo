//lib/services/ai_handler.dart

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

class AIHandler {
  var logger = Logger(printer: PrettyPrinter(), level: Level.debug);

  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
    // connectTimeout: const Duration(seconds: 60)),
  );

  Future<String> getResponse(String message) async {
    try {
      // Create the ChatCompleteText request
      final request = ChatCompleteText(
        messages: [
          Map.of({"role": "user", "content": message})
        ],
        maxToken: 200,
        model: GptTurboChatModel(),
      );

      // Listen for the AI response using onChatCompletionSSE
      final responseStream = _openAI.onChatCompletionSSE(request: request);

      // Handle potential errors during stream processing
      final responses = await responseStream.handleError((error) {
        logger.e('Error getting AI response: $error');
        return Stream.empty(); // Return an empty stream (safer)
      }).toList(); // Collect all responses into a list

      // Log if there are any responses
      if (responses.isNotEmpty) {
        logger.i('Received ${responses.length} AI responses.');
      } else {
        logger.w('No AI responses received.');
      }

      // Find the first non-empty response and extract the last message content
      final nonEmptyResponse = responses
          .firstWhere((response) => response.choices?.isNotEmpty == true);
      final content = nonEmptyResponse?.choices?.last?.message?.content ??
          'No content available';

      return content;
    } catch (e) {
      // Log any unhandled exceptions
      logger.e('Unexpected error: $e');
      return 'Bad response: $e';
    }
  }
}
