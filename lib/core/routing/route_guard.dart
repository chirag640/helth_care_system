import 'package:flutter/material.dart';
import '../auth/token_storage.dart';
import 'app_router.dart';

/// Base class for route guards
abstract class RouteGuard {
  const RouteGuard();

  bool canActivate(RouteSettings settings);

  Widget fallback({required BuildContext context});
}

/// Auth guard that checks if user is authenticated
class AuthGuard extends RouteGuard {
  const AuthGuard();

  @override
  bool canActivate(RouteSettings settings) {
    return TokenStorage.instance.isAuthenticated();
  }

  @override
  Widget fallback({required BuildContext context}) {
    // Redirect to sign in page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(AppRouter.signIn);
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Guard that redirects authenticated users away from auth pages
class GuestGuard extends RouteGuard {
  const GuestGuard();

  @override
  bool canActivate(RouteSettings settings) {
    return !TokenStorage.instance.isAuthenticated();
  }

  @override
  Widget fallback({required BuildContext context}) {
    // Redirect to home page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
