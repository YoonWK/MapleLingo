//maple_lingo_application/lib/main.dart

import 'package:flutter/material.dart';
import 'package:maple_lingo_application/providers/active_theme_provider.dart';
import 'package:maple_lingo_application/screens/chatGenerator_screen.dart';
import 'package:maple_lingo_application/screens/chat_screen.dart';
import 'package:maple_lingo_application/constants/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_lingo_application/screens/login_screen.dart';
import 'package:maple_lingo_application/screens/profile_screen.dart';
import 'package:maple_lingo_application/screens/register_screen.dart';

// Define named routes
const loginRoute = '/login';
const chatRoute = '/chat';
const chatGeneratorRoute = '/chatGenerator';
const registerRoute = '/register';
const profileRoute = '/profile';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);

    return MaterialApp(
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      themeMode:
          activeTheme == Themes.light ? ThemeMode.light : ThemeMode.light,
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        chatGeneratorRoute: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final userId = args['user_id'] as String;
          return ChatGeneratorScreen(user_id: userId);
        },
        chatRoute: (context) => const ChatScreen(),
        profileRoute: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final userId = args['user_id'] as String;
          return ProfileScreen(user_id: userId);
        },
      },
    );
  }
}
