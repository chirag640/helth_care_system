import 'package:equatable/equatable.dart';

/// Gender enum
enum Gender {
  male('Male'),
  female('Female'),
  other('Other'),
  preferNotToSay('PreferNotToSay');

  const Gender(this.value);
  final String value;

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (g) => g.value.toLowerCase() == value.toLowerCase(),
      orElse: () => Gender.preferNotToSay,
    );
  }

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Blood group enum
enum BloodGroup {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-'),
  unknown('Unknown');

  const BloodGroup(this.value);
  final String value;

  static BloodGroup fromString(String value) {
    return BloodGroup.values.firstWhere(
      (bg) => bg.value == value,
      orElse: () => BloodGroup.unknown,
    );
  }
}

/// Emergency contact info
class EmergencyContact extends Equatable {
  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    this.email,
  });

  final String name;
  final String relationship;
  final String phoneNumber;
  final String? email;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
    };
  }

  EmergencyContact copyWith({
    String? name,
    String? relationship,
    String? phoneNumber,
    String? email,
  }) {
    return EmergencyContact(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [name, relationship, phoneNumber, email];
}

/// Address info
class AddressInfo extends Equatable {
  const AddressInfo({
    this.street,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zipCode': zipCode,
      if (country != null) 'country': country,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    if (street != null && street!.isNotEmpty) parts.add(street!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (zipCode != null && zipCode!.isNotEmpty) parts.add(zipCode!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  AddressInfo copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return AddressInfo(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [street, city, state, zipCode, country];
}

/// Patient profile model
class PatientModel extends Equatable {
  const PatientModel({
    required this.id,
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.profilePhoto,
    this.address,
    this.emergencyContact,
    this.allergies,
    this.chronicConditions,
    this.insuranceProvider,
    this.insurancePolicyNumber,
    this.height,
    this.weight,
    this.isActive = true,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final BloodGroup? bloodGroup;
  final String? profilePhoto;
  final AddressInfo? address;
  final EmergencyContact? emergencyContact;
  final List<String>? allergies;
  final List<String>? chronicConditions;
  final String? insuranceProvider;
  final String? insurancePolicyNumber;
  final double? height; // in cm
  final double? weight; // in kg
  final bool isActive;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Get full name
  String get fullName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isNotEmpty ? parts.join(' ') : 'User';
  }

  /// Get age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  /// Get BMI if height and weight available
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] != null
          ? Gender.fromString(json['gender'] as String)
          : null,
      bloodGroup: json['bloodGroup'] != null
          ? BloodGroup.fromString(json['bloodGroup'] as String)
          : null,
      profilePhoto: json['profilePhoto'] as String?,
      address: json['address'] != null
          ? AddressInfo.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(
              json['emergencyContact'] as Map<String, dynamic>)
          : null,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      chronicConditions: (json['chronicConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      insuranceProvider: json['insuranceProvider'] as String?,
      insurancePolicyNumber: json['insurancePolicyNumber'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender!.value,
      if (bloodGroup != null) 'bloodGroup': bloodGroup!.value,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      if (address != null) 'address': address!.toJson(),
      if (emergencyContact != null)
        'emergencyContact': emergencyContact!.toJson(),
      if (allergies != null) 'allergies': allergies,
      if (chronicConditions != null) 'chronicConditions': chronicConditions,
      if (insuranceProvider != null) 'insuranceProvider': insuranceProvider,
      if (insurancePolicyNumber != null)
        'insurancePolicyNumber': insurancePolicyNumber,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }

  PatientModel copyWith({
    String? id,
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Gender? gender,
    BloodGroup? bloodGroup,
    String? profilePhoto,
    AddressInfo? address,
    EmergencyContact? emergencyContact,
    List<String>? allergies,
    List<String>? chronicConditions,
    String? insuranceProvider,
    String? insurancePolicyNumber,
    double? height,
    double? weight,
    bool? isActive,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insurancePolicyNumber:
          insurancePolicyNumber ?? this.insurancePolicyNumber,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        email,
        firstName,
        lastName,
        phoneNumber,
        dateOfBirth,
        gender,
        bloodGroup,
        profilePhoto,
        address,
        emergencyContact,
        allergies,
        chronicConditions,
        insuranceProvider,
        insurancePolicyNumber,
        height,
        weight,
        isActive,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        updatedAt,
      ];
}

/// Request model for updating patient profile
class UpdatePatientRequest {
  const UpdatePatientRequest({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.emergencyContact,
    this.allergies,
    this.chronicConditions,
    this.insuranceProvider,
    this.insurancePolicyNumber,
    this.height,
    this.weight,
  });

  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final BloodGroup? bloodGroup;
  final AddressInfo? address;
  final EmergencyContact? emergencyContact;
  final List<String>? allergies;
  final List<String>? chronicConditions;
  final String? insuranceProvider;
  final String? insurancePolicyNumber;
  final double? height;
  final double? weight;

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender!.value,
      if (bloodGroup != null) 'bloodGroup': bloodGroup!.value,
      if (address != null) 'address': address!.toJson(),
      if (emergencyContact != null)
        'emergencyContact': emergencyContact!.toJson(),
      if (allergies != null) 'allergies': allergies,
      if (chronicConditions != null) 'chronicConditions': chronicConditions,
      if (insuranceProvider != null) 'insuranceProvider': insuranceProvider,
      if (insurancePolicyNumber != null)
        'insurancePolicyNumber': insurancePolicyNumber,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
    };
  }
}

/// Paginated response for patients
class PaginatedPatients {
  const PaginatedPatients({
    required this.patients,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<PatientModel> patients;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  factory PaginatedPatients.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return PaginatedPatients(
      patients: data
          .map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  bool get hasMore => page < totalPages;
}
