// Form validators.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/core/utils/validators.dart';

void main() {
  group('email', () {
    test('accepts both ALU domains, any case', () {
      expect(Validators.email('a.kamau@alustudent.com'), isNull);
      expect(Validators.email('  Staff@ALUEducation.com '), isNull);
    });

    test('rejects blank, malformed and non-ALU addresses', () {
      expect(Validators.email(''), AppStrings.emailRequired);
      expect(Validators.email(null), AppStrings.emailRequired);
      expect(Validators.email('not-an-email'), AppStrings.emailInvalid);
      expect(Validators.email('someone@gmail.com'), AppStrings.emailNotAlu);
      expect(
        Validators.email('x@alustudent.com.evil.io'),
        AppStrings.emailNotAlu,
      );
    });
  });

  group('passwords', () {
    test('new passwords need 8+ characters with a letter and a number', () {
      expect(Validators.newPassword(''), AppStrings.passwordRequired);
      expect(Validators.newPassword('abc123'), AppStrings.passwordTooShort);
      expect(Validators.newPassword('abcdefgh'), AppStrings.passwordTooWeak);
      expect(Validators.newPassword('12345678'), AppStrings.passwordTooWeak);
      expect(Validators.newPassword('campus2026'), isNull);
    });

    test('sign-in only checks that a password was typed', () {
      expect(Validators.signInPassword(''), AppStrings.passwordRequired);
      expect(Validators.signInPassword('short'), isNull);
    });

    test('confirm password must match', () {
      final confirm = Validators.confirmPassword('campus2026');
      expect(confirm('campus2026'), isNull);
      expect(confirm('campus2025'), AppStrings.passwordsDontMatch);
    });
  });

  group('profile fields', () {
    test('name length', () {
      expect(Validators.name(' '), AppStrings.nameRequired);
      expect(Validators.name('A'), AppStrings.nameTooShort);
      expect(Validators.name('A' * 51), AppStrings.nameTooLong);
      expect(Validators.name('Amara Kamau'), isNull);
    });

    test('handle format', () {
      expect(Validators.handle('@amara.builds'), isNull);
      expect(Validators.handle('amara_k'), isNull);
      expect(Validators.handle('Amara.Builds'), isNull);
      expect(Validators.handle('@'), AppStrings.handleRequired);
      expect(Validators.handle('ab'), AppStrings.handleLength);
      expect(Validators.handle('amara!'), AppStrings.handleInvalid);
      expect(Validators.handle('no spaces'), AppStrings.handleInvalid);
    });

    test('max length for optional fields', () {
      final bio = Validators.maxLength(10);
      expect(bio(''), isNull);
      expect(bio('0123456789'), isNull);
      expect(bio('0123456789!'), AppStrings.tooLong(10));
    });
  });

  test('handle helpers', () {
    expect(
      Validators.handleFromEmail('Amara.Kamau+x@alustudent.com'),
      '@amara.kamaux',
    );
    expect(Validators.handleFromEmail('ab@alustudent.com'), '@ab_alu');
    expect(Validators.handleFromEmail('++@alustudent.com'), '@student');
    final long = Validators.handleFromEmail('${'a' * 40}@alustudent.com');
    expect(Validators.handle(long), isNull);
    expect(Validators.normalizeHandle(' Amara.Builds '), '@amara.builds');
    expect(Validators.normalizeHandle('@amara'), '@amara');
  });
}
