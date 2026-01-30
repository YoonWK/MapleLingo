//lib/services/stt_handler.dart

import 'dart:async';

// import 'package:flutter/rendering.dart';
import 'package:speech_to_text/speech_to_text.dart';

// ignore: camel_case_types
class SttHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    // debugPrint('Speech recognition initialized: $_speechEnabled');
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    _speechToText.listen(onResult: (result) {
      // debugPrint('Recognized text: ${result.recognizedWords}');
      if (result.finalResult) {
        completer.complete(result.recognizedWords);
      }
    });
    return completer.future;
  }

  Future<void> stopListening() async {
    await speechToText.stop();
  }

  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
}
