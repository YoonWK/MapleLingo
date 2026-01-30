//maple_lingo_application/lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers/user_provider.dart

final userProvider = StateProvider<String>((ref) => ""); // Initial user ID

// Optionally, create a class to manage user state
class UserNotifier extends ChangeNotifier {
  String _user_id = ''; // Store only the user_id

  String get userId => _user_id;

  void updateUserId(String newUserId) {
    _user_id = newUserId;
    notifyListeners();
  }
}
