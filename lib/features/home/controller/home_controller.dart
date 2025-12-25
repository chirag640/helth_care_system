import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../records/controller/records_controller.dart';
import '../../records/models/models.dart';
import '../../appointment/controller/appointment_controller.dart';
import '../../appointment/models/models.dart';
import '../../notification/controller/notification_controller.dart';

/// Home state combining data from multiple features
class HomeState {
  const HomeState({
    this.latestPrescriptions = const [],
    this.upcomingAppointments = const [],
    this.unreadNotificationCount = 0,
    this.currentNavIndex = 0,
    this.isLoading = false,
    this.error,
  });

  final List<PrescriptionModel> latestPrescriptions;
  final List<AppointmentModel> upcomingAppointments;
  final int unreadNotificationCount;
  final int currentNavIndex;
  final bool isLoading;
  final String? error;

  HomeState copyWith({
    List<PrescriptionModel>? latestPrescriptions,
    List<AppointmentModel>? upcomingAppointments,
    int? unreadNotificationCount,
    int? currentNavIndex,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      latestPrescriptions: latestPrescriptions ?? this.latestPrescriptions,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Check if there are any active prescriptions
  bool get hasActivePrescriptions => latestPrescriptions.isNotEmpty;

  /// Check if there are upcoming appointments
  bool get hasUpcomingAppointments => upcomingAppointments.isNotEmpty;

  /// Check if there are unread notifications
  bool get hasUnreadNotifications => unreadNotificationCount > 0;
}

/// Home controller that aggregates data from other controllers
class HomeController extends StateNotifier<HomeState> {
  HomeController(this._ref) : super(const HomeState()) {
    _init();
  }

  final Ref _ref;

  void _init() {
    // Listen to records changes
    _ref.listen<RecordsState>(recordsControllerProvider, (previous, next) {
      _updateFromRecords(next);
    });

    // Listen to appointments changes
    _ref.listen<AppointmentState>(appointmentControllerProvider,
        (previous, next) {
      _updateFromAppointments(next);
    });

    // Listen to notifications changes
    _ref.listen<NotificationState>(notificationControllerProvider,
        (previous, next) {
      _updateFromNotifications(next);
    });

    // Initial load
    _loadInitialData();
  }

  void _loadInitialData() {
    final recordsState = _ref.read(recordsControllerProvider);
    final appointmentState = _ref.read(appointmentControllerProvider);
    final notificationState = _ref.read(notificationControllerProvider);

    state = state.copyWith(
      latestPrescriptions: recordsState.activePrescriptions.take(4).toList(),
      upcomingAppointments:
          appointmentState.upcomingAppointments.take(3).toList(),
      unreadNotificationCount: notificationState.unreadCount,
      isLoading: recordsState.isLoading ||
          appointmentState.isLoading ||
          notificationState.isLoading,
    );
  }

  void _updateFromRecords(RecordsState recordsState) {
    state = state.copyWith(
      latestPrescriptions: recordsState.activePrescriptions.take(4).toList(),
      isLoading: recordsState.isLoading,
      error: recordsState.error,
    );
  }

  void _updateFromAppointments(AppointmentState appointmentState) {
    state = state.copyWith(
      upcomingAppointments:
          appointmentState.upcomingAppointments.take(3).toList(),
    );
  }

  void _updateFromNotifications(NotificationState notificationState) {
    state = state.copyWith(
      unreadNotificationCount: notificationState.unreadCount,
    );
  }

  void setNavIndex(int index) {
    state = state.copyWith(currentNavIndex: index);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    // Refresh all data sources
    await Future.wait([
      _ref.read(recordsControllerProvider.notifier).refreshPrescriptions(),
      _ref.read(appointmentControllerProvider.notifier).refreshAppointments(),
      _ref.read(notificationControllerProvider.notifier).loadNotifications(),
    ]);

    state = state.copyWith(isLoading: false);
  }
}

/// Provider for home controller
final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref);
});
