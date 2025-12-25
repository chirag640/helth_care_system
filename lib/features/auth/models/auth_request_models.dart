import 'user_model.dart';

/// Login request DTO
class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role.value,
    };
  }
}

/// Register patient request DTO
class RegisterPatientRequest {
  const RegisterPatientRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  final String email;
  final String password;
  final String fullName;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
    };
  }
}

/// Request OTP for login
class LoginWithOtpRequest {
  const LoginWithOtpRequest({
    required this.email,
    required this.role,
  });

  final String email;
  final UserRole role;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role.value,
    };
  }
}

/// Verify OTP request
class VerifyOtpRequest {
  const VerifyOtpRequest({
    required this.email,
    required this.otp,
    required this.purpose,
  });

  final String email;
  final String otp;
  final String purpose;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'purpose': purpose,
    };
  }
}

/// Refresh token request
class RefreshTokenRequest {
  const RefreshTokenRequest({
    required this.refreshToken,
  });

  final String refreshToken;

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

/// Forgot password request
class ForgotPasswordRequest {
  const ForgotPasswordRequest({
    required this.email,
  });

  final String email;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

/// Reset password request
class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  final String token;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
    };
  }
}

/// Logout request
class LogoutRequest {
  const LogoutRequest({
    required this.refreshToken,
  });

  final String refreshToken;

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

/// Verify email request
class VerifyEmailRequest {
  const VerifyEmailRequest({
    required this.token,
  });

  final String token;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
