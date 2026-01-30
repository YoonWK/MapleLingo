//maple_lingo_application/lib/screens/edit_profile.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maple_lingo_application/main.dart';

class EditProfileScreen extends StatefulWidget {
  final String user_id;

  const EditProfileScreen({super.key, required this.user_id});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _user_name, _user_email;

  @override
  void initState() {
    super.initState();
    // Fetch user data here (implementation depends on your backend)
    // Replace with your logic to retrieve user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _user_name,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                // Add additional validation for username format if needed
                return null;
              },
              onSaved: (value) => _user_name = value,
            ),
            TextFormField(
              initialValue: _user_email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                // Add email validation (e.g., email format)
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-z0-9_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                    .hasMatch(value);
                return emailValid ? null : 'Please enter a valid email';
              },
              onSaved: (value) => _user_email = value,
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        const apiUrl = 'http://10.0.2.2/maplelingo_api/editAndUpdateUser.php';
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'user_id': widget.user_id,
            'user_name': _user_name,
            'user_email': _user_email,
          },
        );

        if (response.statusCode == 200) {
          // Check response body for success message
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            // Update successful
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Your information has been updated successfully!'),
              ),
            );
            Navigator.pushReplacementNamed(
              context,
              profileRoute,
              arguments: {'user_id': widget.user_id},
            );
          } else {
            // Update failed (check for error message in response)
            String errorMessage = responseData['error'] ?? "Update failed.";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
              ),
            );
          }
        } else {
          // Handle non-200 status code
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Update failed. Error code: ${response.statusCode}'),
            ),
          );
        }
      } catch (error) {
        // Handle network error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error. Please check your connection.'),
          ),
        );
      }
    }
  }
}
