import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../api/api_client.dart';

/// Global provider for app configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.load();
});

/// Global provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(config);
});
