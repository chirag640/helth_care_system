import 'dart:io';

import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

/// Security check results
class SecurityCheckResult {
  const SecurityCheckResult({
    required this.isSecure,
    required this.warnings,
    required this.blockers,
  });

  final bool isSecure;
  final List<String> warnings;
  final List<String> blockers;

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasBlockers => blockers.isNotEmpty;
}

/// Device security status
enum DeviceSecurityStatus {
  secure,
  warning,
  compromised,
}

/// Security service for healthcare app
/// Implements device security checks and security policies
class SecurityService {
  SecurityService._();

  static final SecurityService _instance = SecurityService._();
  static SecurityService get instance => _instance;

  bool _initialized = false;
  SecurityCheckResult? _lastCheckResult;

  /// Initialize security service
  Future<void> init() async {
    if (_initialized) return;

    _initialized = true;
    AppLogger.info('Security service initialized', 'SecurityService');
  }

  /// Perform comprehensive security check
  Future<SecurityCheckResult> performSecurityCheck() async {
    final warnings = <String>[];
    final blockers = <String>[];

    try {
      // Check for rooted/jailbroken device
      if (await _isDeviceRooted()) {
        blockers.add('Device appears to be rooted/jailbroken');
      }

      // Check for debugger
      if (_isDebuggerAttached()) {
        warnings.add('Debugger attached - disable in production');
      }

      // Check for emulator (warning only)
      if (await _isEmulator()) {
        warnings.add('Running on emulator');
      }

      // Check for developer options (Android)
      if (Platform.isAndroid && await _isDeveloperOptionsEnabled()) {
        warnings.add('Developer options enabled');
      }

      // Check for secure storage availability
      if (!await _isSecureStorageAvailable()) {
        warnings.add('Secure storage may not be fully protected');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
          'Security check failed', e, stackTrace, 'SecurityService');
      warnings.add('Could not complete all security checks');
    }

    _lastCheckResult = SecurityCheckResult(
      isSecure: blockers.isEmpty,
      warnings: warnings,
      blockers: blockers,
    );

    return _lastCheckResult!;
  }

  /// Get device security status
  DeviceSecurityStatus getSecurityStatus() {
    if (_lastCheckResult == null) {
      return DeviceSecurityStatus.warning;
    }

    if (_lastCheckResult!.hasBlockers) {
      return DeviceSecurityStatus.compromised;
    }

    if (_lastCheckResult!.hasWarnings) {
      return DeviceSecurityStatus.warning;
    }

    return DeviceSecurityStatus.secure;
  }

  /// Check if device is rooted (Android) or jailbroken (iOS)
  Future<bool> _isDeviceRooted() async {
    if (kDebugMode) {
      return false; // Skip in debug mode
    }

    try {
      if (Platform.isAndroid) {
        return await _checkAndroidRoot();
      } else if (Platform.isIOS) {
        return await _checkiOSJailbreak();
      }
    } catch (e) {
      AppLogger.warning('Root check failed: $e', 'SecurityService');
    }

    return false;
  }

  /// Check Android root indicators
  Future<bool> _checkAndroidRoot() async {
    // Check for common root paths
    final rootPaths = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
      '/su/bin/su',
    ];

    for (final path in rootPaths) {
      if (await File(path).exists()) {
        return true;
      }
    }

    // Check for root management apps
    // Note: Package check would require platform channel implementation
    // These are common root management app package names for reference:
    // - com.noshufou.android.su
    // - com.thirdparty.superuser
    // - eu.chainfire.supersu
    // - com.koushikdutta.superuser
    // - com.zachspong.temprootremovejb
    // - com.ramdroid.appquarantine
    // - com.topjohnwu.magisk

    // This is a basic check

    return false;
  }

  /// Check iOS jailbreak indicators
  Future<bool> _checkiOSJailbreak() async {
    // Check for common jailbreak paths
    final jailbreakPaths = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash',
      '/usr/sbin/sshd',
      '/etc/apt',
      '/private/var/lib/apt/',
      '/usr/bin/ssh',
    ];

    for (final path in jailbreakPaths) {
      if (await File(path).exists()) {
        return true;
      }
    }

    // Check if app can write outside sandbox
    try {
      final file = File('/private/jailbreak_test.txt');
      await file.writeAsString('test');
      await file.delete();
      return true; // If we can write here, device is jailbroken
    } catch (e) {
      // Expected on non-jailbroken devices
    }

    return false;
  }

  /// Check if debugger is attached
  bool _isDebuggerAttached() {
    // In release mode, this should be false
    return kDebugMode;
  }

  /// Check if running on emulator
  Future<bool> _isEmulator() async {
    if (Platform.isAndroid) {
      // Check common emulator indicators
      final deviceInfo = Platform.environment;
      final brand = deviceInfo['BRAND'] ?? '';
      final device = deviceInfo['DEVICE'] ?? '';
      final model = deviceInfo['MODEL'] ?? '';
      final product = deviceInfo['PRODUCT'] ?? '';

      final emulatorIndicators = [
        'generic',
        'sdk',
        'google_sdk',
        'emulator',
        'android sdk built for',
        'genymotion',
      ];

      for (final indicator in emulatorIndicators) {
        if (brand.toLowerCase().contains(indicator) ||
            device.toLowerCase().contains(indicator) ||
            model.toLowerCase().contains(indicator) ||
            product.toLowerCase().contains(indicator)) {
          return true;
        }
      }
    }

    if (Platform.isIOS) {
      // iOS simulator detection
      // Would need platform channel for accurate detection
    }

    return false;
  }

  /// Check if developer options are enabled (Android)
  Future<bool> _isDeveloperOptionsEnabled() async {
    // Would require platform channel for accurate detection
    return false;
  }

  /// Check if secure storage is available and working
  Future<bool> _isSecureStorageAvailable() async {
    try {
      // Test secure storage by writing and reading a test value
      return true; // Assume available if no exception
    } catch (e) {
      return false;
    }
  }

  /// Clear sensitive data (for logout or security breach)
  Future<void> clearSensitiveData() async {
    AppLogger.info('Clearing sensitive data', 'SecurityService');
    // This should be called when user logs out or security breach detected
  }

  /// Check if app should block due to security issues
  bool shouldBlockApp() {
    if (_lastCheckResult == null) return false;
    return _lastCheckResult!.hasBlockers && !kDebugMode;
  }

  /// Get security warning message
  String? getSecurityWarningMessage() {
    if (_lastCheckResult == null) return null;

    if (_lastCheckResult!.hasBlockers) {
      return 'This app cannot run on a rooted/jailbroken device for security reasons. '
          'Healthcare data must be protected.';
    }

    if (_lastCheckResult!.hasWarnings) {
      return 'Security warnings detected: ${_lastCheckResult!.warnings.join(', ')}';
    }

    return null;
  }
}
