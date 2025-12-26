import 'package:equatable/equatable.dart';

/// Gender enum aligned with backend
enum Gender {
  male,
  female,
  other;

  String get value {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }

  String get displayName => value;

  static Gender? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        return null;
    }
  }
}

/// Blood group enum aligned with backend
enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
  unknown;

  String get value {
    switch (this) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
      case BloodGroup.unknown:
        return 'Unknown';
    }
  }

  static BloodGroup fromString(String? value) {
    if (value == null || value.isEmpty) return BloodGroup.unknown;
    switch (value.toUpperCase()) {
      case 'A+':
        return BloodGroup.aPositive;
      case 'A-':
        return BloodGroup.aNegative;
      case 'B+':
        return BloodGroup.bPositive;
      case 'B-':
        return BloodGroup.bNegative;
      case 'AB+':
        return BloodGroup.abPositive;
      case 'AB-':
        return BloodGroup.abNegative;
      case 'O+':
        return BloodGroup.oPositive;
      case 'O-':
        return BloodGroup.oNegative;
      default:
        return BloodGroup.unknown;
    }
  }
}

/// Address info class aligned with backend
class AddressInfo extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  const AddressInfo({
    this.street,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  factory AddressInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AddressInfo();
    return AddressInfo(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (street != null && street!.isNotEmpty) map['street'] = street;
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (state != null && state!.isNotEmpty) map['state'] = state;
    if (zipCode != null && zipCode!.isNotEmpty) map['zipCode'] = zipCode;
    if (country != null && country!.isNotEmpty) map['country'] = country;
    return map;
  }

  bool get isEmpty =>
      (street == null || street!.isEmpty) &&
      (city == null || city!.isEmpty) &&
      (state == null || state!.isEmpty) &&
      (zipCode == null || zipCode!.isEmpty) &&
      (country == null || country!.isEmpty);

  @override
  List<Object?> get props => [street, city, state, zipCode, country];
}

/// Emergency contact class aligned with backend
class EmergencyContact extends Equatable {
  final String? name;
  final String? phoneNumber;
  final String? relationship;

  const EmergencyContact({
    this.name,
    this.phoneNumber,
    this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const EmergencyContact();
    return EmergencyContact(
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      relationship: json['relationship'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null && name!.isNotEmpty) map['name'] = name;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      map['phoneNumber'] = phoneNumber;
    }
    if (relationship != null && relationship!.isNotEmpty) {
      map['relationship'] = relationship;
    }
    return map;
  }

  bool get isEmpty =>
      (name == null || name!.isEmpty) &&
      (phoneNumber == null || phoneNumber!.isEmpty) &&
      (relationship == null || relationship!.isEmpty);

  @override
  List<Object?> get props => [name, phoneNumber, relationship];
}

/// Patient model aligned with backend PatientOutputDto
/// Backend fields: id, guid, fullName, phone, gender, dateOfBirth,
/// address, allergies, chronicDiseases, bloodGroup, emergencyContact,
/// hasSmartphone, idCardIssued, createdAt, updatedAt
class PatientModel extends Equatable {
  final String id;
  final String? guid;
  final String? fullName; // Backend uses fullName, not firstName/lastName
  final String? phone; // Backend uses phone, not phoneNumber
  final Gender? gender;
  final DateTime? dateOfBirth;
  final AddressInfo? address;
  final List<String>? allergies;
  final List<String>? chronicDiseases; // Backend uses chronicDiseases
  final BloodGroup? bloodGroup;
  final EmergencyContact? emergencyContact;
  final bool? hasSmartphone;
  final bool? idCardIssued;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Email is from auth, not patient record - keep for display only
  final String email;
  final String? profilePhoto;

  const PatientModel({
    required this.id,
    this.guid,
    this.fullName,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.allergies,
    this.chronicDiseases,
    this.bloodGroup,
    this.emergencyContact,
    this.hasSmartphone,
    this.idCardIssued,
    this.createdAt,
    this.updatedAt,
    this.email = '',
    this.profilePhoto,
  });

  /// Parse patient from API response
  factory PatientModel.fromJson(Map<String, dynamic> json, {String? email}) {
    return PatientModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      guid: json['guid'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      gender: Gender.fromString(json['gender'] as String?),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      address: json['address'] != null
          ? AddressInfo.fromJson(json['address'] as Map<String, dynamic>?)
          : null,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'] as List)
          : null,
      chronicDiseases: json['chronicDiseases'] != null
          ? List<String>.from(json['chronicDiseases'] as List)
          : null,
      bloodGroup: BloodGroup.fromString(json['bloodGroup'] as String?),
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(
              json['emergencyContact'] as Map<String, dynamic>?)
          : null,
      hasSmartphone: json['hasSmartphone'] as bool?,
      idCardIssued: json['idCardIssued'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      email: email ?? json['email'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String?,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (guid != null) 'guid': guid,
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (gender != null) 'gender': gender!.value,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (address != null && !address!.isEmpty) 'address': address!.toJson(),
      if (allergies != null) 'allergies': allergies,
      if (chronicDiseases != null) 'chronicDiseases': chronicDiseases,
      if (bloodGroup != null && bloodGroup != BloodGroup.unknown)
        'bloodGroup': bloodGroup!.value,
      if (emergencyContact != null && !emergencyContact!.isEmpty)
        'emergencyContact': emergencyContact!.toJson(),
      if (hasSmartphone != null) 'hasSmartphone': hasSmartphone,
      if (idCardIssued != null) 'idCardIssued': idCardIssued,
    };
  }

  /// Create a copy with updated fields
  PatientModel copyWith({
    String? id,
    String? guid,
    String? fullName,
    String? phone,
    Gender? gender,
    DateTime? dateOfBirth,
    AddressInfo? address,
    List<String>? allergies,
    List<String>? chronicDiseases,
    BloodGroup? bloodGroup,
    EmergencyContact? emergencyContact,
    bool? hasSmartphone,
    bool? idCardIssued,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? profilePhoto,
  }) {
    return PatientModel(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      hasSmartphone: hasSmartphone ?? this.hasSmartphone,
      idCardIssued: idCardIssued ?? this.idCardIssued,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  @override
  List<Object?> get props => [
        id,
        guid,
        fullName,
        phone,
        gender,
        dateOfBirth,
        address,
        allergies,
        chronicDiseases,
        bloodGroup,
        emergencyContact,
        hasSmartphone,
        idCardIssued,
        createdAt,
        updatedAt,
        email,
        profilePhoto,
      ];
}

/// Request model for updating patient - aligned with backend UpdatePatientDto
/// Backend fields: guid, fullName, phone, gender, dateOfBirth, address,
/// allergies, chronicDiseases, bloodGroup, emergencyContact, hasSmartphone, idCardIssued
class UpdatePatientRequest {
  final String? guid;
  final String? fullName; // Use fullName, NOT firstName/lastName
  final String? phone; // Use phone, NOT phoneNumber - must match /^[6-9]\d{9}$/
  final Gender? gender;
  final DateTime? dateOfBirth;
  final AddressInfo? address;
  final List<String>? allergies;
  final List<String>?
      chronicDiseases; // Use chronicDiseases, NOT chronicConditions
  final BloodGroup? bloodGroup;
  final EmergencyContact? emergencyContact;
  final bool? hasSmartphone;
  final bool? idCardIssued;

  // Note: height and weight are NOT supported by backend UpdatePatientDto
  // If needed, they should be stored in a separate vital signs record

  const UpdatePatientRequest({
    this.guid,
    this.fullName,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.allergies,
    this.chronicDiseases,
    this.bloodGroup,
    this.emergencyContact,
    this.hasSmartphone,
    this.idCardIssued,
  });

  /// Convert to JSON for API - only include non-null fields
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (guid != null && guid!.isNotEmpty) {
      map['guid'] = guid;
    }
    if (fullName != null && fullName!.isNotEmpty) {
      map['fullName'] = fullName;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    if (gender != null) {
      map['gender'] = gender!.value;
    }
    if (dateOfBirth != null) {
      map['dateOfBirth'] = dateOfBirth!.toIso8601String();
    }
    if (address != null && !address!.isEmpty) {
      map['address'] = address!.toJson();
    }
    if (allergies != null && allergies!.isNotEmpty) {
      map['allergies'] = allergies;
    }
    if (chronicDiseases != null && chronicDiseases!.isNotEmpty) {
      map['chronicDiseases'] = chronicDiseases;
    }
    if (bloodGroup != null && bloodGroup != BloodGroup.unknown) {
      map['bloodGroup'] = bloodGroup!.value;
    }
    if (emergencyContact != null && !emergencyContact!.isEmpty) {
      map['emergencyContact'] = emergencyContact!.toJson();
    }
    if (hasSmartphone != null) {
      map['hasSmartphone'] = hasSmartphone;
    }
    if (idCardIssued != null) {
      map['idCardIssued'] = idCardIssued;
    }

    return map;
  }
}

/// Paginated patients response model
class PaginatedPatients extends Equatable {
  final List<PatientModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedPatients({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedPatients.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List?)
            ?.map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final total = json['total'] as int? ?? items.length;
    final page = json['page'] as int? ?? 1;
    final limit = json['limit'] as int? ?? 10;
    final totalPages = json['totalPages'] as int? ?? ((total / limit).ceil());

    return PaginatedPatients(
      items: items,
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
      hasNextPage: json['hasNextPage'] as bool? ?? (page < totalPages),
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? (page > 1),
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
      };

  @override
  List<Object?> get props => [
        items,
        total,
        page,
        limit,
        totalPages,
        hasNextPage,
        hasPreviousPage,
      ];

  PaginatedPatients copyWith({
    List<PatientModel>? items,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedPatients(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}
