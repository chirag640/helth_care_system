import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Notification data model
class NotificationData {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final DateTime timestamp;
  final bool isRead;

  NotificationData({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.timestamp,
    this.isRead = false,
  });
}

/// Notification state
class NotificationState {
  final List<NotificationData> todayNotifications;
  final List<NotificationData> pastNotifications;
  final List<NotificationData> lastWeekNotifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.todayNotifications = const [],
    this.pastNotifications = const [],
    this.lastWeekNotifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationData>? todayNotifications,
    List<NotificationData>? pastNotifications,
    List<NotificationData>? lastWeekNotifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      todayNotifications: todayNotifications ?? this.todayNotifications,
      pastNotifications: pastNotifications ?? this.pastNotifications,
      lastWeekNotifications:
          lastWeekNotifications ?? this.lastWeekNotifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get totalCount =>
      todayNotifications.length +
      pastNotifications.length +
      lastWeekNotifications.length;
}

/// Notification controller
class NotificationController extends StateNotifier<NotificationState> {
  NotificationController() : super(NotificationState()) {
    _loadNotifications();
  }

  /// Load notifications (dummy data)
  Future<void> _loadNotifications() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    final todayNotifications = [
      NotificationData(
        id: '1',
        icon: Icons.videocam_outlined,
        iconColor: const Color(0xFF4D7FFF),
        title: 'Video Call Appointment',
        message:
            "We'll send you a link to join the call at the booking details.",
        time: '5m ago',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationData(
        id: '2',
        icon: Icons.event_available_outlined,
        iconColor: const Color(0xFF9C27B0),
        title: 'Appointment with Dr. Robert',
        message: 'Your appointment is confirmed.',
        time: '21m ago',
        timestamp: now.subtract(const Duration(minutes: 21)),
      ),
      NotificationData(
        id: '3',
        icon: Icons.calendar_today_outlined,
        iconColor: const Color(0xFF4D7FFF),
        title: 'Schedule Changed',
        message:
            'You have successfully changes your appointment with Dr. Joshua Doe.',
        time: '8h ago',
        timestamp: now.subtract(const Duration(hours: 8)),
      ),
      NotificationData(
        id: '4',
        icon: Icons.access_time_outlined,
        iconColor: const Color(0xFF00BCD4),
        title: 'Appointment with Dr. Lector',
        message: 'Your appointment is 30min from now.',
        time: '1w ago',
        timestamp: now.subtract(const Duration(days: 7)),
      ),
    ];

    final pastNotifications = [
      NotificationData(
        id: '5',
        icon: Icons.cancel_outlined,
        iconColor: const Color(0xFFE53935),
        title: 'Appointment Cancelled',
        message:
            'You cancelled your appointment with Dr. Floyd Miles. No funds will be returned to your account.',
        time: '1d ago',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      NotificationData(
        id: '6',
        icon: Icons.payment_outlined,
        iconColor: const Color(0xFF4D7FFF),
        title: 'New Paypal Added',
        message: 'Your PayPal has been successfully linked with your account.',
        time: '23w ago',
        timestamp: now.subtract(const Duration(days: 161)),
      ),
    ];

    state = state.copyWith(
      todayNotifications: todayNotifications.sublist(0, 3),
      pastNotifications: pastNotifications,
      lastWeekNotifications: [todayNotifications[3]],
      isLoading: false,
    );
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    // Dummy implementation
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      todayNotifications: [],
      pastNotifications: [],
      lastWeekNotifications: [],
      isLoading: false,
    );
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await _loadNotifications();
  }
}

/// Notification controller provider
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
  return NotificationController();
});
