import 'package:flutter_test/flutter_test.dart';
import 'package:helth_care_system/core/config/environment.dart';

void main() {
  group('Environment', () {
    test('should have default development environment', () {
      // Default is development when no dart-define is provided
      expect(Environment.current, 'development');
    });

    test('should provide environment config', () {
      final config = Environment.config;
      expect(config, isNotNull);
      expect(config.name, isNotEmpty);
    });
  });

  group('EnvironmentConfig', () {
    group('development', () {
      test('should have correct development settings', () {
        final config = EnvironmentConfig.development();

        expect(config.name, 'Development');
        expect(config.enableLogging, true);
        expect(config.enableCrashReporting, false);
        expect(config.maxRetries, 3);
      });
    });

    group('staging', () {
      test('should have correct staging settings', () {
        final config = EnvironmentConfig.staging();

        expect(config.name, 'Staging');
        expect(config.enableLogging, true);
        expect(config.enableCrashReporting, true);
        expect(config.maxRetries, 2);
      });
    });

    group('production', () {
      test('should have correct production settings', () {
        final config = EnvironmentConfig.production();

        expect(config.name, 'Production');
        expect(config.enableLogging, false);
        expect(config.enableCrashReporting, true);
        expect(config.maxRetries, 2);
      });

      test('should have shorter timeouts than development', () {
        final devConfig = EnvironmentConfig.development();
        final prodConfig = EnvironmentConfig.production();

        expect(
          prodConfig.connectionTimeout.inSeconds,
          lessThan(devConfig.connectionTimeout.inSeconds),
        );
      });

      test('should have longer cache age than development', () {
        final devConfig = EnvironmentConfig.development();
        final prodConfig = EnvironmentConfig.production();

        expect(
          prodConfig.cacheMaxAge.inMinutes,
          greaterThan(devConfig.cacheMaxAge.inMinutes),
        );
      });
    });
  });
}
