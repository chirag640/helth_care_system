import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auth state
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth controller
class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  // Sign In
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Sign Up
  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Verify Code
  Future<bool> verifyCode(String code) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Resend Code
  Future<void> resendCode(String email) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Reset Password
  Future<void> resetPassword(String newPassword) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Complete Profile
  Future<void> completeProfile({
    required String name,
    required String phone,
    required String gender,
    String? imageUrl,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Sign Out
  void signOut() {
    state = AuthState();
  }
}

/// Auth controller provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});
