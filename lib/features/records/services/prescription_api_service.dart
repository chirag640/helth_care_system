import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// API service for prescriptions/records
class PrescriptionApiService {
  PrescriptionApiService(this._client);

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

  /// Get prescriptions with optional filters
  ///
  /// [patientId] - Filter by patient ID
  /// [status] - Filter by status (active, completed, cancelled, etc.)
  /// [medicationName] - Search by medication name
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  Future<List<PrescriptionModel>> getPrescriptions({
    String? patientId,
    String? status,
    String? medicationName,
    bool? isExpired,
    bool? hasRefillsAvailable,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (patientId != null) queryParams['patient'] = patientId;
      if (status != null) queryParams['status'] = status;
      if (medicationName != null)
        queryParams['medicationName'] = medicationName;
      if (isExpired != null) queryParams['isExpired'] = isExpired;
      if (hasRefillsAvailable != null) {
        queryParams['hasRefillsAvailable'] = hasRefillsAvailable;
      }

      final response = await _client.get(
        '/v1/prescriptions',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error(
          'Get prescriptions failed', e, stack, 'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get a specific prescription by ID
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    try {
      final response = await _client.get('/v1/prescriptions/$id');
      return PrescriptionModel.fromJson(_extractData(response.data));
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error(
          'Get prescription by ID failed', e, stack, 'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get prescription by prescription number (e.g., RX-2024-000123)
  Future<PrescriptionModel> getPrescriptionByNumber(
      String prescriptionNumber) async {
    try {
      final response =
          await _client.get('/v1/prescriptions/number/$prescriptionNumber');
      return PrescriptionModel.fromJson(_extractData(response.data));
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Get prescription by number failed', e, stack,
          'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get active prescriptions for a patient
  Future<List<PrescriptionModel>> getActivePrescriptions(
      String patientId) async {
    try {
      final response =
          await _client.get('/v1/prescriptions/patient/$patientId/active');

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Get active prescriptions failed', e, stack,
          'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get prescriptions needing refill for a patient
  Future<List<PrescriptionModel>> getPrescriptionsNeedingRefill(
      String patientId) async {
    try {
      final response = await _client
          .get('/v1/prescriptions/patient/$patientId/needing-refill');

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Get prescriptions needing refill failed', e, stack,
          'PrescriptionApiService');
      rethrow;
    }
  }

  /// Search prescriptions by medication name
  Future<List<PrescriptionModel>> searchPrescriptions(String query,
      {int limit = 20}) async {
    try {
      final response = await _client.get(
        '/v1/prescriptions/search',
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error(
          'Search prescriptions failed', e, stack, 'PrescriptionApiService');
      rethrow;
    }
  }

  /// Request a refill for a prescription
  Future<PrescriptionModel> requestRefill(String prescriptionId) async {
    try {
      final response =
          await _client.post('/v1/prescriptions/$prescriptionId/refill');
      return PrescriptionModel.fromJson(_extractData(response.data));
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error(
          'Request refill failed', e, stack, 'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get prescription history for a patient (all statuses)
  Future<List<PrescriptionModel>> getPrescriptionHistory({
    required String patientId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        '/v1/prescriptions',
        queryParameters: {
          'patient': patientId,
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Get prescription history failed', e, stack,
          'PrescriptionApiService');
      rethrow;
    }
  }

  /// Get current patient's prescriptions (auto-filtered by backend for Patient role)
  Future<List<PrescriptionModel>> getMyPrescriptions({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (status != null) queryParams['status'] = status;

      // Backend automatically filters by patient for Patient role users
      final response = await _client.get(
        '/v1/prescriptions',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final innerData = data['data'];
        // Handle paginated response with 'items' array
        if (innerData is Map<String, dynamic> &&
            innerData.containsKey('items')) {
          final list = innerData['items'] as List<dynamic>;
          return list
              .map((json) =>
                  PrescriptionModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        // Handle direct array response
        if (innerData is List) {
          return innerData
              .map((json) =>
                  PrescriptionModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      } else if (data is List) {
        return data
            .map((json) =>
                PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } catch (e, stack) {
      AppLogger.error(
          'Get my prescriptions failed', e, stack, 'PrescriptionApiService');
      rethrow;
    }
  }
}
