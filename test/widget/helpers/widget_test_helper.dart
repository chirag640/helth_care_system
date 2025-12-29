import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Base widget test helper for common test setups
class WidgetTestHelper {
  /// Wraps a widget with MaterialApp for testing
  static Widget wrapWithMaterialApp(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }

  /// Wraps a widget with MaterialApp and Scaffold for testing
  static Widget wrapWithScaffold(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }

  /// Wraps a widget with all necessary providers for testing
  static Widget wrapWithProviders(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }
}

void main() {
  group('WidgetTestHelper', () {
    testWidgets('wrapWithMaterialApp should provide MaterialApp context',
        (tester) async {
      await tester.pumpWidget(
        WidgetTestHelper.wrapWithMaterialApp(
          const Text('Test'),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('wrapWithScaffold should provide Scaffold context',
        (tester) async {
      await tester.pumpWidget(
        WidgetTestHelper.wrapWithScaffold(
          const Text('Test'),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
