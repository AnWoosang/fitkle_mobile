import 'package:flutter/foundation.dart';

/// Centralized logging utility
class Logger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _bold = '\x1B[1m';

  /// Log an error message
  static void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_red$_bold🔴 ERROR$_reset $_red$tagStr$message$_reset');
      if (error != null) {
        print('$_red   Error: $error$_reset');
      }
      if (stackTrace != null) {
        print('$_red   Stack: $stackTrace$_reset');
      }
    }
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_yellow$_bold⚠️  WARNING$_reset $_yellow$tagStr$message$_reset');
    }
  }

  /// Log an info message
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_blue$_boldℹ️  INFO$_reset $_blue$tagStr$message$_reset');
    }
  }

  /// Log a success message
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_green$_bold✅ SUCCESS$_reset $_green$tagStr$message$_reset');
    }
  }

  /// Log a debug message
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_cyan🐛 DEBUG$_reset $_cyan$tagStr$message$_reset');
    }
  }

  /// Log a network request
  static void request(String method, String url, {Map<String, dynamic>? data, Map<String, String>? headers}) {
    if (kDebugMode) {
      print('$_bold$_blue📤 REQUEST$_reset $_blue$method $url$_reset');
      if (headers != null && headers.isNotEmpty) {
        print('$_cyan   Headers: $headers$_reset');
      }
      if (data != null && data.isNotEmpty) {
        print('$_cyan   Data: $data$_reset');
      }
    }
  }

  /// Log a network response
  static void response(int statusCode, String url, {dynamic data}) {
    if (kDebugMode) {
      final color = statusCode >= 200 && statusCode < 300 ? _green : _red;
      print('$_bold$color📥 RESPONSE$_reset $color$statusCode $url$_reset');
      if (data != null) {
        print('$_cyan   Data: $data$_reset');
      }
    }
  }

  /// Log a divider
  static void divider({String? title}) {
    if (kDebugMode) {
      if (title != null) {
        print('$_white$_bold━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset');
        print('$_white$_bold  $title$_reset');
        print('$_white$_bold━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset');
      } else {
        print('$_white━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset');
      }
    }
  }
}
