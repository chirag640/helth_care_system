import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../api/api_client.dart';
import '../../features/auth/services/auth_api_service.dart';
import '../../features/appointment/services/appointment_api_service.dart';
import '../../features/profile/services/profile_api_service.dart';
import '../../features/notification/services/notification_api_service.dart';

/// Global provider for app configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.load();
});

/// Global provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(config);
});

/// Auth API service provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiService(apiClient);
});

/// Appointment API service provider
final appointmentApiServiceProvider = Provider<AppointmentApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AppointmentApiService(apiClient);
});

/// Profile API service provider
final profileApiServiceProvider = Provider<ProfileApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileApiService(apiClient);
});

/// Notification API service provider
final notificationApiServiceProvider = Provider<NotificationApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationApiService(apiClient);
});
