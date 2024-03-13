//maple_lingo_application/lib/main.dart

import 'package:flutter/material.dart';
import 'package:maple_lingo_application/providers/active_theme_provider.dart';
import 'package:maple_lingo_application/screens/chat_screen.dart';
import 'package:maple_lingo_application/constants/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      home: const ChatScreen(),
    );
  }
}
