import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static const bool _isDebugMode = kDebugMode;

  /// Log debug messages only in debug mode
  static void log(String message, {String? tag}) {
    if (_isDebugMode) {
      final logMessage = tag != null ? '[$tag] $message' : message;
      debugPrint(logMessage);
    }
  }

  /// Log error messages
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (_isDebugMode) {
      final errorMessage = tag != null ? '[$tag] ERROR: $message' : 'ERROR: $message';
      debugPrint(errorMessage);

      // Optional: Log stack trace for more detailed error tracking
      if (error != null) {
        debugPrint('Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Log informational messages
  static void info(String message, {String? tag}) {
    if (_isDebugMode) {
      final infoMessage = tag != null ? '[$tag] INFO: $message' : 'INFO: $message';
      debugPrint(infoMessage);
    }
  }

  /// Log warning messages
  static void warn(String message, {String? tag}) {
    if (_isDebugMode) {
      final warnMessage = tag != null ? '[$tag] WARNING: $message' : 'WARNING: $message';
      debugPrint(warnMessage);
    }
  }
}
