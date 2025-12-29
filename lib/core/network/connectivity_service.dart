import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

/// Network connectivity status
enum NetworkStatus {
  online,
  offline,
  unknown,
}

/// Network type
enum NetworkType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}

/// Connectivity monitoring service
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService _instance = ConnectivityService._();
  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _statusController = StreamController<NetworkStatus>.broadcast();
  final _typeController = StreamController<NetworkType>.broadcast();

  NetworkStatus _currentStatus = NetworkStatus.unknown;
  NetworkType _currentType = NetworkType.none;

  bool _initialized = false;

  /// Current network status
  NetworkStatus get status => _currentStatus;

  /// Current network type
  NetworkType get type => _currentType;

  /// Whether device is online
  bool get isOnline => _currentStatus == NetworkStatus.online;

  /// Whether device is offline
  bool get isOffline => _currentStatus == NetworkStatus.offline;

  /// Stream of network status changes
  Stream<NetworkStatus> get statusStream => _statusController.stream;

  /// Stream of network type changes
  Stream<NetworkType> get typeStream => _typeController.stream;

  /// Initialize connectivity service
  Future<void> init() async {
    if (_initialized) return;

    // Get initial connectivity status
    await _checkConnectivity();

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        AppLogger.error(
            'Connectivity listener error', error, null, 'Connectivity');
      },
    );

    _initialized = true;
    AppLogger.success(
      'Connectivity service initialized (${_currentStatus.name})',
      'Connectivity',
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      AppLogger.error('Failed to check connectivity', e, null, 'Connectivity');
      _updateStatus(NetworkStatus.unknown, NetworkType.none);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = !results.contains(ConnectivityResult.none);

    NetworkStatus newStatus;
    NetworkType newType;

    if (!hasConnection) {
      newStatus = NetworkStatus.offline;
      newType = NetworkType.none;
    } else {
      newStatus = NetworkStatus.online;
      newType = _getNetworkType(results);
    }

    _updateStatus(newStatus, newType);
  }

  NetworkType _getNetworkType(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return NetworkType.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return NetworkType.mobile;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return NetworkType.ethernet;
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return NetworkType.bluetooth;
    } else if (results.contains(ConnectivityResult.vpn)) {
      return NetworkType.vpn;
    } else if (results.contains(ConnectivityResult.other)) {
      return NetworkType.other;
    }
    return NetworkType.none;
  }

  void _updateStatus(NetworkStatus status, NetworkType type) {
    final statusChanged = _currentStatus != status;
    final typeChanged = _currentType != type;

    _currentStatus = status;
    _currentType = type;

    if (statusChanged) {
      _statusController.add(status);
      AppLogger.info(
        'Network status changed: ${status.name}',
        'Connectivity',
      );
    }

    if (typeChanged) {
      _typeController.add(type);
      AppLogger.debug(
        'Network type changed: ${type.name}',
        'Connectivity',
      );
    }
  }

  /// Check if specific network type is available
  Future<bool> hasNetworkType(NetworkType type) async {
    final results = await _connectivity.checkConnectivity();

    switch (type) {
      case NetworkType.wifi:
        return results.contains(ConnectivityResult.wifi);
      case NetworkType.mobile:
        return results.contains(ConnectivityResult.mobile);
      case NetworkType.ethernet:
        return results.contains(ConnectivityResult.ethernet);
      case NetworkType.bluetooth:
        return results.contains(ConnectivityResult.bluetooth);
      case NetworkType.vpn:
        return results.contains(ConnectivityResult.vpn);
      case NetworkType.other:
        return results.contains(ConnectivityResult.other);
      case NetworkType.none:
        return results.contains(ConnectivityResult.none);
    }
  }

  /// Force refresh connectivity status
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
    _typeController.close();
    _initialized = false;
  }
}

/// Mixin for widgets that need connectivity awareness
mixin ConnectivityAware {
  StreamSubscription<NetworkStatus>? _connectivitySubscription;

  void initConnectivityAwareness({
    required VoidCallback onOnline,
    required VoidCallback onOffline,
  }) {
    _connectivitySubscription =
        ConnectivityService.instance.statusStream.listen((status) {
      switch (status) {
        case NetworkStatus.online:
          onOnline();
          break;
        case NetworkStatus.offline:
          onOffline();
          break;
        case NetworkStatus.unknown:
          break;
      }
    });
  }

  void disposeConnectivityAwareness() {
    _connectivitySubscription?.cancel();
  }
}
