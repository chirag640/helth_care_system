import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// API service for health documents
class HealthDocumentApiService {
  HealthDocumentApiService(this._client);

  final ApiClient _client;

  /// Extract data from wrapped response
  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') && responseData['data'] != null) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    return {};
  }

  /// Extract list from wrapped response
  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') && responseData['data'] != null) {
        final data = responseData['data'];
        if (data is List) {
          return data;
        }
        if (data is Map<String, dynamic>) {
          if (data.containsKey('items')) {
            return data['items'] as List<dynamic>;
          }
        }
      }
      if (responseData.containsKey('items')) {
        return responseData['items'] as List<dynamic>;
      }
    }
    if (responseData is List) {
      return responseData;
    }
    return [];
  }

  /// Get health documents with pagination
  ///
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  Future<List<HealthDocumentModel>> getDocuments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        '/v1/health-documents',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final items = _extractList(response.data);
      return items
          .map((json) =>
              HealthDocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Failed to get documents', e);
      rethrow;
    }
  }

  /// Get a single document by ID
  Future<HealthDocumentModel> getDocumentById(String id) async {
    try {
      final response = await _client.get('/v1/health-documents/$id');
      return HealthDocumentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Failed to get document: $id', e);
      rethrow;
    }
  }

  /// Upload a new health document
  ///
  /// [request] - Document creation request with metadata
  Future<HealthDocumentModel> uploadDocument(
      CreateHealthDocumentRequest request) async {
    try {
      final response = await _client.post(
        '/v1/health-documents',
        data: request.toJson(),
      );
      return HealthDocumentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Failed to upload document', e);
      rethrow;
    }
  }

  /// Upload a file to get a URL, then create the document
  ///
  /// [filePath] - Local file path
  /// [patientId] - Patient GUID
  /// [hospitalId] - Hospital ID
  /// [docType] - Document type
  /// [fileName] - Optional file name
  Future<HealthDocumentModel> uploadFile({
    required String filePath,
    required String patientId,
    required String hospitalId,
    required DocumentType docType,
    String? fileName,
  }) async {
    try {
      // First, upload the file to get a URL
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        'patientId': patientId,
        'documentType': docType.apiValue,
      });

      final uploadResponse = await _client.post(
        '/v1/health-documents/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // If the upload endpoint returns the full document
      if (uploadResponse.data is Map && uploadResponse.data['id'] != null) {
        return HealthDocumentModel.fromJson(_extractData(uploadResponse.data));
      }

      // Try to extract from wrapped response
      final uploadData = _extractData(uploadResponse.data);
      if (uploadData.isNotEmpty && uploadData['id'] != null) {
        return HealthDocumentModel.fromJson(uploadData);
      }

      // If it returns just the URL, create the document record
      final fileUrl = uploadData['fileUrl'] as String? ??
          uploadData['url'] as String? ??
          uploadResponse.data['fileUrl'] as String? ??
          uploadResponse.data['url'] as String?;

      if (fileUrl == null) {
        throw Exception('No file URL returned from upload');
      }

      final request = CreateHealthDocumentRequest(
        patientId: patientId,
        hospitalId: hospitalId,
        docType: docType,
        fileUrl: fileUrl,
        metadata: {
          'fileName': fileName ?? filePath.split('/').last,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      return uploadDocument(request);
    } on DioException catch (e) {
      AppLogger.error('Failed to upload file', e);
      rethrow;
    }
  }

  /// Update document metadata
  Future<HealthDocumentModel> updateDocument(
    String id,
    UpdateHealthDocumentRequest request,
  ) async {
    try {
      final response = await _client.put(
        '/v1/health-documents/$id',
        data: request.toJson(),
      );
      return HealthDocumentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Failed to update document: $id', e);
      rethrow;
    }
  }

  /// Delete a document
  Future<void> deleteDocument(String id) async {
    try {
      await _client.delete('/v1/health-documents/$id');
    } on DioException catch (e) {
      AppLogger.error('Failed to delete document: $id', e);
      rethrow;
    }
  }

  /// Get documents for a specific patient
  Future<List<HealthDocumentModel>> getPatientDocuments({
    required String patientId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        '/v1/health-documents',
        queryParameters: {
          'patientId': patientId,
          'page': page,
          'limit': limit,
        },
      );

      final items = _extractList(response.data);
      return items
          .map((json) =>
              HealthDocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Failed to get patient documents', e);
      rethrow;
    }
  }

  /// Get documents by type
  Future<List<HealthDocumentModel>> getDocumentsByType({
    required DocumentType docType,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        '/v1/health-documents',
        queryParameters: {
          'docType': docType.apiValue,
          'page': page,
          'limit': limit,
        },
      );

      final items = _extractList(response.data);
      return items
          .map((json) =>
              HealthDocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Failed to get documents by type', e);
      rethrow;
    }
  }
}
