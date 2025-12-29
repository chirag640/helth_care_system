import 'package:flutter_test/flutter_test.dart';
import 'package:helth_care_system/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('should return null for valid email', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name@domain.co.uk'), isNull);
        expect(Validators.email('user+tag@example.org'), isNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.email(''), isNotNull);
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('no@domain'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
        expect(Validators.email('test@'), isNotNull);
      });
    });

    group('phone', () {
      test('should return null for valid phone numbers', () {
        expect(Validators.phone('1234567890'), isNull);
        expect(Validators.phone('+911234567890'), isNull);
        expect(Validators.phone('123-456-7890'), isNull);
      });

      test('should return error for invalid phone numbers', () {
        expect(Validators.phone(''), isNotNull);
        expect(Validators.phone('123'), isNotNull);
        expect(Validators.phone('abcdefghij'), isNotNull);
      });
    });

    group('password', () {
      test('should return null for valid password', () {
        expect(Validators.password('Password1!'), isNull);
        expect(Validators.password('MyP@ssw0rd'), isNull);
        expect(
            Validators.password('NoSpecial123'), isNull); // Valid: has number
      });

      test('should return error for weak password', () {
        expect(Validators.password(''), isNotNull);
        expect(Validators.password('short'), isNotNull); // Too short
        expect(Validators.password('nocaps123!'), isNotNull); // No uppercase
        expect(Validators.password('NOLOWER123!'), isNotNull); // No lowercase
        expect(Validators.password('NoNumbersOrSpecial'),
            isNotNull); // No number or special char
      });
    });

    group('required', () {
      test('should return null for non-empty values', () {
        expect(Validators.required('value'), isNull);
        expect(Validators.required('  text  '), isNull);
      });

      test('should return error for empty values', () {
        expect(Validators.required(''), isNotNull);
        expect(Validators.required('   '), isNotNull);
        expect(Validators.required(null), isNotNull);
      });
    });

    group('minLength', () {
      test('should return null when length meets minimum', () {
        expect(Validators.minLength('hello', 5), isNull);
        expect(Validators.minLength('test', 3), isNull);
      });

      test('should return error when length is below minimum', () {
        expect(Validators.minLength('short', 10), isNotNull);
        expect(Validators.minLength('abc', 5), isNotNull);
      });
    });

    group('maxLength', () {
      test('should return null when length is within maximum', () {
        expect(Validators.maxLength('hello', 10), isNull);
        expect(Validators.maxLength('test', 5), isNull);
      });

      test('should return error when length exceeds maximum', () {
        expect(Validators.maxLength('toolong', 3), isNotNull);
        expect(Validators.maxLength('exceeds', 5), isNotNull);
      });
    });
  });
}
