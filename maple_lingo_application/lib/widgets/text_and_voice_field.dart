//lib/widgets/text_and_voice_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_lingo_application/models/chat_model.dart';
import 'package:maple_lingo_application/providers/chats_provider.dart';
import 'package:maple_lingo_application/services/ai_handler.dart';
import 'package:maple_lingo_application/services/stt_handler.dart';
import 'package:maple_lingo_application/widgets/toggle_button.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _assistant = AIHandler();
  final SttHandler sttHandler = SttHandler();
  FlutterTts flutterTts = FlutterTts();
  var _isReplying = false;

  @override
  void initState() {
    sttHandler.initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 06,
        ),
        ToggleButton(
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageController.text;
            _messageController.clear();
            sendTextMessage(message);
          },
          sendVoiceMessage: sendVoiceMessage,
        )
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('Typing...', false, 'typing');
    setInputMode(InputMode.voice);

    // Update getResponse call
    final aiResponse = await _assistant.getResponse(message,
        PromptType.initial); // Assuming initial prompt for text messages

    // Speak the AI response (optional)
    await flutterTts.speak(aiResponse);

    removeTyping();
    addToChatList(aiResponse, false, DateTime.now().toString());
    setReplyingState(false);
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatsProvider.notifier);
    chats.removeTyping();
  }

  void sendVoiceMessage() async {
    if (sttHandler.speechToText.isListening) {
      await sttHandler.stopListening();
    } else {
      final result = await sttHandler.startListening();
      final recognizedText = result;
      sendTextMessage(recognizedText); // Pass recognized text
    }
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.addMessage(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
    ));
  }
}
