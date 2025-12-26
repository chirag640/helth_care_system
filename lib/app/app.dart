import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth/auth_event_bus.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/services/system_ui_service.dart';
import '../features/auth/controller/auth_controller.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<AuthEvent>? _authEventSubscription;

  @override
  void initState() {
    super.initState();
    _setupAuthEventListener();
  }

  void _setupAuthEventListener() {
    _authEventSubscription = AuthEventBus.instance.stream.listen((event) {
      switch (event) {
        case AuthEvent.tokenRefreshFailed:
        case AuthEvent.sessionExpired:
        case AuthEvent.forceLogout:
          _handleAuthFailure();
          break;
      }
    });
  }

  void _handleAuthFailure() {
    // Update auth state to logged out
    ref.read(authControllerProvider.notifier).forceLogout();

    // Navigate to welcome/sign-in screen
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRouter.welcome,
      (route) => false,
    );

    // Show a snackbar to inform the user
    ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Session expired. Please sign in again.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  void dispose() {
    _authEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    return MaterialApp(
      navigatorKey: _navigatorKey,
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
