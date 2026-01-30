//maple_lingo_application/lib/models/conversation_model.dart

class ConversationModel {
  final String conversation_id;
  final String conversation_language;
  final String conversation_name;
// Optional

  const ConversationModel({
    required this.conversation_id,
    required this.conversation_language,
    required this.conversation_name,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        conversation_id: json['conversation_id'],
        conversation_name: json['conversation_name'],
        conversation_language: json['conversation_language'],
      );
}
