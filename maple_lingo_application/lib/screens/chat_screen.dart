//maple_lingo_application/lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_lingo_application/providers/chats_provider.dart';
import 'package:maple_lingo_application/widgets/chat_item.dart';
import 'package:maple_lingo_application/widgets/my_app_bar.dart';
import 'package:maple_lingo_application/widgets/text_and_voice_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final chats = ref.watch(chatsProvider);
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) => ChatItem(
                  text: chats[index].message,
                  isMe: chats[index].isMe,
                ),
              );
            }),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextAndVoiceField(),
          ),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }
}
