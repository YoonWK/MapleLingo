//lib/providers/chat_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_lingo_application/models/chat_model.dart';

class ChatNotifier extends StateNotifier<List<ChatModel>> {
  ChatNotifier() : super([]);

  void addMessage(ChatModel chatModel) {
    state = [...state, chatModel];
  }

  void removeTyping() {
    state = state..removeWhere((chat) => chat.id == 'typing');
  }
}

final chatsProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>(
  (ref) => ChatNotifier(),
);
