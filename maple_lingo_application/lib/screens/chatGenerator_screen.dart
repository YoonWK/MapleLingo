//maple_lingo_application/lib/screens/chatGenerator_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maple_lingo_application/models/conversation_model.dart';

import 'package:http/http.dart' as http;
import 'package:maple_lingo_application/widgets/bottom_navigation_bar.dart';
import 'dart:convert';

import 'package:maple_lingo_application/widgets/list_divider.dart';

class ChatGeneratorScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String user_id;

  // ignore: non_constant_identifier_names
  const ChatGeneratorScreen({super.key, required this.user_id});

  @override
  State<ChatGeneratorScreen> createState() => _ChatGeneratorScreenState();
}

class _ChatGeneratorScreenState extends State<ChatGeneratorScreen> {
  late List<ConversationModel> conversations = [];

  @override
  void initState() {
    super.initState();
    _getConversations(); // Fetch conversations on initial load
  }

  Future<void> _deleteConversation(String conversationId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this conversation?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      const apiUrl = 'http://10.0.2.2/maplelingo_api/deleteConversation.php';
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'conversation_id': conversationId.toString()},
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            // Conversation deleted successfully
            conversations.removeWhere((conversation) =>
                conversation.conversation_id == conversationId);
            setState(() {}); // Update UI with removed conversation
            print('Conversation deleted successfully!');
          } else {
            // Handle failed conversation deletion
            print('Failed to delete conversation: ${responseData['message']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Failed to delete conversation: ${responseData['message']}'),
              ),
            );
          }
        } catch (error) {
          // Handle JSON parsing error
          print('Error parsing conversation data: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred while deleting conversation.'),
            ),
          );
        }
      } else {
        // Handle network error
        print(
            'Network error while deleting conversation: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error while deleting conversation.'),
          ),
        );
      }
    }
  }

  Future<void> _getConversations() async {
    const apiUrl = 'http://10.0.2.2/maplelingo_api/getConversation.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': widget.user_id},
    );

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          conversations = (responseData['conversations'] as List)
              .map((conversation) => ConversationModel.fromJson(conversation))
              .toList();
          setState(() {}); // Update UI with new conversations
        } else {
          // Handle failed conversation retrieval
          print('Failed to retrieve conversations: ${responseData['message']}');
        }
      } catch (error) {
        // Handle JSON parsing error
        print('Error parsing conversation data: $error');
      }
    } else {
      // Handle network error
      print(
          'Network error while fetching conversations: ${response.statusCode}');
    }
  }

  void _addConversation(
      String conversation_name, String conversation_language) async {
    const apiUrl = 'http://10.0.2.2/maplelingo_api/addConversation.php';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'user_id': widget.user_id,
      'conversation_name': conversation_name,
      'conversation_language': conversation_language,
    });

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Conversation added successfully
          _getConversations(); // Refresh conversation list
          print('Conversation added successfully!');
        } else {
          // Handle failed conversation addition
          print('Failed to add conversation: ${responseData['message']}');
        }
      } catch (error) {
        // Handle JSON parsing error
        print('Error parsing conversation data: $error');
      }
    } else {
      // Handle network error
      print('Network error while adding conversation: ${response.statusCode}');
    }
  }

  void _showAddConversationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        String conversation_name = '';
        String conversation_language = 'English'; // Set default language

        return AlertDialog(
          title: const Text("Add Conversation"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Conversation Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a conversation name';
                    }
                    return null;
                  },
                  onSaved: (value) => conversation_name = value!,
                ),
                DropdownButtonFormField<String>(
                  value: conversation_language,
                  decoration: const InputDecoration(
                    labelText: "Language",
                  ),
                  items: [
                    'English',
                    'Chinese',
                    'Malay',
                    'Japanese',
                  ]
                      .map((String language) => DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          ))
                      .toList(),
                  onChanged: (String? newLanguage) {
                    setState(() {
                      conversation_language = newLanguage!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addConversation(conversation_name, conversation_language);
                  Navigator.pop(context); // Close dialog after adding
                }
              },
              child: const Text("Add Conversation"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, // Remove shadow effect
        leading: const SizedBox(),
        title: const Text('Conversation List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddConversationDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return Column(
                  children: [
                    PrimaryColorDivider(),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            'Conversation Name:  ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            conversation.conversation_name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'Learning:  ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            conversation.conversation_language,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteConversation(conversation.conversation_id),
                      ),
                      // Add functionality to navigate to conversation screen based on conversation ID
                      tileColor: Theme.of(context).canvasColor,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ), // Optional spacing between list items
                    PrimaryColorDivider(),
                  ],
                );
              },
            ),
          ),
          BottomNavigationBarWidget(
            user_id: widget.user_id,
            currentIndex: 1, // Set initial selected item (Profile)
          ),
        ],
      ),
    );
  }
}
