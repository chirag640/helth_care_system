import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Local storage wrapper for SharedPreferences
class LocalStorage {
  LocalStorage._(this._prefs);

  final SharedPreferences _prefs;

  static LocalStorage? _instance;

  /// Get LocalStorage instance
  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = LocalStorage._(prefs);
      AppLogger.debug('LocalStorage initialized', 'LocalStorage');
    }
    return _instance!;
  }

  /// Set string value
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      AppLogger.error('Failed to set string', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      AppLogger.error('Failed to get string', e, null, 'LocalStorage');
      return null;
    }
  }

  /// Set int value
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      AppLogger.error('Failed to set int', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get int value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      AppLogger.error('Failed to get int', e, null, 'LocalStorage');
      return null;
    }
  }

  /// Set bool value
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      AppLogger.error('Failed to set bool', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get bool value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      AppLogger.error('Failed to get bool', e, null, 'LocalStorage');
      return null;
    }
  }

  /// Set double value
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      AppLogger.error('Failed to set double', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      AppLogger.error('Failed to get double', e, null, 'LocalStorage');
      return null;
    }
  }

  /// Set string list value
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      AppLogger.error('Failed to set string list', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get string list value
  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      AppLogger.error('Failed to get string list', e, null, 'LocalStorage');
      return null;
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      AppLogger.error('Failed to remove key', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      AppLogger.error('Failed to clear storage', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      AppLogger.error('Failed to check key', e, null, 'LocalStorage');
      return false;
    }
  }

  /// Get all keys
  Set<String> getKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      AppLogger.error('Failed to get keys', e, null, 'LocalStorage');
      return {};
    }
  }
}
