import 'package:dio/dio.dart';

/// API error types
enum ApiErrorType {
  network,
  timeout,
  server,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  unknown,
}

/// API error class
class ApiError implements Exception {
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.errors,
    this.originalException,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final dynamic originalException;

  /// Create from DioException
  factory ApiError.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // Extract message from response
    String message = 'An error occurred';
    Map<String, dynamic>? errors;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? message;
      if (data['errors'] is Map) {
        errors = data['errors'] as Map<String, dynamic>;
      }
    }

    // Determine error type
    ApiErrorType type;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        type = ApiErrorType.timeout;
        message = 'Request timed out. Please try again.';
        break;

      case DioExceptionType.connectionError:
        type = ApiErrorType.network;
        message = 'No internet connection. Please check your network.';
        break;

      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            type = ApiErrorType.validation;
            break;
          case 401:
            type = ApiErrorType.unauthorized;
            message = 'Session expired. Please login again.';
            break;
          case 403:
            type = ApiErrorType.forbidden;
            message = 'You do not have permission to perform this action.';
            break;
          case 404:
            type = ApiErrorType.notFound;
            message = 'Resource not found.';
            break;
          case 409:
            type = ApiErrorType.conflict;
            break;
          case 500:
          case 502:
          case 503:
            type = ApiErrorType.server;
            message = 'Server error. Please try again later.';
            break;
          default:
            type = ApiErrorType.unknown;
        }
        break;

      case DioExceptionType.cancel:
        type = ApiErrorType.unknown;
        message = 'Request was cancelled.';
        break;

      default:
        type = ApiErrorType.unknown;
    }

    return ApiError(
      type: type,
      message: message,
      statusCode: statusCode,
      errors: errors,
      originalException: e,
    );
  }

  /// Check if it's an authentication error
  bool get isAuthError => type == ApiErrorType.unauthorized;

  /// Check if it's a network error
  bool get isNetworkError =>
      type == ApiErrorType.network || type == ApiErrorType.timeout;

  /// Check if it's a validation error
  bool get isValidationError => type == ApiErrorType.validation;

  /// Check if it's a server error
  bool get isServerError => type == ApiErrorType.server;

  /// Get first validation error for a field
  String? getFieldError(String field) {
    if (errors == null) return null;
    final fieldErrors = errors![field];
    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }
    if (fieldErrors is String) {
      return fieldErrors;
    }
    return null;
  }

  @override
  String toString() => 'ApiError: $message (type: $type, code: $statusCode)';
}

/// Extension on DioException for easier error handling
extension DioExceptionExtension on DioException {
  ApiError toApiError() => ApiError.fromDioException(this);
}
