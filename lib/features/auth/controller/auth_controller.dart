import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/auth/token_storage.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/auth_api_service.dart';

/// Auth state containing user and authentication status
class AuthState {
  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearUser = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  /// Initial unauthenticated state
  static const initial = AuthState();

  /// Loading state
  AuthState toLoading() =>
      copyWith(isLoading: true, clearError: true, clearSuccess: true);

  /// Error state
  AuthState toError(String message) =>
      copyWith(isLoading: false, error: message);

  /// Success state with authentication
  AuthState toAuthenticated(UserModel user) => copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        clearError: true,
      );

  /// Logged out state
  AuthState toLoggedOut() => const AuthState();
}

/// Auth controller managing authentication state
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authService, this._tokenStorage)
      : super(AuthState.initial);

  final AuthApiService _authService;
  final TokenStorage _tokenStorage;

  /// Check if user is already authenticated on app start
  /// Validates the stored token by making an API call
  Future<void> checkAuthStatus() async {
    if (_tokenStorage.isAuthenticated()) {
      // User has token stored, verify it's still valid
      final userId = _tokenStorage.getUserId();
      final email = _tokenStorage.getUserEmail();
      final roleStr = _tokenStorage.getUserRole();
      var patientId = _tokenStorage.getPatientId();

      if (userId != null && email != null) {
        final role = UserRole.values.firstWhere(
          (r) => r.value == roleStr,
          orElse: () => UserRole.patient,
        );

        // Validate token by making an API call
        try {
          final currentUser = await _authService.getCurrentUser();
          // Token is valid, update patientId if needed
          if (currentUser.patientId != null &&
              currentUser.patientId!.isNotEmpty) {
            patientId = currentUser.patientId;
            await _tokenStorage.savePatientId(patientId!);
          }

          final user = UserModel(
            userId: userId,
            email: email,
            role: role,
            patientId: patientId,
          );

          state = state.toAuthenticated(user);
          AppLogger.info(
              'Auth restored from storaage: $email', 'AuthController');
          return;
        } catch (e) {
          // Token validation failed - tokens are invalid
          AppLogger.warning(
              'Token validation failed, clearing tokens: $e', 'AuthController');
          await _tokenStorage.clearTokens();
          state = AuthState.initial;
          return;
        }
      }

      // Invalid stored data, clear it
      await _tokenStorage.clearTokens();
    }
    state = AuthState.initial;
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
    UserRole role = UserRole.patient,
  }) async {
    state = state.toLoading();

    try {
      final request = LoginRequest(
        email: email,
        password: password,
        role: role,
      );

      final response = await _authService.login(request);

      // Save tokens initially with userId
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        email: response.email,
        role: response.role.value,
        sessionId: response.sessionId,
      );

      // For Patient role, fetch the actual patientId from /auth/me
      String? patientId;
      if (response.role == UserRole.patient) {
        try {
          final userInfo = await _authService.getCurrentUser();
          patientId = userInfo.patientId;
          if (patientId != null && patientId.isNotEmpty) {
            // Store patientId separately for profile fetching
            await _tokenStorage.savePatientId(patientId);
            AppLogger.info(
                'PatientId fetched and stored: $patientId', 'AuthController');
          }
        } catch (e) {
          AppLogger.warning(
              'Failed to fetch patientId from /auth/me: $e', 'AuthController');
          // Continue without patientId - profile will fail but login succeeds
        }
      }

      // Create user from response
      final user = UserModel(
        userId: response.userId,
        email: response.email,
        role: response.role,
        patientId: patientId,
      );

      state = state.toAuthenticated(user);
      AppLogger.info('User signed in: ${user.email}', 'AuthController');
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      AppLogger.error('DioException during sign in', e);
      state = state.toError(message);
      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during sign in: $e', e, stackTrace);
      state = state.toError('An unexpected error occurred: ${e.toString()}');
      return false;
    }
  }

  /// Register a new patient
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.toLoading();

    try {
      final request = RegisterPatientRequest(
        email: email,
        password: password,
        fullName: fullName,
      );

      final response = await _authService.registerPatient(request);

      // Registration successful, but user needs to verify OTP
      // Don't save tokens as they're not provided yet
      state = state.copyWith(
        isLoading: false,
        successMessage:
            response['message'] as String? ?? 'Registration successful',
        clearError: true,
      );

      AppLogger.info('Patient registered: $email - OTP sent', 'AuthController');
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('An unexpected error occurred');
      return false;
    }
  }

  /// Verify registration OTP
  Future<bool> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) async {
    state = state.toLoading();

    try {
      final response = await _authService.verifyRegistrationOtp(
        email: email,
        otp: otp,
      );

      state = state.copyWith(
        isLoading: false,
        successMessage:
            response['message'] as String? ?? 'Email verified successfully',
        clearError: true,
      );

      AppLogger.info('Registration OTP verified: $email', 'AuthController');
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to verify OTP');
      return false;
    }
  }

  /// Resend registration OTP
  Future<bool> resendRegistrationOtp(String email) async {
    state = state.toLoading();

    try {
      final response = await _authService.resendRegistrationOtp(email);

      state = state.copyWith(
        isLoading: false,
        successMessage:
            response['message'] as String? ?? 'New OTP sent to your email',
        clearError: true,
      );

      AppLogger.info('Registration OTP resent: $email', 'AuthController');
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to resend OTP');
      return false;
    }
  }

  /// Request OTP for login
  Future<bool> requestLoginOtp({
    required String email,
    UserRole role = UserRole.patient,
  }) async {
    state = state.toLoading();

    try {
      final request = LoginWithOtpRequest(email: email, role: role);
      await _authService.requestLoginOtp(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'OTP sent to your email',
        clearError: true,
      );
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to send OTP');
      return false;
    }
  }

  /// Verify OTP and complete login
  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  }) async {
    state = state.toLoading();

    try {
      final request = VerifyOtpRequest(
        email: email,
        otp: otp,
        purpose: purpose,
      );

      final response = await _authService.verifyOtpLogin(request);

      // Save tokens
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        email: response.email,
        role: response.role.value,
        sessionId: response.sessionId,
      );

      final user = UserModel(
        userId: response.userId,
        email: response.email,
        role: response.role,
      );

      state = state.toAuthenticated(user);
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to verify OTP');
      return false;
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String email) async {
    state = state.toLoading();

    try {
      final request = ForgotPasswordRequest(email: email);
      await _authService.forgotPassword(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent',
        clearError: true,
      );
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to send reset email');
      return false;
    }
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.toLoading();

    try {
      final request = ResetPasswordRequest(
        token: token,
        newPassword: newPassword,
      );
      await _authService.resetPassword(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset successful',
        clearError: true,
      );
      return true;
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      state = state.toError(message);
      return false;
    } catch (e) {
      state = state.toError('Failed to reset password');
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _authService.logout(LogoutRequest(refreshToken: refreshToken));
      }
    } catch (e) {
      AppLogger.warning('Logout API call failed: $e', 'AuthController');
    } finally {
      await _tokenStorage.clearTokens();
      state = state.toLoggedOut();
      AppLogger.info('User signed out', 'AuthController');
    }
  }

  /// Force logout - called when token refresh fails
  /// This doesn't call the logout API since tokens are already invalid
  void forceLogout() {
    state = state.toLoggedOut();
    AppLogger.info(
        'User force logged out due to auth failure', 'AuthController');
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success messages
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  /// Extract error message from DioException
  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 'An error occurred';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return 'Invalid credentials';
        if (statusCode == 404) return 'Resource not found';
        if (statusCode == 409) return 'Account already exists';
        if (statusCode == 422) return 'Validation failed';
        if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed';
      default:
        return 'An unexpected error occurred';
    }
  }
}

// ============ PROVIDERS ============

/// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = AppConfig.load();
  return ApiClient(config);
});

/// Token storage provider
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage.instance;
});

/// Auth API service provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiService(apiClient);
});

/// Auth controller provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthController(authService, tokenStorage);
});

/// Convenience provider for checking authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authControllerProvider).user;
});
