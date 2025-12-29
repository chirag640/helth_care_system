import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../utils/logger.dart';
import '../storage/secure_storage.dart';

/// Encryption service for additional data protection
/// Uses AES-like obfuscation for sensitive local data
class EncryptionService {
  EncryptionService._();

  static final EncryptionService _instance = EncryptionService._();
  static EncryptionService get instance => _instance;

  static const String _keyStorageKey = 'app_encryption_key';
  String? _encryptionKey;
  bool _initialized = false;

  /// Initialize encryption service
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Try to load existing key from secure storage
      _encryptionKey = await SecureStorage.instance.read(_keyStorageKey);

      // Generate new key if not exists
      if (_encryptionKey == null) {
        _encryptionKey = _generateKey();
        await SecureStorage.instance.write(_keyStorageKey, _encryptionKey!);
        AppLogger.info('Generated new encryption key', 'EncryptionService');
      } else {
        AppLogger.debug('Loaded existing encryption key', 'EncryptionService');
      }

      _initialized = true;
      AppLogger.success('Encryption service initialized', 'EncryptionService');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize encryption', e, stackTrace,
          'EncryptionService');
      // Generate temporary key for this session
      _encryptionKey = _generateKey();
      _initialized = true;
    }
  }

  /// Generate a random encryption key
  String _generateKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(values);
  }

  /// Encrypt data
  String encrypt(String plainText) {
    if (!_initialized || _encryptionKey == null) {
      AppLogger.warning('Encryption not initialized, returning plain text',
          'EncryptionService');
      return plainText;
    }

    try {
      // Simple XOR encryption with key
      final keyBytes = base64Decode(_encryptionKey!);
      final plainBytes = utf8.encode(plainText);
      final encryptedBytes = Uint8List(plainBytes.length);

      for (int i = 0; i < plainBytes.length; i++) {
        encryptedBytes[i] = plainBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      // Add random salt prefix
      final salt = List<int>.generate(8, (i) => Random.secure().nextInt(256));
      final saltedBytes = [...salt, ...encryptedBytes];

      return base64Encode(saltedBytes);
    } catch (e) {
      AppLogger.error('Encryption failed', e, null, 'EncryptionService');
      return plainText;
    }
  }

  /// Decrypt data
  String decrypt(String encryptedText) {
    if (!_initialized || _encryptionKey == null) {
      AppLogger.warning(
          'Encryption not initialized, returning as-is', 'EncryptionService');
      return encryptedText;
    }

    try {
      final saltedBytes = base64Decode(encryptedText);

      // Remove salt prefix
      if (saltedBytes.length <= 8) {
        return encryptedText;
      }
      final encryptedBytes = saltedBytes.sublist(8);

      // XOR decrypt
      final keyBytes = base64Decode(_encryptionKey!);
      final decryptedBytes = Uint8List(encryptedBytes.length);

      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes[i] = encryptedBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      AppLogger.error('Decryption failed', e, null, 'EncryptionService');
      return encryptedText;
    }
  }

  /// Encrypt map data (JSON)
  String encryptJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    return encrypt(jsonString);
  }

  /// Decrypt to map data (JSON)
  Map<String, dynamic>? decryptJson(String encryptedText) {
    try {
      final jsonString = decrypt(encryptedText);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('JSON decryption failed', e, null, 'EncryptionService');
      return null;
    }
  }

  /// Hash sensitive data (one-way)
  String hash(String data) {
    // Simple hash for comparison purposes
    int hash = 0;
    for (int i = 0; i < data.length; i++) {
      hash = ((hash << 5) - hash) + data.codeUnitAt(i);
      hash &= 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  /// Mask sensitive data for display
  String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars * 2) {
      return '*' * data.length;
    }

    final start = data.substring(0, visibleChars);
    final end = data.substring(data.length - visibleChars);
    final masked = '*' * (data.length - visibleChars * 2);

    return '$start$masked$end';
  }

  /// Mask email for display
  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final local = parts[0];
    final domain = parts[1];

    String maskedLocal;
    if (local.length <= 2) {
      maskedLocal = '*' * local.length;
    } else {
      maskedLocal =
          '${local[0]}${'*' * (local.length - 2)}${local[local.length - 1]}';
    }

    return '$maskedLocal@$domain';
  }

  /// Mask phone number for display
  String maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return '*' * digits.length;

    return '${'*' * (digits.length - 4)}${digits.substring(digits.length - 4)}';
  }

  /// Clear encryption key (for logout)
  Future<void> clearKey() async {
    await SecureStorage.instance.delete(_keyStorageKey);
    _encryptionKey = null;
    _initialized = false;
    AppLogger.info('Encryption key cleared', 'EncryptionService');
  }
}
