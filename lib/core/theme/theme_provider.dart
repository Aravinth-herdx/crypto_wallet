import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends Notifier<bool> {
  @override
  bool build() => false; // Default to light mode

  void toggleTheme() {
    state = !state;
  }
}

final themeProviderNotifier = NotifierProvider<ThemeProvider, bool>(
  ThemeProvider.new,
);
