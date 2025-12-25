import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Professional logging utility with different log levels and colors
class AppLogger {
  AppLogger._();

  static const String _prefix = '🚀 [Test3]';

  // ANSI color codes for terminal
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      debugPrint('$_cyan$_prefix 🐛 $tagText $message$_reset');
    }
  }

  /// Log info messages
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      debugPrint('$_blue$_prefix ℹ️ $tagText $message$_reset');
    }
  }

  /// Log warning messages
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      debugPrint('$_yellow$_prefix ⚠️ $tagText $message$_reset');
    }
  }

  /// Log error messages with structured output
  static void error(String message,
      [dynamic error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      debugPrint('$_red╔═══════════════════════════════════════════$_reset');
      debugPrint('$_red║ $_prefix ❌ $tagText $message$_reset');

      if (error != null) {
        if (error is DioException) {
          _logDioError(error);
        } else {
          debugPrint('$_red║ Error: $error$_reset');
        }
      }

      if (stackTrace != null && kDebugMode) {
        final frames = stackTrace.toString().split('\n').take(3);
        for (final frame in frames) {
          debugPrint('$_red║   $frame$_reset');
        }
      }

      debugPrint('$_red╚═══════════════════════════════════════════$_reset');
    }
  }

  /// Log DioException with structured format
  static void _logDioError(DioException e) {
    final request = e.requestOptions;
    final response = e.response;

    debugPrint('$_red║ ┌─ Request ─────────────────────────────$_reset');
    debugPrint('$_red║ │ ${request.method} ${request.path}$_reset');

    if (response != null) {
      debugPrint('$_red║ ├─ Response ────────────────────────────$_reset');
      debugPrint('$_red║ │ Status: ${response.statusCode}$_reset');

      // Extract user-friendly error message from backend response
      final data = response.data;
      if (data is Map) {
        final errorData = data['error'];
        if (errorData is Map) {
          final code = errorData['code'] ?? 'UNKNOWN';
          final msg = errorData['message'] ?? e.message;
          debugPrint('$_red║ │ Code: $code$_reset');
          debugPrint('$_red║ │ Message: $msg$_reset');
        } else if (data['message'] != null) {
          debugPrint('$_red║ │ Message: ${data['message']}$_reset');
        }
      }
    } else {
      debugPrint('$_red║ │ Type: ${e.type.name}$_reset');
      debugPrint('$_red║ │ Message: ${e.message}$_reset');
    }

    debugPrint('$_red║ └───────────────────────────────────────$_reset');
  }

  /// Log success messages
  static void success(String message, [String? tag]) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      debugPrint('$_green$_prefix ✅ $tagText $message$_reset');
    }
  }

  /// Log API request
  static void request(String method, String path) {
    if (kDebugMode) {
      debugPrint('$_cyan$_prefix 📤 [$method] $path$_reset');
    }
  }

  /// Log API response
  static void response(int statusCode, String path, int durationMs) {
    if (kDebugMode) {
      final color = statusCode >= 200 && statusCode < 300 ? _green : _red;
      debugPrint(
          '$color$_prefix 📥 [$statusCode] $path (${durationMs}ms)$_reset');
    }
  }
}
