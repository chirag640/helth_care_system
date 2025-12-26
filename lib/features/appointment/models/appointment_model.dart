import 'package:equatable/equatable.dart';

/// Appointment status enum matching backend FHIR-compliant statuses
enum AppointmentStatus {
  proposed('proposed'),
  pending('pending'),
  booked('booked'),
  arrived('arrived'),
  fulfilled('fulfilled'),
  cancelled('cancelled'),
  noShow('noshow'),
  enteredInError('entered-in-error'),
  checkedIn('checked-in'),
  waitlist('waitlist');

  const AppointmentStatus(this.value);
  final String value;

  static AppointmentStatus fromString(String value) {
    return AppointmentStatus.values.firstWhere(
      (status) => status.value.toLowerCase() == value.toLowerCase(),
      orElse: () => AppointmentStatus.proposed,
    );
  }

  String get displayName {
    switch (this) {
      case AppointmentStatus.proposed:
        return 'Proposed';
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.booked:
        return 'Booked';
      case AppointmentStatus.arrived:
        return 'Arrived';
      case AppointmentStatus.fulfilled:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
      case AppointmentStatus.enteredInError:
        return 'Error';
      case AppointmentStatus.checkedIn:
        return 'Checked In';
      case AppointmentStatus.waitlist:
        return 'Waitlist';
    }
  }

  bool get isUpcoming =>
      this == AppointmentStatus.proposed ||
      this == AppointmentStatus.pending ||
      this == AppointmentStatus.booked ||
      this == AppointmentStatus.waitlist;

  bool get isPast =>
      this == AppointmentStatus.fulfilled ||
      this == AppointmentStatus.cancelled ||
      this == AppointmentStatus.noShow;
}

/// Appointment type enum matching backend
enum AppointmentType {
  consultation('consultation'),
  followUp('follow-up'),
  emergency('emergency'),
  routineCheckup('routine-checkup'),
  vaccination('vaccination'),
  labTest('lab-test'),
  surgery('surgery'),
  telemedicine('telemedicine');

  const AppointmentType(this.value);
  final String value;

  static AppointmentType fromString(String value) {
    return AppointmentType.values.firstWhere(
      (type) => type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => AppointmentType.consultation,
    );
  }

  String get displayName {
    switch (this) {
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up Visit';
      case AppointmentType.emergency:
        return 'Emergency';
      case AppointmentType.routineCheckup:
        return 'Routine Checkup';
      case AppointmentType.vaccination:
        return 'Vaccination';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.surgery:
        return 'Surgery';
      case AppointmentType.telemedicine:
        return 'Video Consultation';
    }
  }
}

/// Doctor info embedded in appointment
class DoctorInfo extends Equatable {
  const DoctorInfo({
    required this.id,
    required this.name,
    required this.specialty,
    this.phone,
    this.profilePhoto,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String specialty;
  final String? phone;
  final String? profilePhoto;
  final bool isVerified;

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      // Handle both 'name' and 'fullName' from backend
      name: json['name'] as String? ??
          json['fullName'] as String? ??
          'Unknown Doctor',
      // Handle both 'specialty' and 'specialization' from backend
      specialty: json['specialty'] as String? ??
          json['specialization'] as String? ??
          'General Practitioner',
      phone: json['phone'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      if (phone != null) 'phone': phone,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      'isVerified': isVerified,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, specialty, phone, profilePhoto, isVerified];
}

/// Hospital/Location info embedded in appointment
class LocationInfo extends Equatable {
  const LocationInfo({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.state,
    this.zipCode,
  });

  final String id;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Location',
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zipCode': zipCode,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null) parts.add(address!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (zipCode != null) parts.add(zipCode!);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [id, name, address, city, state, zipCode];
}

/// Main Appointment model
class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.hospitalId,
    required this.scheduledAt,
    required this.duration,
    required this.status,
    required this.type,
    this.doctor,
    this.hospital,
    this.reasonForVisit,
    this.notes,
    this.symptoms,
    this.meetingLink,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String hospitalId;
  final DateTime scheduledAt;
  final int duration; // in minutes
  final AppointmentStatus status;
  final AppointmentType type;
  final DoctorInfo? doctor;
  final LocationInfo? hospital;
  final String? reasonForVisit;
  final String? notes;
  final List<String>? symptoms;
  final String? meetingLink;
  final String? cancelReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle scheduledAt: can be direct or derived from appointmentDate + startTime
    DateTime scheduledAt;
    if (json['scheduledAt'] != null) {
      scheduledAt = DateTime.parse(json['scheduledAt'] as String);
    } else if (json['appointmentDate'] != null) {
      // Parse appointmentDate and combine with startTime if available
      final dateStr = json['appointmentDate'] is String
          ? json['appointmentDate'] as String
          : (json['appointmentDate'] as DateTime).toIso8601String();
      final date = DateTime.parse(dateStr);
      final startTime = json['startTime'] as String? ?? '09:00';
      final timeParts = startTime.split(':');
      scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        int.tryParse(timeParts[0]) ?? 9,
        int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0,
      );
    } else {
      scheduledAt = DateTime.now();
    }

