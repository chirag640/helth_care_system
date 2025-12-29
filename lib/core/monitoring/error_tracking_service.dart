import 'dart:async';

import 'package:flutter/foundation.dart';

import '../config/env_loader.dart';
import '../utils/logger.dart';

/// Error severity levels
enum ErrorSeverity {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Error context for better debugging
class ErrorContext {
  const ErrorContext({
    this.userId,
    this.email,
    this.screen,
    this.action,
    this.extra,
  });

  final String? userId;
  final String? email;
  final String? screen;
  final String? action;
  final Map<String, dynamic>? extra;

  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': _sanitizeEmail(email!),
      if (screen != null) 'screen': screen,
      if (action != null) 'action': action,
      ...?extra,
    };
  }

  String _sanitizeEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***@***';
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return '**@$domain';
    return '${local[0]}***${local[local.length - 1]}@$domain';
  }
}

/// Error tracking service for crash reporting and monitoring
/// Provides a Sentry-like interface without the dependency
class ErrorTrackingService {
  ErrorTrackingService._();

  static final ErrorTrackingService _instance = ErrorTrackingService._();
  static ErrorTrackingService get instance => _instance;

  bool _initialized = false;
  String? _dsn;
  ErrorContext? _userContext;

  // Queue for offline error tracking
  final List<_ErrorEntry> _errorQueue = [];
  static const int _maxQueueSize = 100;

  /// Initialize error tracking
  Future<void> init({String? dsn}) async {
    if (_initialized) return;

    _dsn = dsn;

    // Set up Flutter error handling
    FlutterError.onError = (details) {
      captureException(
        details.exception,
        stackTrace: details.stack,
        severity: ErrorSeverity.error,
        context: ErrorContext(
          extra: {'flutter_error_info': details.summary.toString()},
        ),
      );
    };

    // Capture platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      captureException(
        error,
        stackTrace: stack,
        severity: ErrorSeverity.fatal,
      );
      return true;
    };

    _initialized = true;
    AppLogger.success('Error tracking initialized', 'ErrorTracking');
  }

  /// Set user context for error reports
  void setUserContext({
    String? userId,
    String? email,
  }) {
    _userContext = ErrorContext(
      userId: userId,
      email: email,
    );
  }

  /// Clear user context (on logout)
  void clearUserContext() {
    _userContext = null;
  }

  /// Capture an exception
  void captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    ErrorSeverity severity = ErrorSeverity.error,
    ErrorContext? context,
  }) {
    if (!_initialized) {
      AppLogger.warning('Error tracking not initialized', 'ErrorTracking');
      return;
    }

    final entry = _ErrorEntry(
      exception: exception,
      stackTrace: stackTrace ?? StackTrace.current,
      severity: severity,
      context: context ?? _userContext,
      timestamp: DateTime.now(),
    );

    // Log locally
    _logError(entry);

    // Queue for sending (if DSN configured)
    if (_dsn != null) {
      _queueError(entry);
      _processQueue();
    }
  }

  /// Capture a message
  void captureMessage(
    String message, {
    ErrorSeverity severity = ErrorSeverity.info,
    ErrorContext? context,
  }) {
    if (!_initialized) return;

    final entry = _ErrorEntry(
      message: message,
      severity: severity,
      context: context ?? _userContext,
      timestamp: DateTime.now(),
    );

    _logMessage(entry);

    if (_dsn != null && severity.index >= ErrorSeverity.warning.index) {
      _queueError(entry);
      _processQueue();
    }
  }

  /// Add breadcrumb for debugging
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
  }) {
    if (!_initialized) return;

    AppLogger.debug(
      'Breadcrumb [$category]: $message ${data != null ? '- $data' : ''}',
      'ErrorTracking',
    );
  }

  /// Start a performance transaction
  PerformanceTransaction startTransaction({
    required String name,
    required String operation,
  }) {
    return PerformanceTransaction._(
      name: name,
      operation: operation,
      startTime: DateTime.now(),
    );
  }

  void _logError(_ErrorEntry entry) {
    final severityIcon = _getSeverityIcon(entry.severity);
    final contextStr = entry.context?.toMap().toString() ?? '';

    if (entry.exception != null) {
      AppLogger.error(
        '$severityIcon [${entry.severity.name.toUpperCase()}] ${entry.exception}',
        entry.exception,
        entry.stackTrace,
        'ErrorTracking',
      );
    }

    if (contextStr.isNotEmpty && kDebugMode) {
      AppLogger.debug('Context: $contextStr', 'ErrorTracking');
    }
  }

  void _logMessage(_ErrorEntry entry) {
    final severityIcon = _getSeverityIcon(entry.severity);

    switch (entry.severity) {
      case ErrorSeverity.debug:
        AppLogger.debug('$severityIcon ${entry.message}', 'ErrorTracking');
        break;
      case ErrorSeverity.info:
        AppLogger.info('$severityIcon ${entry.message}', 'ErrorTracking');
        break;
      case ErrorSeverity.warning:
        AppLogger.warning('$severityIcon ${entry.message}', 'ErrorTracking');
        break;
      case ErrorSeverity.error:
      case ErrorSeverity.fatal:
        AppLogger.error(
            '$severityIcon ${entry.message}', null, null, 'ErrorTracking');
        break;
    }
  }

  String _getSeverityIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.debug:
        return '🐛';
      case ErrorSeverity.info:
        return 'ℹ️';
      case ErrorSeverity.warning:
        return '⚠️';
      case ErrorSeverity.error:
        return '❌';
      case ErrorSeverity.fatal:
        return '💀';
    }
  }

  void _queueError(_ErrorEntry entry) {
    _errorQueue.add(entry);

    // Limit queue size
    while (_errorQueue.length > _maxQueueSize) {
      _errorQueue.removeAt(0);
    }
  }

  Future<void> _processQueue() async {
    if (_dsn == null || _errorQueue.isEmpty) return;

    // In production, this would send to Sentry/error tracking service
    // For now, we just log and clear
    if (EnvLoader.currentEnvironment == AppEnvironment.prod) {
      // TODO: Implement actual error reporting to backend/Sentry
      // This would POST errors to _dsn endpoint
    }

    // Clear processed errors
    _errorQueue.clear();
  }

  /// Get error statistics
  Map<String, int> getErrorStats() {
    final stats = <String, int>{};
    for (final entry in _errorQueue) {
      final key = entry.severity.name;
      stats[key] = (stats[key] ?? 0) + 1;
    }
    return stats;
  }

  /// Clear all queued errors
  void clearQueue() {
    _errorQueue.clear();
  }
}

