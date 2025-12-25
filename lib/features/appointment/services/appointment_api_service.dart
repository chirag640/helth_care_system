import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// Appointment API Service - handles all appointment-related API calls
class AppointmentApiService {
  AppointmentApiService(this._apiClient);

  final ApiClient _apiClient;

  static const String _basePath = '/v1/appointments';

  /// Helper to extract data from wrapped response
  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    return <String, dynamic>{};
  }

  /// Helper to extract list from wrapped response
  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data') && responseData['data'] is List) {
        return responseData['data'] as List;
      }
      if (responseData.containsKey('items') && responseData['items'] is List) {
        return responseData['items'] as List;
      }
    }
    return [];
  }

  /// Get all appointments with pagination and filters
  Future<PaginatedAppointments> getAppointments({
    int page = 1,
    int limit = 10,
    AppointmentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status.value;
      }
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        _basePath,
        queryParameters: queryParams,
      );

      return PaginatedAppointments.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Get appointments failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Get single appointment by ID
  Future<AppointmentModel> getAppointment(String id) async {
    try {
      final response = await _apiClient.get('$_basePath/$id');
      return AppointmentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Get appointment failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Create a new appointment
  Future<AppointmentModel> createAppointment(
      CreateAppointmentRequest request) async {
    try {
      final response = await _apiClient.post(
        _basePath,
        data: request.toJson(),
      );
      return AppointmentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Create appointment failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Update an existing appointment
  Future<AppointmentModel> updateAppointment(
    String id,
    UpdateAppointmentRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$id',
        data: request.toJson(),
      );
      return AppointmentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Update appointment failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Cancel an appointment
  Future<void> cancelAppointment(String id, {String? reason}) async {
    try {
      await _apiClient.delete(
        '$_basePath/$id',
        data: reason != null ? {'cancelReason': reason} : null,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Cancel appointment failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Update appointment status
  Future<AppointmentModel> updateAppointmentStatus(
    String id,
    UpdateAppointmentStatusRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$id/status',
        data: request.toJson(),
      );
      return AppointmentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Update appointment status failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Get appointments by date range
  Future<List<AppointmentModel>> getAppointmentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/range',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final data = _extractList(response.data);
      return data
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Get appointments by date range failed', e, null,
          'AppointmentService');
      rethrow;
    }
  }

  /// Get appointments for a specific patient
  Future<PaginatedAppointments> getPatientAppointments(
    String patientId, {
    int page = 1,
    int limit = 10,
    AppointmentStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await _apiClient.get(
        '$_basePath/patient/$patientId',
        queryParameters: queryParams,
      );

      return PaginatedAppointments.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Get patient appointments failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Get appointments for a specific doctor
  Future<PaginatedAppointments> getDoctorAppointments(
    String doctorId, {
    int page = 1,
    int limit = 10,
    AppointmentStatus? status,
    DateTime? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status.value;
      }
      if (date != null) {
        queryParams['date'] = date.toIso8601String();
      }

      final response = await _apiClient.get(
        '$_basePath/doctor/$doctorId',
        queryParameters: queryParams,
      );

      return PaginatedAppointments.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Get doctor appointments failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Check availability for a specific doctor on a date
  Future<List<AvailabilitySlot>> checkAvailability({
    required String doctorId,
    required DateTime date,
    int duration = 30,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/check-availability',
        queryParameters: {
          'doctorId': doctorId,
          'date': date.toIso8601String(),
          'duration': duration,
        },
      );

      final data = _extractList(response.data);
      return data
          .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error(
          'Check availability failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Get appointment statistics
  Future<AppointmentStats> getAppointmentStats({String? patientId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (patientId != null) {
        queryParams['patientId'] = patientId;
      }

      final response = await _apiClient.get(
        '$_basePath/stats',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return AppointmentStats.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Get appointment stats failed', e, null, 'AppointmentService');
      rethrow;
    }
  }

  /// Reschedule an appointment
  Future<AppointmentModel> rescheduleAppointment({
    required String id,
    required DateTime newScheduledAt,
  }) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$id',
        data: {'scheduledAt': newScheduledAt.toIso8601String()},
      );
      return AppointmentModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Reschedule appointment failed', e, null, 'AppointmentService');
      rethrow;
    }
  }
}
