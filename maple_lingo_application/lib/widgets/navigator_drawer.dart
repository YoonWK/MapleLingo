//maple_lingo_application/lib/widgets/navigator_drawer.dart

import 'package:flutter/material.dart';
import 'package:maple_lingo_application/screens/edit_profile.dart';
import 'package:http/http.dart' as http;

class NavigationDrawer extends StatelessWidget {
  final String user_id;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavigationDrawer(
      {super.key, required this.user_id, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Set drawer width to a reasonable value (e.g., 0.60 of screen width)
      width: MediaQuery.of(context).size.width * 0.60,
      child: ListView(
        // Remove padding for a cleaner look (optional)
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(''),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user_id: user_id),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Profile'),
            onTap: () => _showDeleteConfirmationDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text(
              'Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Send delete request to deleteUser.php
                const apiUrl = 'http://10.0.2.2/maplelingo_api/deleteUser.php';
                final response = await http.post(
                  Uri.parse(apiUrl),
                  body: {'user_id': user_id},
                );

                if (response.statusCode == 200) {
                  // Delete successful
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile deleted successfully'),
                    ),
                  );
                  _handleLogout(context); // Logout after deletion (optional)
                } else {
                  // Handle delete error (e.g., show a snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Error deleting profile. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    // Clear user ID or perform any logout logic specific to your app
    Navigator.pushReplacementNamed(
        context, '/login'); // Replace current screen with login
  }
}
