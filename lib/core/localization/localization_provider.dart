import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constant_words.dart';

final languageProvider = StateProvider<String>((ref) => 'en');

String localizedText(String key) {
  final currentLanguage = _currentLanguage;
  return LocalizationConstants.localizedTexts[currentLanguage]?[key] ?? key;
}

String _currentLanguage = 'en';

void setLanguage(String language) {
  _currentLanguage = language;
}
