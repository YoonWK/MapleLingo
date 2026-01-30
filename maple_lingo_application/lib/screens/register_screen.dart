//maple_lingo_application/lib/screens/register_screen.dart


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:maple_lingo_application/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final logger = Logger();

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();

  String _registrationStatus = "";
  String _errorMessage = "";
  final apiUrl = 'http://10.0.2.2/maplelingo_api/addUser.php';

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'user_name': _userNameController.text,
            'user_email': _userEmailController.text,
            'user_password': _userPasswordController.text,
          },
        );

        if (response.statusCode == 200) {
          // Handle successful registration
          final responseData = jsonDecode(response.body);
          if (responseData['success'] != null) {
            // Show success message and potentially navigate to login screen
            setState(() {
              _registrationStatus = "Registration successful!";
            });
            // Navigate to Login Screen after a short delay
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            });
          } else {
            // Handle unexpected success response (shouldn't happen ideally)
            setState(() {
              _errorMessage = "An unexpected error occurred.";
            });
          }
        } else {
          // Handle registration failure
          final responseData = jsonDecode(response.body);
          if (responseData['error'] != null) {
            setState(() {
              _errorMessage = responseData['error'];
            });
          } else {
            // Handle unexpected error response
            setState(() {
              _errorMessage = "An error occurred during registration.";
            });
          }
        }
      } catch (error) {
        // Handle network error or other exceptions
        setState(() {
          _errorMessage = "Network error or other issue occurred.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userEmailController,
                decoration: const InputDecoration(
                  labelText: 'User Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
