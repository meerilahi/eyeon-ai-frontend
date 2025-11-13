import 'dart:developer' as developer;

class Logger {
  static void log(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'EyeOnAI');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      error: error,
      stackTrace: stackTrace,
      name: 'EyeOnAI_Error',
    );
  }
}
