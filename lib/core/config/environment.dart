// Environment configuration using dart-define
// Build commands:
// - Development: flutter run --dart-define=ENVIRONMENT=development
// - Staging: flutter run --dart-define=ENVIRONMENT=staging
// - Production: flutter run --dart-define=ENVIRONMENT=production
//
// Or use flavor configurations in VS Code launch.json

/// Provides environment-specific configuration values
class Environment {
  static const String current = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: true,
  );

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '0.1.0',
  );

  static const String buildNumber = String.fromEnvironment(
    'BUILD_NUMBER',
    defaultValue: '1',
  );

  static bool get isDevelopment => current == 'development';
  static bool get isStaging => current == 'staging';
  static bool get isProduction => current == 'production';

  static bool get isDebugMode => isDevelopment || isStaging;
  static bool get isReleaseMode => isProduction;

  /// Get environment-specific configuration
  static EnvironmentConfig get config => _getConfig();

  static EnvironmentConfig _getConfig() {
    switch (current) {
      case 'production':
        return EnvironmentConfig.production();
      case 'staging':
        return EnvironmentConfig.staging();
      case 'development':
      default:
        return EnvironmentConfig.development();
    }
  }
}

/// Environment-specific configuration
class EnvironmentConfig {
  const EnvironmentConfig({
    required this.name,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enablePerformanceMonitoring,
    required this.enableCrashReporting,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.maxRetries,
    required this.cacheMaxAge,
    required this.sentryDsn,
  });

  final String name;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enablePerformanceMonitoring;
  final bool enableCrashReporting;
  final Duration connectionTimeout;
  final Duration receiveTimeout;
  final int maxRetries;
  final Duration cacheMaxAge;
  final String? sentryDsn;

  /// Development configuration
  factory EnvironmentConfig.development() {
    return EnvironmentConfig(
      name: 'Development',
      apiBaseUrl: Environment.apiBaseUrl.isNotEmpty
          ? Environment.apiBaseUrl
          : 'http://localhost:3000/api',
      enableLogging: true,
      enablePerformanceMonitoring: true,
      enableCrashReporting: false,
      connectionTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      maxRetries: 3,
      cacheMaxAge: const Duration(minutes: 5),
      sentryDsn: null,
    );
  }

  /// Staging configuration
  factory EnvironmentConfig.staging() {
    return EnvironmentConfig(
      name: 'Staging',
      apiBaseUrl: Environment.apiBaseUrl.isNotEmpty
          ? Environment.apiBaseUrl
          : 'https://staging-api.healthcaresystem.com/api',
      enableLogging: true,
      enablePerformanceMonitoring: true,
      enableCrashReporting: true,
      connectionTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      maxRetries: 2,
      cacheMaxAge: const Duration(minutes: 10),
      sentryDsn:
          Environment.sentryDsn.isNotEmpty ? Environment.sentryDsn : null,
    );
  }

  /// Production configuration
  factory EnvironmentConfig.production() {
    return EnvironmentConfig(
      name: 'Production',
      apiBaseUrl: Environment.apiBaseUrl.isNotEmpty
          ? Environment.apiBaseUrl
          : 'https://api.healthcaresystem.com/api',
      enableLogging: false,
      enablePerformanceMonitoring: true,
      enableCrashReporting: true,
      connectionTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      maxRetries: 2,
      cacheMaxAge: const Duration(hours: 1),
      sentryDsn:
          Environment.sentryDsn.isNotEmpty ? Environment.sentryDsn : null,
    );
  }

  @override
  String toString() => 'EnvironmentConfig($name)';
}
