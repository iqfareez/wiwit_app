import 'package:flutter/material.dart';

/// Navigation helpers shared across the app.
extension NavigationUtils on BuildContext {
  /// Clears the whole navigation stack so the user can't swipe back in.
  void replaceRootWith(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
}
