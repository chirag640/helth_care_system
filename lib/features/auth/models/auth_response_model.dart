import 'user_model.dart';

/// Authentication response from backend
/// Returned after successful login, register, or token refresh
class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.role,
    required this.email,
    required this.userId,
    required this.sessionId,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserRole role;
  final String email;
  final String userId;
  final String sessionId;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
      role: UserRole.fromString(json['role'] as String),
      email: json['email'] as String,
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'role': role.value,
      'email': email,
      'userId': userId,
      'sessionId': sessionId,
    };
  }

  @override
  String toString() {
    return 'AuthResponse(userId: $userId, email: $email, role: ${role.value})';
  }
}
