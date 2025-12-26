import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

/// Manages authentication tokens with secure storage
class TokenStorage {
  TokenStorage._();

  static final TokenStorage _instance = TokenStorage._();
  static TokenStorage get instance => _instance;

  LocalStorage? _localStorage;
  final SecureStorage _secureStorage = SecureStorage.instance;

  /// Initialize with LocalStorage instance
  Future<void> init() async {
    _localStorage = await LocalStorage.getInstance();
  }

  /// Save tokens after successful authentication
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? email,
    String? role,
    String? sessionId,
  }) async {
    try {
      // Access token in local storage for fast reads
      await _localStorage?.setString(AppConstants.keyAccessToken, accessToken);

      // Refresh token in secure storage
      await _secureStorage.write(AppConstants.keyRefreshToken, refreshToken);

      // Store user info
      if (userId != null) {
        await _localStorage?.setString(AppConstants.keyUserId, userId);
      }
      if (email != null) {
        await _localStorage?.setString('user_email', email);
      }
      if (role != null) {
        await _localStorage?.setString('user_role', role);
      }
      if (sessionId != null) {
        await _localStorage?.setString('session_id', sessionId);
      }

      AppLogger.info('Tokens saved successfully', 'TokenStorage');
    } catch (e) {
      AppLogger.error('Failed to save tokens', e, null, 'TokenStorage');
      rethrow;
    }
  }

  /// Get access token
  String? getAccessToken() {
    return _localStorage?.getString(AppConstants.keyAccessToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(AppConstants.keyRefreshToken);
  }

  /// Get stored user ID
  String? getUserId() {
    return _localStorage?.getString(AppConstants.keyUserId);
  }

  /// Get stored user email
  String? getUserEmail() {
    return _localStorage?.getString('user_email');
  }

  /// Get stored user role
  String? getUserRole() {
    return _localStorage?.getString('user_role');
  }

  /// Get session ID
  String? getSessionId() {
    return _localStorage?.getString('session_id');
  }

  /// Save patient ID (for Patient role users)
  Future<void> savePatientId(String patientId) async {
    try {
      await _localStorage?.setString('patient_id', patientId);
      AppLogger.debug('PatientId saved: $patientId', 'TokenStorage');
    } catch (e) {
      AppLogger.error('Failed to save patientId', e, null, 'TokenStorage');
      rethrow;
    }
  }

  /// Get stored patient ID
  String? getPatientId() {
    return _localStorage?.getString('patient_id');
  }

  /// Check if user is authenticated (has valid access token)
  bool isAuthenticated() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all tokens and user data (logout)
  Future<void> clearTokens() async {
    try {
      await _localStorage?.remove(AppConstants.keyAccessToken);
      await _secureStorage.delete(AppConstants.keyRefreshToken);
      await _localStorage?.remove(AppConstants.keyUserId);
      await _localStorage?.remove('user_email');
      await _localStorage?.remove('user_role');
      await _localStorage?.remove('session_id');
      await _localStorage?.remove('patient_id');

      AppLogger.info('Tokens cleared successfully', 'TokenStorage');
    } catch (e) {
      AppLogger.error('Failed to clear tokens', e, null, 'TokenStorage');
      rethrow;
    }
  }

  /// Update only the access token (after refresh)
  Future<void> updateAccessToken(String accessToken) async {
    try {
      await _localStorage?.setString(AppConstants.keyAccessToken, accessToken);
      AppLogger.debug('Access token updated', 'TokenStorage');
    } catch (e) {
      AppLogger.error('Failed to update access token', e, null, 'TokenStorage');
      rethrow;
    }
  }

  /// Update both tokens (after refresh that returns new refresh token)
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _localStorage?.setString(AppConstants.keyAccessToken, accessToken);
      await _secureStorage.write(AppConstants.keyRefreshToken, refreshToken);
      AppLogger.debug('Both tokens updated', 'TokenStorage');
    } catch (e) {
      AppLogger.error('Failed to update tokens', e, null, 'TokenStorage');
      rethrow;
    }
  }

  // ============== Onboarding & Permission Flags ==============

  /// Check if user has completed onboarding
  bool isOnboardingComplete() {
    return _localStorage?.getBool('onboarding_complete') ?? false;
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete(bool value) async {
    await _localStorage?.setBool('onboarding_complete', value);
  }

  /// Check if permissions have been requested
  bool arePermissionsRequested() {
    return _localStorage?.getBool('permissions_requested') ?? false;
  }

  /// Mark permissions as requested
  Future<void> setPermissionsRequested(bool value) async {
    await _localStorage?.setBool('permissions_requested', value);
  }

  /// Check if profile setup is complete (for new users)
  bool isProfileSetupComplete() {
    return _localStorage?.getBool('profile_setup_complete') ?? false;
  }

  /// Mark profile setup as complete
  Future<void> setProfileSetupComplete(bool value) async {
    await _localStorage?.setBool('profile_setup_complete', value);
  }

  /// Check if this is first login (new user)
  bool isFirstLogin() {
    return _localStorage?.getBool('is_first_login') ?? true;
  }

  /// Mark first login complete
  Future<void> setFirstLoginComplete() async {
    await _localStorage?.setBool('is_first_login', false);
  }

  /// Clear all onboarding/setup flags (for testing or logout)
  Future<void> clearSetupFlags() async {
    await _localStorage?.remove('onboarding_complete');
    await _localStorage?.remove('permissions_requested');
    await _localStorage?.remove('profile_setup_complete');
    await _localStorage?.remove('is_first_login');
  }
}
