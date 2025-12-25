import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/health_document_api_service.dart';

/// Upload state
class UploadState {
  final List<HealthDocumentModel> documents;
  final bool isLoading;
  final bool isUploading;
  final String? error;
  final double uploadProgress;

  const UploadState({
    this.documents = const [],
    this.isLoading = false,
    this.isUploading = false,
    this.error,
    this.uploadProgress = 0.0,
  });

  UploadState copyWith({
    List<HealthDocumentModel>? documents,
    bool? isLoading,
    bool? isUploading,
    String? error,
    double? uploadProgress,
  }) {
    return UploadState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      error: error,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  /// Get documents grouped by type
  Map<DocumentType, List<HealthDocumentModel>> get documentsByType {
    final grouped = <DocumentType, List<HealthDocumentModel>>{};
    for (final doc in documents) {
      grouped.putIfAbsent(doc.docType, () => []).add(doc);
    }
    return grouped;
  }

  /// Get recent documents (last 7 days)
  List<HealthDocumentModel> get recentDocuments {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return documents
        .where((doc) => doc.createdAt.isAfter(sevenDaysAgo))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get prescriptions
  List<HealthDocumentModel> get prescriptions => documents
      .where((doc) => doc.docType == DocumentType.prescription)
      .toList();

  /// Get lab reports
  List<HealthDocumentModel> get labReports => documents
      .where((doc) =>
          doc.docType == DocumentType.labReport ||
          doc.docType == DocumentType.labTest)
      .toList();
}

/// Upload controller with API integration
class UploadController extends StateNotifier<UploadState> {
  UploadController(this._service) : super(const UploadState()) {
    loadDocuments();
  }

  final HealthDocumentApiService _service;

  /// Load documents from API
  Future<void> loadDocuments() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final documents = await _service.getDocuments();
      state = state.copyWith(
        documents: documents,
        isLoading: false,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to load documents';
      state = state.copyWith(
        isLoading: false,
        error: message.toString(),
      );
      AppLogger.error('Failed to load documents', e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      AppLogger.error('Failed to load documents', e);
    }
  }

  /// Upload a new document from file path
  Future<bool> uploadDocument({
    required String filePath,
    required String patientId,
    required String hospitalId,
    required DocumentType docType,
    String? fileName,
  }) async {
    state = state.copyWith(isUploading: true, error: null, uploadProgress: 0.0);

    try {
      final document = await _service.uploadFile(
        filePath: filePath,
        patientId: patientId,
        hospitalId: hospitalId,
        docType: docType,
        fileName: fileName,
      );

      state = state.copyWith(
        documents: [document, ...state.documents],
        isUploading: false,
        uploadProgress: 1.0,
      );
      return true;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to upload document';
      state = state.copyWith(
        isUploading: false,
        error: message.toString(),
        uploadProgress: 0.0,
      );
      AppLogger.error('Failed to upload document', e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
        uploadProgress: 0.0,
      );
      AppLogger.error('Failed to upload document', e);
      return false;
    }
  }

  /// Create document with existing URL (for URLs from other upload mechanisms)
  Future<bool> createDocument(CreateHealthDocumentRequest request) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final document = await _service.uploadDocument(request);
      state = state.copyWith(
        documents: [document, ...state.documents],
        isUploading: false,
      );
      return true;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to create document';
      state = state.copyWith(
        isUploading: false,
        error: message.toString(),
      );
      AppLogger.error('Failed to create document', e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update document metadata
  Future<bool> updateDocument(
    String id,
    UpdateHealthDocumentRequest request,
  ) async {
    try {
      final updated = await _service.updateDocument(id, request);

      final updatedDocs = state.documents.map((doc) {
        if (doc.id == id) {
          return updated;
        }
        return doc;
      }).toList();

      state = state.copyWith(documents: updatedDocs);
      return true;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to update document';
      state = state.copyWith(error: message.toString());
      AppLogger.error('Failed to update document: $id', e);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete a document
  Future<bool> deleteDocument(String id) async {
    try {
      await _service.deleteDocument(id);

      final updatedDocs = state.documents.where((doc) => doc.id != id).toList();

      state = state.copyWith(documents: updatedDocs);
      return true;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to delete document';
      state = state.copyWith(error: message.toString());
      AppLogger.error('Failed to delete document: $id', e);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Refresh documents
  Future<void> refreshDocuments() async {
    await loadDocuments();
  }

  /// Get documents by type
  Future<void> loadDocumentsByType(DocumentType docType) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final documents = await _service.getDocumentsByType(docType: docType);
      state = state.copyWith(
        documents: documents,
        isLoading: false,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to load documents';
      state = state.copyWith(
        isLoading: false,
        error: message.toString(),
      );
      AppLogger.error('Failed to load documents by type', e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Health document API service provider
final healthDocumentServiceProvider = Provider<HealthDocumentApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return HealthDocumentApiService(client);
});

/// Upload controller provider
final uploadControllerProvider =
    StateNotifierProvider<UploadController, UploadState>((ref) {
  final service = ref.watch(healthDocumentServiceProvider);
  return UploadController(service);
});
