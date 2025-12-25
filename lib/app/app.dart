import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/services/system_ui_service.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Care System',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.splash,
      onGenerateRoute: router.onGenerateRoute,
      builder: (context, child) {
        // Update system UI when theme changes
        SystemUIService.updateForTheme(ThemeMode.system, context);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
