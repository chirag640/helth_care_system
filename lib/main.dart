import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/auth/token_storage.dart';
import 'core/config/env_loader.dart';
import 'core/config/environment.dart';
import 'core/database/hive_database.dart';
import 'core/monitoring/error_tracking_service.dart';
import 'core/monitoring/performance_service.dart';
import 'core/network/connectivity_service.dart';
import 'core/security/security_service.dart';
import 'core/services/system_ui_service.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  // Run app in guarded zone for error catching
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize core services
    await _initializeServices();

    runApp(
      const ProviderScope(
        child: App(),
      ),
    );
  }, (error, stackTrace) {
    // Global error handler
    ErrorTrackingService.instance.captureException(
      error,
      stackTrace: stackTrace,
      severity: ErrorSeverity.fatal,
    );
  });
}

/// Initialize all core services
Future<void> _initializeServices() async {
  final stopwatch = Stopwatch()..start();

  try {
    // 1. Initialize system UI
    SystemUIService.initialize(isDark: false);

    // 2. Load environment configuration
    await EnvLoader.load();
    AppLogger.info('Environment: ${Environment.config.name}', 'Init');

    // 3. Initialize error tracking (early for catching init errors)
    await ErrorTrackingService.instance.init(
      dsn: Environment.config.sentryDsn,
    );

    // 4. Initialize security service
    await SecurityService.instance.init();
    final securityCheck = await SecurityService.instance.performSecurityCheck();
    if (securityCheck.hasWarnings && kDebugMode) {
      AppLogger.warning(
        'Security warnings: ${securityCheck.warnings.join(", ")}',
        'Security',
      );
    }

    // 5. Initialize database
    await HiveDatabase.instance.init();

    // 6. Initialize token storage
    await TokenStorage.instance.init();

    // 7. Initialize connectivity monitoring
    await ConnectivityService.instance.init();

    // 8. Initialize performance monitoring
    await PerformanceMonitoringService.instance.init();

    stopwatch.stop();
    AppLogger.success(
      'All services initialized in ${stopwatch.elapsedMilliseconds}ms',
      'Init',
    );
  } catch (e, stackTrace) {
    AppLogger.error('Service initialization failed', e, stackTrace, 'Init');
    ErrorTrackingService.instance.captureException(
      e,
      stackTrace: stackTrace,
      severity: ErrorSeverity.fatal,
    );
    rethrow;
  }
}
