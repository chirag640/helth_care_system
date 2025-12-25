import 'package:equatable/equatable.dart';

/// Document type enum
enum DocumentType {
  prescription,
  labReport,
  labTest,
  medication,
  imaging,
  discharge,
  insurance,
  other;

  String get displayName {
    switch (this) {
      case DocumentType.prescription:
        return 'Prescription';
      case DocumentType.labReport:
        return 'Lab Report';
      case DocumentType.labTest:
        return 'Lab Test';
      case DocumentType.medication:
        return 'Medication';
      case DocumentType.imaging:
        return 'Imaging';
      case DocumentType.discharge:
        return 'Discharge Summary';
      case DocumentType.insurance:
        return 'Insurance';
      case DocumentType.other:
        return 'Other';
    }
  }

  String get apiValue {
    switch (this) {
      case DocumentType.prescription:
        return 'prescription';
      case DocumentType.labReport:
        return 'lab_report';
      case DocumentType.labTest:
        return 'lab_test';
      case DocumentType.medication:
        return 'medication';
      case DocumentType.imaging:
        return 'imaging';
      case DocumentType.discharge:
        return 'discharge';
      case DocumentType.insurance:
        return 'insurance';
      case DocumentType.other:
        return 'other';
    }
  }

  static DocumentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'prescription':
        return DocumentType.prescription;
      case 'lab_report':
      case 'labreport':
        return DocumentType.labReport;
      case 'lab_test':
      case 'labtest':
        return DocumentType.labTest;
      case 'medication':
        return DocumentType.medication;
      case 'imaging':
        return DocumentType.imaging;
      case 'discharge':
        return DocumentType.discharge;
      case 'insurance':
        return DocumentType.insurance;
      default:
        return DocumentType.other;
    }
  }
}

/// Health document model matching backend API
class HealthDocumentModel extends Equatable {
  final String id;
  final String patientId;
  final String hospitalId;
  final String? encounterId;
  final DocumentType docType;
  final String fileUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HealthDocumentModel({
    required this.id,
    required this.patientId,
    required this.hospitalId,
    this.encounterId,
    required this.docType,
    required this.fileUrl,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from API JSON
  factory HealthDocumentModel.fromJson(Map<String, dynamic> json) {
    return HealthDocumentModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      hospitalId: json['hospitalId'] as String? ?? '',
      encounterId: json['encounterId'] as String?,
      docType: DocumentType.fromString(json['docType'] as String? ?? 'other'),
      fileUrl: json['fileUrl'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'hospitalId': hospitalId,
      if (encounterId != null) 'encounterId': encounterId,
      'docType': docType.apiValue,
      'fileUrl': fileUrl,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get file name from URL or metadata
  String get fileName {
    if (metadata.containsKey('fileName')) {
      return metadata['fileName'] as String;
    }
    // Extract from URL
    final uri = Uri.tryParse(fileUrl);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return 'Document';
  }

  /// Get file extension
  String get fileExtension {
    final name = fileName;
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < name.length - 1) {
      return name.substring(dotIndex + 1).toLowerCase();
    }
    return '';
  }

  /// Check if document is an image
  bool get isImage {
    final ext = fileExtension;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  /// Check if document is a PDF
  bool get isPdf => fileExtension == 'pdf';

  HealthDocumentModel copyWith({
    String? id,
    String? patientId,
    String? hospitalId,
    String? encounterId,
    DocumentType? docType,
    String? fileUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthDocumentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      hospitalId: hospitalId ?? this.hospitalId,
      encounterId: encounterId ?? this.encounterId,
      docType: docType ?? this.docType,
      fileUrl: fileUrl ?? this.fileUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        hospitalId,
        encounterId,
        docType,
        fileUrl,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Request model for creating a health document
class CreateHealthDocumentRequest {
  final String patientId;
  final String hospitalId;
  final String? encounterId;
  final DocumentType docType;
  final String fileUrl;
  final Map<String, dynamic>? metadata;

  const CreateHealthDocumentRequest({
    required this.patientId,
    required this.hospitalId,
    this.encounterId,
    required this.docType,
    required this.fileUrl,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'hospitalId': hospitalId,
      if (encounterId != null) 'encounterId': encounterId,
      'docType': docType.apiValue,
      'fileUrl': fileUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Request model for updating a health document
class UpdateHealthDocumentRequest {
  final DocumentType? docType;
  final Map<String, dynamic>? metadata;

  const UpdateHealthDocumentRequest({
    this.docType,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      if (docType != null) 'docType': docType!.apiValue,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