class _ErrorEntry {
  const _ErrorEntry({
    this.exception,
    this.message,
    this.stackTrace,
    required this.severity,
    this.context,
    required this.timestamp,
  });

  final dynamic exception;
  final String? message;
  final StackTrace? stackTrace;
  final ErrorSeverity severity;
  final ErrorContext? context;
  final DateTime timestamp;
}

/// Performance transaction for measuring operation durations
class PerformanceTransaction {
  PerformanceTransaction._({
    required this.name,
    required this.operation,
    required this.startTime,
  });

  final String name;
  final String operation;
  final DateTime startTime;
  bool _finished = false;

  /// Finish the transaction
  void finish({String? status}) {
    if (_finished) return;
    _finished = true;

    final duration = DateTime.now().difference(startTime);
    AppLogger.debug(
      '⏱️ Transaction "$name" ($operation) completed in ${duration.inMilliseconds}ms ${status != null ? '- $status' : ''}',
      'Performance',
    );
  }

  /// Set transaction data
  void setData(String key, dynamic value) {
    // In production with Sentry, this would set span data
    AppLogger.debug('Transaction data: $key = $value', 'Performance');
  }

  /// Create a child span
  PerformanceSpan startChild({
    required String operation,
    String? description,
  }) {
    return PerformanceSpan._(
      operation: operation,
      description: description,
      startTime: DateTime.now(),
    );
  }
}

/// Performance span for sub-operations
class PerformanceSpan {
  PerformanceSpan._({
    required this.operation,
    this.description,
    required this.startTime,
  });

  final String operation;
  final String? description;
  final DateTime startTime;
  bool _finished = false;

  /// Finish the span
  void finish({String? status}) {
    if (_finished) return;
    _finished = true;

    final duration = DateTime.now().difference(startTime);
    AppLogger.debug(
      '  ├─ Span "$operation" ${description ?? ''} ${duration.inMilliseconds}ms ${status ?? ''}',
      'Performance',
    );
  }
}
