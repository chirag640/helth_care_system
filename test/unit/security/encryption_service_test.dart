import 'package:flutter_test/flutter_test.dart';
import 'package:helth_care_system/core/security/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    late EncryptionService service;

    setUp(() {
      service = EncryptionService.instance;
    });

    group('maskEmail', () {
      test('should mask email correctly', () {
        expect(
            service.maskEmail('john.doe@example.com'), 'j*******e@example.com');
        expect(service.maskEmail('ab@example.com'), '**@example.com');
        expect(service.maskEmail('a@example.com'), '*@example.com');
      });

      test('should handle invalid email format', () {
        expect(service.maskEmail('invalid'), 'invalid');
        expect(service.maskEmail(''), '');
      });
    });

    group('maskPhone', () {
      test('should mask phone number correctly', () {
        expect(service.maskPhone('1234567890'), '******7890');
        expect(service.maskPhone('+1 (234) 567-8901'), '*******8901');
      });

      test('should handle short numbers', () {
        expect(service.maskPhone('123'), '***');
        expect(service.maskPhone('1234'), '1234');
      });
    });

    group('maskSensitiveData', () {
      test('should mask data with visible chars at start and end', () {
        expect(service.maskSensitiveData('1234567890'), '1234**7890');
        expect(service.maskSensitiveData('abcdefghij', visibleChars: 2),
            'ab****ij');
      });

      test('should mask short data completely', () {
        expect(service.maskSensitiveData('1234'), '****');
        expect(service.maskSensitiveData('ab', visibleChars: 2), '**');
      });
    });

    group('hash', () {
      test('should produce consistent hash', () {
        final hash1 = service.hash('test');
        final hash2 = service.hash('test');
        expect(hash1, hash2);
      });

      test('should produce different hash for different inputs', () {
        final hash1 = service.hash('test1');
        final hash2 = service.hash('test2');
        expect(hash1, isNot(hash2));
      });
    });
  });
}
