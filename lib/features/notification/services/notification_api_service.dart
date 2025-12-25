import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/logger.dart';
import '../models/models.dart';

/// Notification API Service - handles all notification-related API calls
class NotificationApiService {
  NotificationApiService(this._apiClient);

  final ApiClient _apiClient;

  static const String _basePath = '/v1/notifications';

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

  /// Get all notifications with pagination
  Future<PaginatedNotifications> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
    NotificationType? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (unreadOnly != null && unreadOnly) {
        queryParams['unreadOnly'] = true;
      }
      if (type != null) {
        queryParams['type'] = type.value;
      }

      final response = await _apiClient.get(
        _basePath,
        queryParameters: queryParams,
      );

      return PaginatedNotifications.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Get notifications failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Get single notification by ID
  Future<NotificationModel> getNotification(String id) async {
    try {
      final response = await _apiClient.get('$_basePath/$id');
      return NotificationModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Get notification failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Get unread notifications count (uses /me/stats endpoint)
  Future<UnreadCount> getUnreadCount() async {
    try {
      final response = await _apiClient.get('$_basePath/me/stats');
      final stats = _extractData(response.data);
      // Extract unread count from stats response
      return UnreadCount(
        total: stats['unread'] as int? ?? 0,
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Get unread count failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Mark a notification as read
  Future<NotificationModel> markAsRead(String id) async {
    try {
      final response = await _apiClient.post('$_basePath/$id/mark-read');
      return NotificationModel.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Mark as read failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.post('$_basePath/me/mark-all-read');
    } on DioException catch (e) {
      AppLogger.error(
          'Mark all as read failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    try {
      await _apiClient.delete('$_basePath/$id');
    } on DioException catch (e) {
      AppLogger.error(
          'Delete notification failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      await _apiClient.delete(_basePath);
    } on DioException catch (e) {
      AppLogger.error(
          'Delete all notifications failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Get notification preferences
  Future<NotificationPreferences> getPreferences() async {
    try {
      final response = await _apiClient.get('$_basePath/preferences/me');
      return NotificationPreferences.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error('Get preferences failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Update notification preferences
  Future<NotificationPreferences> updatePreferences(
      NotificationPreferences preferences) async {
    try {
      final response = await _apiClient.patch(
        '$_basePath/preferences/me',
        data: preferences.toJson(),
      );
      return NotificationPreferences.fromJson(_extractData(response.data));
    } on DioException catch (e) {
      AppLogger.error(
          'Update preferences failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Register device for push notifications
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) async {
    try {
      await _apiClient.post(
        '$_basePath/devices',
        data: {
          'token': token,
          'platform': platform,
        },
      );
    } on DioException catch (e) {
      AppLogger.error('Register device failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Unregister device from push notifications
  Future<void> unregisterDevice(String token) async {
    try {
      await _apiClient.delete(
        '$_basePath/devices',
        data: {'token': token},
      );
    } on DioException catch (e) {
      AppLogger.error(
          'Unregister device failed', e, null, 'NotificationService');
      rethrow;
    }
  }

  /// Get notifications grouped by date
  Future<Map<String, List<NotificationModel>>> getGroupedNotifications({
    int limit = 50,
  }) async {
    try {
      final response = await getNotifications(limit: limit);
      final notifications = response.notifications;

      final Map<String, List<NotificationModel>> grouped = {
        'today': [],
        'thisWeek': [],
        'older': [],
      };

      for (final notification in notifications) {
        if (notification.isToday) {
          grouped['today']!.add(notification);
        } else if (notification.isThisWeek) {
          grouped['thisWeek']!.add(notification);
        } else {
          grouped['older']!.add(notification);
        }
      }

      return grouped;
    } on DioException catch (e) {
      AppLogger.error(
          'Get grouped notifications failed', e, null, 'NotificationService');
      rethrow;
    }
  }
}
