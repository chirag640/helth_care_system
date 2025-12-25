import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// Auth API Service - handles all authentication API calls
class AuthApiService {
  AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  static const String _basePath = '/auth';

  /// Register a new patient
  Future<Map<String, dynamic>> registerPatient(
      RegisterPatientRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/register/patient',
        data: request.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Register patient failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Login with email and password
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/login',
        data: request.toJson(),
      );
      AppLogger.info('Login response data: ${response.data}', 'AuthApiService');

      // Extract data from wrapped response
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;

      return AuthResponse.fromJson(data);
    } on DioException catch (e) {
      AppLogger.error('Login failed', e, null, 'AuthApiService');
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error in login', e, stackTrace, 'AuthApiService');
      rethrow;
    }
  }

  /// Request OTP for login
  Future<Map<String, dynamic>> requestLoginOtp(
      LoginWithOtpRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/login/request-otp',
        data: request.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Request OTP failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Verify OTP and complete login
  Future<AuthResponse> verifyOtpLogin(VerifyOtpRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/login/verify-otp',
        data: request.toJson(),
      );
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return AuthResponse.fromJson(data);
    } on DioException catch (e) {
      AppLogger.error('Verify OTP failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/refresh',
        data: request.toJson(),
      );
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      return AuthResponse.fromJson(data);
    } on DioException catch (e) {
      AppLogger.error('Refresh token failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Logout and revoke refresh token
  Future<void> logout(LogoutRequest request) async {
    try {
      await _apiClient.post(
        '$_basePath/logout',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      AppLogger.error('Logout failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Request password reset email
  Future<Map<String, dynamic>> forgotPassword(
      ForgotPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/forgot-password',
        data: request.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Forgot password failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Reset password with token
  Future<Map<String, dynamic>> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/reset-password',
        data: request.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Reset password failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Verify email with token
  Future<Map<String, dynamic>> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/verify-email',
        data: request.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Verify email failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Verify registration OTP
  Future<Map<String, dynamic>> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/verify-registration-otp',
        data: {'email': email, 'otp': otp},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error(
          'Verify registration OTP failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Resend registration OTP
  Future<Map<String, dynamic>> resendRegistrationOtp(String email) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/resend-registration-otp',
        data: {'email': email},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error(
          'Resend registration OTP failed', e, null, 'AuthApiService');
      rethrow;
    }
  }

  /// Get current authenticated user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('$_basePath/me');

      // Extract data from wrapped response if needed
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        // Check if response is wrapped
        if (responseData.containsKey('data')) {
          final data = responseData['data'] as Map<String, dynamic>;
          return UserModel.fromJson(data);
        }
        // Direct response
        return UserModel.fromJson(responseData);
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      AppLogger.error('Get current user failed', e, null, 'AuthApiService');
      rethrow;
    }
  }
}
