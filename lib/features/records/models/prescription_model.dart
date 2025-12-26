import 'package:equatable/equatable.dart';

/// Prescription status enum matching backend
enum PrescriptionStatus {
  draft('draft'),
  active('active'),
  completed('completed'),
  cancelled('cancelled'),
  stopped('stopped'),
  onHold('on-hold');

  const PrescriptionStatus(this.value);
  final String value;

  static PrescriptionStatus fromString(String value) {
    return PrescriptionStatus.values.firstWhere(
      (status) => status.value.toLowerCase() == value.toLowerCase(),
      orElse: () => PrescriptionStatus.draft,
    );
  }

  String get displayName {
    switch (this) {
      case PrescriptionStatus.draft:
        return 'Draft';
      case PrescriptionStatus.active:
        return 'Active';
      case PrescriptionStatus.completed:
        return 'Completed';
      case PrescriptionStatus.cancelled:
        return 'Cancelled';
      case PrescriptionStatus.stopped:
        return 'Stopped';
      case PrescriptionStatus.onHold:
        return 'On Hold';
    }
  }

  bool get isActive => this == PrescriptionStatus.active;
  bool get isCompleted => this == PrescriptionStatus.completed;
}

/// Medication form enum
enum MedicationForm {
  tablet('tablet'),
  capsule('capsule'),
  syrup('syrup'),
  injection('injection'),
  cream('cream'),
  ointment('ointment'),
  drops('drops'),
  inhaler('inhaler'),
  patch('patch'),
  powder('powder'),
  suspension('suspension'),
  solution('solution'),
  other('other');

  const MedicationForm(this.value);
  final String value;

  static MedicationForm fromString(String value) {
    return MedicationForm.values.firstWhere(
      (form) => form.value.toLowerCase() == value.toLowerCase(),
      orElse: () => MedicationForm.other,
    );
  }

  String get displayName {
    switch (this) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.syrup:
        return 'Syrup';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.ointment:
        return 'Ointment';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.inhaler:
        return 'Inhaler';
      case MedicationForm.patch:
        return 'Patch';
      case MedicationForm.powder:
        return 'Powder';
      case MedicationForm.suspension:
        return 'Suspension';
      case MedicationForm.solution:
        return 'Solution';
      case MedicationForm.other:
        return 'Other';
    }
  }
}

/// Course of therapy enum
enum CourseOfTherapy {
  acute('acute'),
  continuous('continuous'),
  seasonal('seasonal');

  const CourseOfTherapy(this.value);
  final String value;

  static CourseOfTherapy fromString(String value) {
    return CourseOfTherapy.values.firstWhere(
      (course) => course.value.toLowerCase() == value.toLowerCase(),
      orElse: () => CourseOfTherapy.acute,
    );
  }
}

/// Dosage instruction model
class DosageInstruction extends Equatable {
  const DosageInstruction({
    this.sequence,
    this.text,
    this.route,
    this.timing,
    this.doseQuantityValue,
    this.doseQuantityUnit,
    this.frequencyValue,
    this.frequencyPeriod,
    this.frequencyPeriodUnit,
    this.durationValue,
    this.durationUnit,
  });

  final int? sequence;
  final String? text;
  final String? route;
  final String? timing;
  final double? doseQuantityValue;
  final String? doseQuantityUnit;
  final int? frequencyValue;
  final int? frequencyPeriod;
  final String? frequencyPeriodUnit;
  final int? durationValue;
  final String? durationUnit;

