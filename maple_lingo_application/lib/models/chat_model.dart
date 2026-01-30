//lib/models/chat_model.dart

import 'package:flutter/material.dart';

@immutable
class ChatModel {
  final String id;
  final String message;
  final bool isMe;

  const ChatModel({
    required this.id,
    required this.message,
    required this.isMe,
  });
}

// class MessageModel {
//   final String messageId;
//   final String conversationId;
//   final String userId;
//   final String content;
//   final DateTime timestamp;
//   final bool isUserMessage;

//   const MessageModel({
//     required this.messageId,
//     required this.conversationId,
//     required this.userId,
//     required this.content,
//     required this.timestamp,
//     required this.isUserMessage,
//   });

//   // Additional methods for message-related functionalities (optional)
//   // e.g., sending/receiving messages

//   @override
//   String toString() => 'MessageModel(messageId: $messageId, conversationId: $conversationId, userId: $userId, content: $content, timestamp: $timestamp, isUserMessage: $isUserMessage)';
// }
