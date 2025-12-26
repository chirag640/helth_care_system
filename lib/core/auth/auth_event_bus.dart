import 'dart:async';

/// Events that can be emitted from the auth system
enum AuthEvent {
  /// Token refresh failed - user should be logged out
  tokenRefreshFailed,

  /// Session expired - user should be logged out
  sessionExpired,

  /// User was forcefully logged out (e.g., from another device)
  forceLogout,
}

/// A simple event bus for authentication events
/// This allows the auth interceptor to communicate with the rest of the app
/// without tight coupling
class AuthEventBus {
  AuthEventBus._();

  static final AuthEventBus _instance = AuthEventBus._();
  static AuthEventBus get instance => _instance;

  final _controller = StreamController<AuthEvent>.broadcast();

  /// Stream of auth events
  Stream<AuthEvent> get stream => _controller.stream;

  /// Emit an auth event
  void emit(AuthEvent event) {
    _controller.add(event);
  }

  /// Dispose the controller
  void dispose() {
    _controller.close();
  }
}