  factory DosageInstruction.fromJson(Map<String, dynamic> json) {
    return DosageInstruction(
      sequence: json['sequence'] as int?,
      text: json['text'] as String?,
      route: json['route'] as String?,
      timing: json['timing'] as String?,
      doseQuantityValue: (json['doseQuantityValue'] as num?)?.toDouble(),
      doseQuantityUnit: json['doseQuantityUnit'] as String?,
      frequencyValue: json['frequencyValue'] as int?,
      frequencyPeriod: json['frequencyPeriod'] as int?,
      frequencyPeriodUnit: json['frequencyPeriodUnit'] as String?,
      durationValue: json['durationValue'] as int?,
      durationUnit: json['durationUnit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (sequence != null) 'sequence': sequence,
      if (text != null) 'text': text,
      if (route != null) 'route': route,
      if (timing != null) 'timing': timing,
      if (doseQuantityValue != null) 'doseQuantityValue': doseQuantityValue,
      if (doseQuantityUnit != null) 'doseQuantityUnit': doseQuantityUnit,
      if (frequencyValue != null) 'frequencyValue': frequencyValue,
      if (frequencyPeriod != null) 'frequencyPeriod': frequencyPeriod,
      if (frequencyPeriodUnit != null)
        'frequencyPeriodUnit': frequencyPeriodUnit,
      if (durationValue != null) 'durationValue': durationValue,
      if (durationUnit != null) 'durationUnit': durationUnit,
    };
  }

  /// Get a human-readable dosage summary
  String get summary {
    if (text != null && text!.isNotEmpty) return text!;

    final parts = <String>[];
    if (doseQuantityValue != null && doseQuantityUnit != null) {
      parts.add('${doseQuantityValue!.toInt()} $doseQuantityUnit');
    }
    if (frequencyValue != null) {
      parts.add('$frequencyValue times');
    }
    if (frequencyPeriod != null && frequencyPeriodUnit != null) {
      parts.add('per $frequencyPeriod $frequencyPeriodUnit');
    }
    if (durationValue != null && durationUnit != null) {
      parts.add('for $durationValue $durationUnit');
    }
    return parts.isNotEmpty ? parts.join(' ') : 'As directed';
  }

  @override
  List<Object?> get props => [
        sequence,
        text,
        route,
        timing,
        doseQuantityValue,
        doseQuantityUnit,
        frequencyValue,
        frequencyPeriod,
        frequencyPeriodUnit,
        durationValue,
        durationUnit,
      ];
}

/// Dispense request model
class DispenseRequest extends Equatable {
  const DispenseRequest({
    this.numberOfRepeatsAllowed,
    this.quantityValue,
    this.quantityUnit,
    this.expectedSupplyDurationValue,
    this.expectedSupplyDurationUnit,
    this.validityPeriodStart,
    this.validityPeriodEnd,
  });

  final int? numberOfRepeatsAllowed;
  final double? quantityValue;
  final String? quantityUnit;
  final int? expectedSupplyDurationValue;
  final String? expectedSupplyDurationUnit;
  final DateTime? validityPeriodStart;
  final DateTime? validityPeriodEnd;

