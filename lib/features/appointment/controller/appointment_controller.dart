import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/appointment_api_service.dart';

/// Appointment state
class AppointmentState {
  const AppointmentState({
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    this.todayAppointments = const [],
    this.stats,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> pastAppointments;
  final List<AppointmentModel> todayAppointments;
  final AppointmentStats? stats;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  AppointmentState copyWith({
    List<AppointmentModel>? upcomingAppointments,
    List<AppointmentModel>? pastAppointments,
    List<AppointmentModel>? todayAppointments,
    AppointmentStats? stats,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return AppointmentState(
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Get all appointments count
  int get totalCount =>
      upcomingAppointments.length +
      pastAppointments.length +
      todayAppointments.length;
}

/// Appointment controller with real API integration
class AppointmentController extends StateNotifier<AppointmentState> {
  AppointmentController(this._service) : super(const AppointmentState()) {
    loadAppointments();
  }

  final AppointmentApiService _service;

  /// Load all appointments
  Future<void> loadAppointments() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load appointments
      final paginatedAppointments =
          await _service.getAppointments(page: 1, limit: 50);

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final upcoming = <AppointmentModel>[];
      final past = <AppointmentModel>[];
      final today = <AppointmentModel>[];

      for (final appointment in paginatedAppointments.appointments) {
        if (appointment.scheduledAt.isAfter(todayStart) &&
            appointment.scheduledAt.isBefore(todayEnd)) {
          today.add(appointment);
        }

        if (appointment.status.isUpcoming &&
            appointment.scheduledAt.isAfter(now)) {
          upcoming.add(appointment);
        } else {
          past.add(appointment);
        }
      }

      // Sort by date
      upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      past.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
      today.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      // Calculate stats from appointments
      final stats = AppointmentStats(
        total: paginatedAppointments.appointments.length,
        upcoming: upcoming.length,
        completed: paginatedAppointments.appointments
            .where((a) => a.status == AppointmentStatus.completed)
            .length,
        cancelled: paginatedAppointments.appointments
            .where((a) => a.status == AppointmentStatus.cancelled)
            .length,
      );

      state = state.copyWith(
        upcomingAppointments: upcoming,
        pastAppointments: past,
        todayAppointments: today,
        stats: stats,
        isLoading: false,
        currentPage: 1,
        hasMore: paginatedAppointments.hasMore,
      );
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error(
          'Load appointments failed', e, null, 'AppointmentController');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error(
          'Load appointments failed', e, null, 'AppointmentController');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load appointments',
      );
    }
  }

  /// Load more appointments (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _service.getAppointments(page: nextPage, limit: 20);

      final now = DateTime.now();
      final newUpcoming = [...state.upcomingAppointments];
      final newPast = [...state.pastAppointments];

      for (final appointment in result.appointments) {
        if (appointment.status.isUpcoming &&
            appointment.scheduledAt.isAfter(now)) {
          newUpcoming.add(appointment);
        } else {
          newPast.add(appointment);
        }
      }

      state = state.copyWith(
        upcomingAppointments: newUpcoming,
        pastAppointments: newPast,
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Load more appointments failed', e, null, 'AppointmentController');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh appointments
  Future<void> refreshAppointments() async {
    state = state.copyWith(currentPage: 1, hasMore: true);
    await loadAppointments();
  }

  /// Create a new appointment
  Future<AppointmentModel?> createAppointment(
      CreateAppointmentRequest request) async {
    try {
      final appointment = await _service.createAppointment(request);

      // Add to upcoming if it's in the future
      if (appointment.scheduledAt.isAfter(DateTime.now())) {
        final newUpcoming = [appointment, ...state.upcomingAppointments];
        newUpcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        state = state.copyWith(upcomingAppointments: newUpcoming);
      }

      return appointment;
    } on DioException catch (e) {
      AppLogger.error(
          'Create appointment failed', e, null, 'AppointmentController');
      state = state.copyWith(error: _getErrorMessage(e));
      return null;
    }
  }

  /// Cancel an appointment
  Future<bool> cancelAppointment(String id, {String? reason}) async {
    try {
      await _service.cancelAppointment(id, reason: reason);

      // Move from upcoming to past
      final upcoming =
          state.upcomingAppointments.where((a) => a.id != id).toList();
      final cancelledAppointment = state.upcomingAppointments.firstWhere(
          (a) => a.id == id,
          orElse: () => state.pastAppointments.first);

      final updatedCancelled = cancelledAppointment.copyWith(
        status: AppointmentStatus.cancelled,
        cancelReason: reason,
      );

      final past = [updatedCancelled, ...state.pastAppointments];

      state = state.copyWith(
        upcomingAppointments: upcoming,
        pastAppointments: past,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error(
          'Cancel appointment failed', e, null, 'AppointmentController');
      state = state.copyWith(error: _getErrorMessage(e));
      return false;
    }
  }

  /// Reschedule an appointment
  Future<AppointmentModel?> rescheduleAppointment({
    required String id,
    required DateTime newDateTime,
  }) async {
    try {
      final updated = await _service.rescheduleAppointment(
        id: id,
        newScheduledAt: newDateTime,
      );

      // Update in list
      final upcoming = state.upcomingAppointments.map((a) {
        return a.id == id ? updated : a;
      }).toList();

      upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = state.copyWith(upcomingAppointments: upcoming);

      return updated;
    } on DioException catch (e) {
      AppLogger.error(
          'Reschedule appointment failed', e, null, 'AppointmentController');
      state = state.copyWith(error: _getErrorMessage(e));
      return null;
    }
  }

  /// Get appointment by ID
  Future<AppointmentModel?> getAppointmentById(String id) async {
    try {
      return await _service.getAppointment(id);
    } on DioException catch (e) {
      AppLogger.error(
          'Get appointment failed', e, null, 'AppointmentController');
      return null;
    }
  }

  /// Check doctor availability
  Future<List<AvailabilitySlot>> checkAvailability({
    required String doctorId,
    required DateTime date,
    int duration = 30,
  }) async {
    try {
      return await _service.checkAvailability(
        doctorId: doctorId,
        date: date,
        duration: duration,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Check availability failed', e, null, 'AppointmentController');
      return [];
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  String _getErrorMessage(DioException e) {
    if (e.response?.data != null && e.response!.data is Map) {
      final data = e.response!.data as Map;
      return data['message']?.toString() ?? 'An error occurred';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Appointment controller provider
final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, AppointmentState>((ref) {
  final service = ref.watch(appointmentApiServiceProvider);
  return AppointmentController(service);
});

/// Selected appointment provider for detail view
final selectedAppointmentProvider =
    StateProvider<AppointmentModel?>((ref) => null);

/// Appointment stats provider
final appointmentStatsProvider = FutureProvider<AppointmentStats>((ref) async {
  final service = ref.watch(appointmentApiServiceProvider);
  return service.getAppointmentStats();
});
