//lib/providers/active_theme_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeThemeProvider = StateProvider((ref) => Themes.light);

enum Themes {
  light,
}
