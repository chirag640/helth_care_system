import 'dart:async';
import 'package:dio/dio.dart';

import '../../auth/auth_event_bus.dart';
import '../../config/env_loader.dart';
import '../../storage/local_storage.dart';
import '../../storage/secure_storage.dart';
import '../../constants/app_constants.dart';
import '../../utils/logger.dart';

/// Enhanced authentication interceptor with token refresh capability
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._secureStorage);

  final LocalStorage _storage;
  final SecureStorage _secureStorage;

  // Queue to hold requests during token refresh
  final List<_RequestQueueItem> _requestQueue = [];
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for refresh token endpoint
    if (options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = _storage.getString(AppConstants.keyAccessToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.debug(
          'Added auth token to request: ${options.path}', 'AuthInterceptor');
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      AppLogger.warning(
          'Unauthorized error - attempting token refresh', 'AuthInterceptor');

      // If already refreshing, queue this request
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _requestQueue.add(_RequestQueueItem(err.requestOptions, completer));

        try {
          final response = await completer.future;
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }

      _isRefreshing = true;

      try {
        // Attempt to refresh the token
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Retry the original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().fetch(options);

          // Process queued requests with new token
          _processQueuedRequests(newToken);

          return handler.resolve(response);
        } else {
          // Refresh failed - reject all queued requests
          _rejectQueuedRequests(err);
          return handler.next(err);
        }
      } catch (e) {
        AppLogger.error('Token refresh failed', e, null, 'AuthInterceptor');
        _rejectQueuedRequests(err);
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }

  /// Refresh the access token using the refresh token
  Future<String?> _refreshToken() async {
    try {
      final refreshToken =
          await _secureStorage.read(AppConstants.keyRefreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('No refresh token available', 'AuthInterceptor');
        return null;
      }

      // Call your refresh token API endpoint
      final dio = Dio();
      final response = await dio.post(
        '${EnvLoader.apiBaseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        // Extract data from wrapped response if needed
        var responseData = response.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          responseData = responseData['data'] as Map<String, dynamic>;
        }

        final newAccessToken = responseData['accessToken'] as String?;
        final newRefreshToken = responseData['refreshToken'] as String?;

        if (newAccessToken != null) {
          // Store new tokens
          await _storage.setString(AppConstants.keyAccessToken, newAccessToken);

          if (newRefreshToken != null) {
            await _secureStorage.write(
                AppConstants.keyRefreshToken, newRefreshToken);
          }

          AppLogger.info('Token refreshed successfully', 'AuthInterceptor');
          return newAccessToken;
        }
      }

      return null;
    } catch (e) {
      AppLogger.error('Token refresh error', e, null, 'AuthInterceptor');

      // Clear tokens on refresh failure
      await _storage.remove(AppConstants.keyAccessToken);
      await _secureStorage.delete(AppConstants.keyRefreshToken);

      // Also clear user data to ensure clean logout
      await _storage.remove(AppConstants.keyUserId);
      await _storage.remove('user_email');
      await _storage.remove('user_role');
      await _storage.remove('session_id');
      await _storage.remove('patient_id');

      // Emit event to notify the app that authentication failed
      AuthEventBus.instance.emit(AuthEvent.tokenRefreshFailed);

      return null;
    }
  }

  /// Process all queued requests with the new token
  void _processQueuedRequests(String newToken) async {
    for (final item in _requestQueue) {
      try {
        item.options.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(item.options);
        item.completer.complete(response);
      } catch (e) {
        item.completer.completeError(e);
      }
    }
    _requestQueue.clear();
  }

  /// Reject all queued requests when refresh fails
  void _rejectQueuedRequests(DioException error) {
    for (final item in _requestQueue) {
      item.completer.completeError(error);
    }
    _requestQueue.clear();
  }
}

/// Helper class to queue requests during token refresh
class _RequestQueueItem {
  _RequestQueueItem(this.options, this.completer);

  final RequestOptions options;
  final Completer<Response> completer;
}