    // Handle symptoms: can be String or List
    List<String>? symptoms;
    final symptomsRaw = json['symptoms'];
    if (symptomsRaw is List) {
      symptoms = symptomsRaw.map((e) => e.toString()).toList();
    } else if (symptomsRaw is String && symptomsRaw.isNotEmpty) {
      symptoms = [symptomsRaw];
    }

    return AppointmentModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      hospitalId: json['hospitalId'] as String? ?? '',
      scheduledAt: scheduledAt,
      duration:
          json['duration'] as int? ?? json['durationMinutes'] as int? ?? 30,
      status: AppointmentStatus.fromString(json['status'] as String? ?? ''),
      type: AppointmentType.fromString(
          json['type'] as String? ?? json['appointmentType'] as String? ?? ''),
      doctor: json['doctor'] != null
          ? DoctorInfo.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      hospital: json['hospital'] != null
          ? LocationInfo.fromJson(json['hospital'] as Map<String, dynamic>)
          : null,
      reasonForVisit: json['reasonForVisit'] as String?,
      notes: json['notes'] as String?,
      symptoms: symptoms,
      meetingLink: json['meetingLink'] as String?,
      cancelReason: json['cancelReason'] as String? ??
          json['cancellationReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'hospitalId': hospitalId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'duration': duration,
      'status': status.value,
      'type': type.value,
      if (doctor != null) 'doctor': doctor!.toJson(),
      if (hospital != null) 'hospital': hospital!.toJson(),
      if (reasonForVisit != null) 'reasonForVisit': reasonForVisit,
      if (notes != null) 'notes': notes,
      if (symptoms != null) 'symptoms': symptoms,
      if (meetingLink != null) 'meetingLink': meetingLink,
      if (cancelReason != null) 'cancelReason': cancelReason,
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? hospitalId,
    DateTime? scheduledAt,
    int? duration,
    AppointmentStatus? status,
    AppointmentType? type,
    DoctorInfo? doctor,
    LocationInfo? hospital,
    String? reasonForVisit,
    String? notes,
    List<String>? symptoms,
    String? meetingLink,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      hospitalId: hospitalId ?? this.hospitalId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      type: type ?? this.type,
      doctor: doctor ?? this.doctor,
      hospital: hospital ?? this.hospital,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      meetingLink: meetingLink ?? this.meetingLink,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get end time based on scheduled time and duration
  DateTime get endTime => scheduledAt.add(Duration(minutes: duration));

  /// Check if appointment is upcoming
  bool get isUpcoming =>
      status.isUpcoming && scheduledAt.isAfter(DateTime.now());

  /// Check if appointment is past
  bool get isPast => status.isPast || scheduledAt.isBefore(DateTime.now());

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        hospitalId,
        scheduledAt,
        duration,
        status,
        type,
        doctor,
        hospital,
        reasonForVisit,
        notes,
        symptoms,
        meetingLink,
        cancelReason,
        createdAt,
        updatedAt,
      ];
}

/// Request model for creating appointment
class CreateAppointmentRequest {
  const CreateAppointmentRequest({
    required this.doctorId,
    required this.hospitalId,
    required this.scheduledAt,
    required this.type,
    this.duration = 30,
    this.reasonForVisit,
    this.symptoms,
    this.notes,
  });

  final String doctorId;
  final String hospitalId;
  final DateTime scheduledAt;
  final AppointmentType type;
  final int duration;
  final String? reasonForVisit;
  final List<String>? symptoms;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'hospitalId': hospitalId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'type': type.value,
      'duration': duration,
      if (reasonForVisit != null) 'reasonForVisit': reasonForVisit,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Request model for updating appointment
class UpdateAppointmentRequest {
  const UpdateAppointmentRequest({
    this.scheduledAt,
    this.type,
    this.duration,
    this.reasonForVisit,
    this.symptoms,
    this.notes,
  });

  final DateTime? scheduledAt;
  final AppointmentType? type;
  final int? duration;
  final String? reasonForVisit;
  final List<String>? symptoms;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      if (scheduledAt != null) 'scheduledAt': scheduledAt!.toIso8601String(),
      if (type != null) 'type': type!.value,
      if (duration != null) 'duration': duration,
      if (reasonForVisit != null) 'reasonForVisit': reasonForVisit,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Request model for updating appointment status
class UpdateAppointmentStatusRequest {
  const UpdateAppointmentStatusRequest({
    required this.status,
    this.cancelReason,
  });

  final AppointmentStatus status;
  final String? cancelReason;

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      if (cancelReason != null) 'cancelReason': cancelReason,
    };
  }
}

/// Appointment availability slot
class AvailabilitySlot extends Equatable {
  const AvailabilitySlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];
}

/// Appointment statistics
class AppointmentStats extends Equatable {
  const AppointmentStats({
    required this.total,
    required this.upcoming,
    required this.completed,
    required this.cancelled,
  });

  final int total;
  final int upcoming;
  final int completed;
  final int cancelled;

  factory AppointmentStats.fromJson(Map<String, dynamic> json) {
    return AppointmentStats(
      total: json['total'] as int? ?? 0,
      upcoming: json['upcoming'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [total, upcoming, completed, cancelled];
}

/// Paginated response for appointments
class PaginatedAppointments {
  const PaginatedAppointments({
    required this.appointments,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<AppointmentModel> appointments;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  factory PaginatedAppointments.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return PaginatedAppointments(
      appointments: data
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  bool get hasMore => page < totalPages;
}
