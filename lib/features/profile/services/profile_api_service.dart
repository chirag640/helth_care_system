import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/auth/token_storage.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// Profile/Patient API Service - handles all patient profile-related API calls
class ProfileApiService {
  ProfileApiService(this._apiClient);

  final ApiClient _apiClient;

  static const String _basePath = '/v1/patients';

  /// Get patient profile by ID
  Future<PatientModel> getPatient(String patientId) async {
    try {
      final response = await _apiClient.get('$_basePath/$patientId');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          return PatientModel.fromJson(
              responseData['data'] as Map<String, dynamic>);
        }
        return PatientModel.fromJson(responseData);
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      AppLogger.error('Get patient failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Get current user's patient profile using stored patient ID
  /// Returns null if no patient profile exists (user needs to complete profile)
  Future<PatientModel?> getCurrentPatient() async {
    try {
      // Get patientId from storage (set after login via /auth/me)
      final patientId = TokenStorage.instance.getPatientId();

      if (patientId == null || patientId.isEmpty) {
        // No patient profile linked to this user yet
        AppLogger.info(
            'No patientId found - user needs to complete profile setup',
            'ProfileService');
        return null;
      }

      // Use the patient ID to fetch patient profile
      return getPatient(patientId);
    } on DioException catch (e) {
      // If 404, patient profile doesn't exist
      if (e.response?.statusCode == 404) {
        AppLogger.info(
            'Patient profile not found - user needs to complete profile setup',
            'ProfileService');
        return null;
      }
      AppLogger.error('Get current patient failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Update patient profile
  Future<PatientModel> updatePatient(
    String patientId,
    UpdatePatientRequest request,
  ) async {
    try {
      // Using PATCH to match backend API (which uses @Patch decorator)
      final response = await _apiClient.patch(
        '$_basePath/$patientId',
        data: request.toJson(),
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error('Update patient failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String patientId, File photo) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        '$_basePath/$patientId/photo',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      // Handle wrapped response
      if (data.containsKey('data') && data['data'] is Map) {
        return (data['data'] as Map)['photoUrl']?.toString() ?? '';
      }
      return data['photoUrl']?.toString() ?? '';
    } on DioException catch (e) {
      AppLogger.error('Upload profile photo failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String patientId) async {
    try {
      await _apiClient.delete('$_basePath/$patientId/photo');
    } on DioException catch (e) {
      AppLogger.error('Delete profile photo failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Get all patients (admin only)
  Future<PaginatedPatients> getAllPatients({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        _basePath,
        queryParameters: queryParams,
      );

      return PaginatedPatients.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Get all patients failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Search patients
  Future<List<PatientModel>> searchPatients(String query) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/search',
        queryParameters: {'q': query},
      );

      final data = _extractData(response.data);
      if (data['items'] is List) {
        return (data['items'] as List)
            .map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (response.data is List) {
        return (response.data as List)
            .map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      AppLogger.error('Search patients failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Update emergency contact
  Future<PatientModel> updateEmergencyContact(
    String patientId,
    EmergencyContact contact,
  ) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$patientId',
        data: {'emergencyContact': contact.toJson()},
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error(
          'Update emergency contact failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Update address
  Future<PatientModel> updateAddress(
    String patientId,
    AddressInfo address,
  ) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$patientId',
        data: {'address': address.toJson()},
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error('Update address failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Add allergy
  Future<PatientModel> addAllergy(String patientId, String allergy) async {
    try {
      final response = await _apiClient.post(
        '$_basePath/$patientId/allergies',
        data: {'allergy': allergy},
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error('Add allergy failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Remove allergy
  Future<PatientModel> removeAllergy(String patientId, String allergy) async {
    try {
      final response = await _apiClient.delete(
        '$_basePath/$patientId/allergies',
        data: {'allergy': allergy},
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error('Remove allergy failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Update insurance info
  Future<PatientModel> updateInsurance(
    String patientId, {
    required String provider,
    required String policyNumber,
  }) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$patientId',
        data: {
          'insuranceProvider': provider,
          'insurancePolicyNumber': policyNumber,
        },
      );
      return _parsePatientResponse(response.data);
    } on DioException catch (e) {
      AppLogger.error('Update insurance failed', e, null, 'ProfileService');
      rethrow;
    }
  }

  /// Helper to parse patient from wrapped response
  PatientModel _parsePatientResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return PatientModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return PatientModel.fromJson(data);
    }
    throw Exception('Invalid response format');
  }

  /// Helper to extract data from wrapped response
  Map<String, dynamic> _extractData(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return <String, dynamic>{};
  }
}
