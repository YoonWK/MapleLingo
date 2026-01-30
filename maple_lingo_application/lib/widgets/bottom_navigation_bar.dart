import 'package:flutter/material.dart';
import 'package:maple_lingo_application/main.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final String user_id;
  final int currentIndex;

  const BottomNavigationBarWidget({
    super.key,
    required this.user_id,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // Handle navigation based on selected item
        if (index == 0) {
          Navigator.pushReplacementNamed(
            context,
            profileRoute, // Assuming chatGeneratorRoute is defined elsewhere
            arguments: {'user_id': user_id},
          );
        } else if (index == 1) {
          Navigator.pushReplacementNamed(
            context,
            chatGeneratorRoute, // Assuming chatGeneratorRoute is defined elsewhere
            arguments: {'user_id': user_id},
          );
        }
      },
    );
  }
}
