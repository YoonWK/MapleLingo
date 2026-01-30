//maple_lingo_application/lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maple_lingo_application/main.dart';
import 'package:maple_lingo_application/models/user_model.dart';
import 'package:maple_lingo_application/widgets/bottom_navigation_bar.dart';
import 'dart:convert';

import 'package:maple_lingo_application/widgets/navigator_drawer.dart'
    as CustomDrawer;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user_id});

  final String user_id;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String user_name, user_email;
  bool isLoading = false;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    setState(() => isLoading = true);
    const apiUrl = 'http://10.0.2.2/maplelingo_api/getCurrentUser.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': widget.user_id},
    );

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] != null && responseData['success']) {
          user = UserModel.fromJson(responseData['user']);
          user_name = user.user_name;
          user_email = user.user_email;
          setState(() => isLoading = false);
        } else {
          // Handle unsuccessful user data retrieval
          setState(() {
            isLoading = false;
            user_name = "Error retrieving data";
            user_email = "";
          });
        }
      } catch (error) {
        // Handle JSON parsing error
        setState(() {
          isLoading = false;
          user_name = "Error parsing data";
          user_email = "";
        });
      }
    } else {
      // Handle network error
      setState(() {
        isLoading = false;
        user_name = "Network error";
        user_email = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer.NavigationDrawer(
        user_id: widget.user_id,
        scaffoldKey: _scaffoldKey,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    // Align "Username:" and "Email:" with their values
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'User Name:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(user_name),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(user_email),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Add additional profile information or buttons here (optional)
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBarWidget(
        user_id: widget.user_id,
        currentIndex: 0, // Set initial selected item (Profile)
      ),
    );
  }
}
