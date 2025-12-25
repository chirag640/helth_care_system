import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';
import '../services/notification_api_service.dart';

/// Notification state
class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.todayNotifications = const [],
    this.thisWeekNotifications = const [],
    this.olderNotifications = const [],
    this.unreadCount = 0,
    this.preferences,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isUpdating = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  final List<NotificationModel> notifications;
  final List<NotificationModel> todayNotifications;
  final List<NotificationModel> thisWeekNotifications;
  final List<NotificationModel> olderNotifications;
  final int unreadCount;
  final NotificationPreferences? preferences;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isUpdating;
  final String? error;
  final int currentPage;
  final bool hasMore;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    List<NotificationModel>? todayNotifications,
    List<NotificationModel>? thisWeekNotifications,
    List<NotificationModel>? olderNotifications,
    int? unreadCount,
    NotificationPreferences? preferences,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isUpdating,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      todayNotifications: todayNotifications ?? this.todayNotifications,
      thisWeekNotifications:
          thisWeekNotifications ?? this.thisWeekNotifications,
      olderNotifications: olderNotifications ?? this.olderNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Get total notification count
  int get totalCount => notifications.length;

  /// Check if there are any unread notifications
  bool get hasUnread => unreadCount > 0;
}

/// Notification controller with real API integration
class NotificationController extends StateNotifier<NotificationState> {
  NotificationController(this._service) : super(const NotificationState()) {
    loadNotifications();
  }

  final NotificationApiService _service;

  /// Load notifications
  Future<void> loadNotifications() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load notifications and unread count in parallel
      final results = await Future.wait([
        _service.getNotifications(page: 1, limit: 50),
        _service.getUnreadCount(),
      ]);

      final paginatedNotifications = results[0] as PaginatedNotifications;
      final unreadCount = results[1] as UnreadCount;

      // Group notifications by date
      final today = <NotificationModel>[];
      final thisWeek = <NotificationModel>[];
      final older = <NotificationModel>[];

      for (final notification in paginatedNotifications.notifications) {
        if (notification.isToday) {
          today.add(notification);
        } else if (notification.isThisWeek) {
          thisWeek.add(notification);
        } else {
          older.add(notification);
        }
      }

      state = state.copyWith(
        notifications: paginatedNotifications.notifications,
        todayNotifications: today,
        thisWeekNotifications: thisWeek,
        olderNotifications: older,
        unreadCount: unreadCount.total,
        isLoading: false,
        currentPage: 1,
        hasMore: paginatedNotifications.hasMore,
      );
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      AppLogger.error(
          'Load notifications failed', e, null, 'NotificationController');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error(
          'Load notifications failed', e, null, 'NotificationController');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications',
      );
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _service.getNotifications(page: nextPage, limit: 20);

      final allNotifications = [
        ...state.notifications,
        ...result.notifications
      ];

      // Regroup
      final today = <NotificationModel>[];
      final thisWeek = <NotificationModel>[];
      final older = <NotificationModel>[];

      for (final notification in allNotifications) {
        if (notification.isToday) {
          today.add(notification);
        } else if (notification.isThisWeek) {
          thisWeek.add(notification);
        } else {
          older.add(notification);
        }
      }

      state = state.copyWith(
        notifications: allNotifications,
        todayNotifications: today,
        thisWeekNotifications: thisWeek,
        olderNotifications: older,
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Load more notifications failed', e, null, 'NotificationController');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    state = state.copyWith(currentPage: 1, hasMore: true);
    await loadNotifications();
  }

  /// Mark notification as read
  Future<bool> markAsRead(String id) async {
    try {
      await _service.markAsRead(id);

      // Update local state
      final updated = state.notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();

      // Regroup
      final today = updated.where((n) => n.isToday).toList();
      final thisWeek = updated.where((n) => n.isThisWeek).toList();
      final older = updated.where((n) => !n.isToday && !n.isThisWeek).toList();

      state = state.copyWith(
        notifications: updated,
        todayNotifications: today,
        thisWeekNotifications: thisWeek,
        olderNotifications: older,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error('Mark as read failed', e, null, 'NotificationController');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    state = state.copyWith(isUpdating: true);

    try {
      await _service.markAllAsRead();

      // Update local state
      final updated = state.notifications.map((n) {
        return n.copyWith(isRead: true);
      }).toList();

      // Regroup
      final today = updated.where((n) => n.isToday).toList();
      final thisWeek = updated.where((n) => n.isThisWeek).toList();
      final older = updated.where((n) => !n.isToday && !n.isThisWeek).toList();

      state = state.copyWith(
        notifications: updated,
        todayNotifications: today,
        thisWeekNotifications: thisWeek,
        olderNotifications: older,
        unreadCount: 0,
        isUpdating: false,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error(
          'Mark all as read failed', e, null, 'NotificationController');
      state = state.copyWith(isUpdating: false);
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String id) async {
    try {
      await _service.deleteNotification(id);

      final wasUnread =
          state.notifications.firstWhere((n) => n.id == id).isRead == false;

      // Update local state
      final updated = state.notifications.where((n) => n.id != id).toList();

      // Regroup
      final today = updated.where((n) => n.isToday).toList();
      final thisWeek = updated.where((n) => n.isThisWeek).toList();
      final older = updated.where((n) => !n.isToday && !n.isThisWeek).toList();

      state = state.copyWith(
        notifications: updated,
        todayNotifications: today,
        thisWeekNotifications: thisWeek,
        olderNotifications: older,
        unreadCount: wasUnread && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error(
          'Delete notification failed', e, null, 'NotificationController');
      return false;
    }
  }

  /// Clear all notifications
  Future<bool> clearAll() async {
    state = state.copyWith(isUpdating: true);

    try {
      await _service.deleteAllNotifications();

      state = state.copyWith(
        notifications: [],
        todayNotifications: [],
        thisWeekNotifications: [],
        olderNotifications: [],
        unreadCount: 0,
        isUpdating: false,
      );

      return true;
    } on DioException catch (e) {
      AppLogger.error(
          'Clear all notifications failed', e, null, 'NotificationController');
      state = state.copyWith(isUpdating: false);
      return false;
    }
  }

  /// Load notification preferences
  Future<void> loadPreferences() async {
    try {
      final preferences = await _service.getPreferences();
      state = state.copyWith(preferences: preferences);
    } on DioException catch (e) {
      AppLogger.error(
          'Load preferences failed', e, null, 'NotificationController');
    }
  }

  /// Update notification preferences
  Future<bool> updatePreferences(NotificationPreferences preferences) async {
    state = state.copyWith(isUpdating: true);

    try {
      final updated = await _service.updatePreferences(preferences);
      state = state.copyWith(
        preferences: updated,
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      AppLogger.error(
          'Update preferences failed', e, null, 'NotificationController');
      state = state.copyWith(isUpdating: false);
      return false;
    }
  }

  /// Refresh unread count
  Future<void> refreshUnreadCount() async {
    try {
      final count = await _service.getUnreadCount();
      state = state.copyWith(unreadCount: count.total);
    } on DioException catch (e) {
      AppLogger.error(
          'Refresh unread count failed', e, null, 'NotificationController');
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

/// Notification controller provider
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
  final service = ref.watch(notificationApiServiceProvider);
  return NotificationController(service);
});

/// Unread count provider (shortcut)
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationControllerProvider).unreadCount;
});

/// Notification preferences provider
final notificationPreferencesProvider =
    FutureProvider<NotificationPreferences>((ref) async {
  final service = ref.watch(notificationApiServiceProvider);
  return service.getPreferences();
});
