/// User role enum matching backend UserRole
enum UserRole {
  patient('Patient'),
  doctor('Doctor'),
  hospitalAdmin('HospitalAdmin'),
  superAdmin('SuperAdmin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.patient,
    );
  }
}

/// User model representing authenticated user data
class UserModel {
  const UserModel({
    required this.userId,
    required this.email,
    required this.role,
    this.fullName,
    this.hospitalId,
    this.patientId,
    this.doctorId,
    this.permissions,
  });

  final String userId;
  final String email;
  final UserRole role;
  final String? fullName;
  final String? hospitalId;
  final String? patientId;
  final String? doctorId;
  final List<String>? permissions;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String),
      fullName: json['fullName'] as String?,
      hospitalId: json['hospitalId'] as String?,
      patientId: json['patientId'] as String?,
      doctorId: json['doctorId'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'role': role.value,
      if (fullName != null) 'fullName': fullName,
      if (hospitalId != null) 'hospitalId': hospitalId,
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId,
      if (permissions != null) 'permissions': permissions,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    UserRole? role,
    String? fullName,
    String? hospitalId,
    String? patientId,
    String? doctorId,
    List<String>? permissions,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      hospitalId: hospitalId ?? this.hospitalId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.userId == userId &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode => userId.hashCode ^ email.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, role: ${role.value})';
  }
}
