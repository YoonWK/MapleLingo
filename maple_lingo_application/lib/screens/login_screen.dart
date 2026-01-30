//maple_lingo_application/lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maple_lingo_application/screens/profile_screen.dart';
import 'dart:convert';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();

  late String user_email, user_password, errormsg;
  bool error = false, showprogress = false;

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _userEmailController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user_email = "";
    user_password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    super.initState();
  }

  startLogin() async {
    String apiurl = "http://10.0.2.2/maplelingo_api/login.php";

    setState(() => showprogress = true);

    try {
      var response = await http.post(Uri.parse(apiurl), body: {
        "user_email": _userEmailController.text,
        "user_password": _userPasswordController.text
      });

      if (response.statusCode == 200) {
        try {
          var jsondata = json.decode(response.body);

          // Ensure both "error" and "success" keys are present and boolean
          if (jsondata.containsKey("error") &&
              jsondata.containsKey("success")) {
            bool parsedError = jsondata["error"];
            bool parsedSuccess = jsondata["success"];

            setState(() {
              showprogress = false;
              error = parsedError;

              if (parsedError) {
                errormsg = jsondata["message"];
              } else if (parsedSuccess) {
                // Successful login logic
                String userId = jsondata["user_id"];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user_id: userId),
                  ),
                );
              } else {
                error = true;
                errormsg = "Unexpected server error";
              }
            });
          } else {
            setState(() {
              showprogress = false;
              error = true;
              errormsg = "Invalid server response";
            });
          }
        } catch (e) {
          setState(() {
            showprogress = false;
            error = true;
            errormsg = "Error parsing JSON response: ${e.toString()}";
          });
        }
      } else {
        setState(() {
          showprogress = false;
          error = true;
          errormsg = "Connection Error";
        });
      }
    } catch (e) {
      setState(() {
        showprogress = false;
        error = true;
        errormsg = "Unexpected error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  user_email = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Password input field
            TextField(
              controller: _userPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  user_password = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Login button
            ElevatedButton(
              onPressed: startLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Login",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            const SizedBox(height: 20),

            // Create Account button
            TextButton(
              onPressed: () {
                // Navigate to register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // Error message if any
            if (error)
              Text(
                errormsg,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
