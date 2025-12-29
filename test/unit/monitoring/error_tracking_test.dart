import 'package:flutter_test/flutter_test.dart';
import 'package:helth_care_system/core/monitoring/error_tracking_service.dart';

void main() {
  group('ErrorTrackingService', () {
    late ErrorTrackingService service;

    setUp(() {
      service = ErrorTrackingService.instance;
    });

    group('ErrorContext', () {
      test('should sanitize email in context', () {
        const context = ErrorContext(
          userId: 'user123',
          email: 'john.doe@example.com',
          screen: 'HomeScreen',
          action: 'load_data',
        );

        final map = context.toMap();
        expect(map['user_id'], 'user123');
        expect(map['email'], 'j***e@example.com');
        expect(map['screen'], 'HomeScreen');
        expect(map['action'], 'load_data');
      });

      test('should handle null values', () {
        const context = ErrorContext();
        final map = context.toMap();
        expect(map.isEmpty, true);
      });

      test('should include extra data', () {
        const context = ErrorContext(
          extra: {'custom_field': 'value'},
        );

        final map = context.toMap();
        expect(map['custom_field'], 'value');
      });
    });

    group('captureMessage', () {
      test('should capture message without throwing', () {
        expect(
          () => service.captureMessage('Test message'),
          returnsNormally,
        );
      });

      test('should capture message with context', () {
        expect(
          () => service.captureMessage(
            'Test message',
            context: const ErrorContext(userId: 'test'),
          ),
          returnsNormally,
        );
      });
    });

    group('PerformanceTransaction', () {
      test('should create and finish transaction', () {
        final transaction = service.startTransaction(
          name: 'test_transaction',
          operation: 'test',
        );

        expect(transaction.name, 'test_transaction');
        expect(transaction.operation, 'test');

        // Should not throw
        transaction.finish(status: 'ok');
      });

      test('should create child span', () {
        final transaction = service.startTransaction(
          name: 'test_transaction',
          operation: 'test',
        );

        final span = transaction.startChild(
          operation: 'child_operation',
          description: 'test description',
        );

        expect(span.operation, 'child_operation');
        expect(span.description, 'test description');

        span.finish();
        transaction.finish();
      });
    });
  });
}
