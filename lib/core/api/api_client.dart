import 'package:dio/dio.dart';
import 'package:helth_care_system/core/storage/secure_storage.dart';
import '../config/app_config.dart';
import '../constants/app_constants.dart';
import '../storage/local_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class ApiClient {
  ApiClient(this.config) {
    _initializeDio();
  }

  final AppConfig config;
  late final Dio dio;

  // Completer to track auth interceptor initialization
  bool _authInterceptorInitialized = false;

  void _initializeDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order
    // Note: AuthInterceptor requires async initialization, added separately
    dio.interceptors.addAll([
      RetryInterceptor(dio: dio),
      LoggerInterceptor(),
    ]);

    // Initialize auth interceptor asynchronously
    _initializeAuthInterceptor();
  }

  Future<void> _initializeAuthInterceptor() async {
    final storage = await LocalStorage.getInstance();
    // Insert auth interceptor at the beginning (before retry and logger)
    dio.interceptors
        .insert(0, AuthInterceptor(storage, SecureStorage.instance));
    _authInterceptorInitialized = true;
  }

  /// Ensure auth interceptor is initialized before making requests
  Future<void> ensureInitialized() async {
    // Wait a bit for async initialization if not ready
    int attempts = 0;
    while (!_authInterceptorInitialized && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }
  }

  /// Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await ensureInitialized();
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await ensureInitialized();
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await ensureInitialized();
    return dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await ensureInitialized();
    return dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await ensureInitialized();
    return dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