  factory DispenseRequest.fromJson(Map<String, dynamic> json) {
    return DispenseRequest(
      numberOfRepeatsAllowed: json['numberOfRepeatsAllowed'] as int?,
      quantityValue: (json['quantityValue'] as num?)?.toDouble(),
      quantityUnit: json['quantityUnit'] as String?,
      expectedSupplyDurationValue: json['expectedSupplyDurationValue'] as int?,
      expectedSupplyDurationUnit: json['expectedSupplyDurationUnit'] as String?,
      validityPeriodStart: json['validityPeriodStart'] != null
          ? DateTime.tryParse(json['validityPeriodStart'] as String)
          : null,
      validityPeriodEnd: json['validityPeriodEnd'] != null
          ? DateTime.tryParse(json['validityPeriodEnd'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (numberOfRepeatsAllowed != null)
        'numberOfRepeatsAllowed': numberOfRepeatsAllowed,
      if (quantityValue != null) 'quantityValue': quantityValue,
      if (quantityUnit != null) 'quantityUnit': quantityUnit,
      if (expectedSupplyDurationValue != null)
        'expectedSupplyDurationValue': expectedSupplyDurationValue,
      if (expectedSupplyDurationUnit != null)
        'expectedSupplyDurationUnit': expectedSupplyDurationUnit,
      if (validityPeriodStart != null)
        'validityPeriodStart': validityPeriodStart!.toIso8601String(),
      if (validityPeriodEnd != null)
        'validityPeriodEnd': validityPeriodEnd!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        numberOfRepeatsAllowed,
        quantityValue,
        quantityUnit,
        expectedSupplyDurationValue,
        expectedSupplyDurationUnit,
        validityPeriodStart,
        validityPeriodEnd,
      ];
}

/// Prescriber information model
class PrescriberInfo extends Equatable {
  const PrescriberInfo({
    this.id,
    this.name,
    this.specialty,
    this.phone,
  });

  final String? id;
  final String? name;
  final String? specialty;
  final String? phone;

  factory PrescriberInfo.fromJson(Map<String, dynamic> json) {
    return PrescriberInfo(
      id: json['_id'] as String? ?? json['id'] as String?,
      name: json['name'] as String? ?? json['fullName'] as String?,
      specialty:
          json['specialty'] as String? ?? json['specialization'] as String?,
      phone: json['phone'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, specialty, phone];
}

/// Main prescription model
class PrescriptionModel extends Equatable {
  const PrescriptionModel({
    required this.id,
    required this.prescriptionNumber,
    required this.status,
    this.patientId,
    this.patientGuid,
    this.prescriberId,
    this.prescriberName,
    this.prescriber,
    required this.medicationName,
    this.medicationCode,
    this.genericName,
    this.form,
    this.strength,
    this.dosageInstructions = const [],
    this.courseOfTherapy,
    this.reasonCode,
    this.reasonText,
    this.notes,
    this.dispenseRequest,
    this.dispensedCount = 0,
    this.refillsRemaining = 0,
    this.isExpired = false,
    this.isControlledSubstance = false,
    this.interactions = const [],
    this.authoredOn,
    this.effectivePeriodStart,
    this.effectivePeriodEnd,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? prescriptionNumber;
  final PrescriptionStatus status;
  final String? patientId;
  final String? patientGuid;
  final String? prescriberId;
  final String? prescriberName;
  final PrescriberInfo? prescriber;
  final String medicationName;
  final String? medicationCode;
  final String? genericName;
  final MedicationForm? form;
  final String? strength;
  final List<DosageInstruction> dosageInstructions;
  final CourseOfTherapy? courseOfTherapy;
  final String? reasonCode;
  final String? reasonText;
  final String? notes;
  final DispenseRequest? dispenseRequest;
  final int dispensedCount;
  final int refillsRemaining;
  final bool isExpired;
  final bool isControlledSubstance;
  final List<String> interactions;
  final DateTime? authoredOn;
  final DateTime? effectivePeriodStart;
  final DateTime? effectivePeriodEnd;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    // Handle populated prescriber object or string ID
    String? prescriberId;
    String? prescriberName;
    PrescriberInfo? prescriberInfo;
    final prescriberRaw = json['prescriber'];
    if (prescriberRaw is Map<String, dynamic>) {
      prescriberId =
          prescriberRaw['_id'] as String? ?? prescriberRaw['id'] as String?;
      prescriberName = prescriberRaw['name'] as String? ??
          prescriberRaw['fullName'] as String?;
      prescriberInfo = PrescriberInfo.fromJson(prescriberRaw);
    } else if (prescriberRaw is String) {
      prescriberId = prescriberRaw;
      prescriberName = json['prescriberName'] as String?;
    }

    // Handle populated patient object or string ID
    String? patientId;
    final patientRaw = json['patient'];
    if (patientRaw is Map<String, dynamic>) {
      patientId = patientRaw['_id'] as String? ?? patientRaw['id'] as String?;
    } else if (patientRaw is String) {
      patientId = patientRaw;
    }

    return PrescriptionModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      prescriptionNumber: json['prescriptionNumber'] as String?,
      status:
          PrescriptionStatus.fromString(json['status'] as String? ?? 'draft'),
      patientId: patientId,
      patientGuid: json['patientGuid'] as String?,
      prescriberId: prescriberId,
      prescriberName: prescriberName ?? json['prescriberName'] as String?,
      prescriber: prescriberInfo,
      medicationName: json['medicationName'] as String? ?? '',
      medicationCode: json['medicationCode'] as String?,
      genericName: json['genericName'] as String?,
      form: json['form'] != null
          ? MedicationForm.fromString(json['form'] as String)
          : null,
      strength: json['strength'] as String?,
      dosageInstructions: (json['dosageInstruction'] as List<dynamic>?)
              ?.map(
                  (e) => DosageInstruction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      courseOfTherapy: json['courseOfTherapy'] != null
          ? CourseOfTherapy.fromString(json['courseOfTherapy'] as String)
          : null,
      reasonCode: json['reasonCode'] as String?,
      reasonText: json['reasonText'] as String?,
      notes: json['notes'] as String?,
      dispenseRequest: json['dispenseRequest'] != null
          ? DispenseRequest.fromJson(
              json['dispenseRequest'] as Map<String, dynamic>)
          : null,
      dispensedCount: json['dispensedCount'] as int? ?? 0,
      refillsRemaining: json['refillsRemaining'] as int? ?? 0,
      isExpired: json['isExpired'] as bool? ?? false,
      isControlledSubstance: json['isControlledSubstance'] as bool? ?? false,
      interactions: (json['interactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      authoredOn: json['authoredOn'] != null
          ? DateTime.tryParse(json['authoredOn'] as String)
          : null,
      effectivePeriodStart: json['effectivePeriodStart'] != null
          ? DateTime.tryParse(json['effectivePeriodStart'] as String)
          : null,
      effectivePeriodEnd: json['effectivePeriodEnd'] != null
          ? DateTime.tryParse(json['effectivePeriodEnd'] as String)
          : null,
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
      '_id': id,
      if (prescriptionNumber != null) 'prescriptionNumber': prescriptionNumber,
      'status': status.value,
      if (patientId != null) 'patient': patientId,
      if (patientGuid != null) 'patientGuid': patientGuid,
      if (prescriberId != null) 'prescriber': prescriberId,
      if (prescriberName != null) 'prescriberName': prescriberName,
      'medicationName': medicationName,
      if (medicationCode != null) 'medicationCode': medicationCode,
      if (genericName != null) 'genericName': genericName,
      if (form != null) 'form': form!.value,
      if (strength != null) 'strength': strength,
      'dosageInstruction': dosageInstructions.map((d) => d.toJson()).toList(),
      if (courseOfTherapy != null) 'courseOfTherapy': courseOfTherapy!.value,
      if (reasonCode != null) 'reasonCode': reasonCode,
      if (reasonText != null) 'reasonText': reasonText,
      if (notes != null) 'notes': notes,
      if (dispenseRequest != null) 'dispenseRequest': dispenseRequest!.toJson(),
      'dispensedCount': dispensedCount,
      'refillsRemaining': refillsRemaining,
      'isExpired': isExpired,
      'isControlledSubstance': isControlledSubstance,
      'interactions': interactions,
      if (authoredOn != null) 'authoredOn': authoredOn!.toIso8601String(),
      if (effectivePeriodStart != null)
        'effectivePeriodStart': effectivePeriodStart!.toIso8601String(),
      if (effectivePeriodEnd != null)
        'effectivePeriodEnd': effectivePeriodEnd!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  PrescriptionModel copyWith({
    String? id,
    String? prescriptionNumber,
    PrescriptionStatus? status,
    String? patientId,
    String? patientGuid,
    String? prescriberId,
    String? prescriberName,
    PrescriberInfo? prescriber,
    String? medicationName,
    String? medicationCode,
    String? genericName,
    MedicationForm? form,
    String? strength,
    List<DosageInstruction>? dosageInstructions,
    CourseOfTherapy? courseOfTherapy,
    String? reasonCode,
    String? reasonText,
    String? notes,
    DispenseRequest? dispenseRequest,
    int? dispensedCount,
    int? refillsRemaining,
    bool? isExpired,
    bool? isControlledSubstance,
    List<String>? interactions,
    DateTime? authoredOn,
    DateTime? effectivePeriodStart,
    DateTime? effectivePeriodEnd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      patientGuid: patientGuid ?? this.patientGuid,
      prescriberId: prescriberId ?? this.prescriberId,
      prescriberName: prescriberName ?? this.prescriberName,
      prescriber: prescriber ?? this.prescriber,
      medicationName: medicationName ?? this.medicationName,
      medicationCode: medicationCode ?? this.medicationCode,
      genericName: genericName ?? this.genericName,
      form: form ?? this.form,
      strength: strength ?? this.strength,
      dosageInstructions: dosageInstructions ?? this.dosageInstructions,
      courseOfTherapy: courseOfTherapy ?? this.courseOfTherapy,
      reasonCode: reasonCode ?? this.reasonCode,
      reasonText: reasonText ?? this.reasonText,
      notes: notes ?? this.notes,
      dispenseRequest: dispenseRequest ?? this.dispenseRequest,
      dispensedCount: dispensedCount ?? this.dispensedCount,
      refillsRemaining: refillsRemaining ?? this.refillsRemaining,
      isExpired: isExpired ?? this.isExpired,
      isControlledSubstance:
          isControlledSubstance ?? this.isControlledSubstance,
      interactions: interactions ?? this.interactions,
      authoredOn: authoredOn ?? this.authoredOn,
      effectivePeriodStart: effectivePeriodStart ?? this.effectivePeriodStart,
      effectivePeriodEnd: effectivePeriodEnd ?? this.effectivePeriodEnd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted medication with strength
  String get medicationWithStrength {
    if (strength != null && strength!.isNotEmpty) {
      return '$medicationName $strength';
    }
    return medicationName;
  }

  /// Get primary dosage instruction summary
  String get dosageSummary {
    if (dosageInstructions.isEmpty) return 'As directed';
    return dosageInstructions.first.summary;
  }

  /// Check if prescription needs refill
  bool get needsRefill => refillsRemaining > 0 && status.isActive;

  /// Check if prescription can be refilled
  bool get canRefill => refillsRemaining > 0 && !isExpired && status.isActive;

  /// Check if can request refill (for UI)
  bool get canRequestRefill => canRefill && status.isActive;

  @override
  List<Object?> get props => [
        id,
        prescriptionNumber,
        status,
        patientId,
        patientGuid,
        prescriberId,
        prescriberName,
        prescriber,
        medicationName,
        medicationCode,
        genericName,
        form,
        strength,
        dosageInstructions,
        courseOfTherapy,
        reasonCode,
        reasonText,
        notes,
        dispenseRequest,
        dispensedCount,
        refillsRemaining,
        isExpired,
        isControlledSubstance,
        interactions,
        authoredOn,
        effectivePeriodStart,
        effectivePeriodEnd,
        createdAt,
        updatedAt,
      ];
}
