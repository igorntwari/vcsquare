// Form validators: each returns an error message, or null when valid.
import '../config/app_config.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

abstract final class Validators {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp _handlePattern = RegExp(r'^@?[a-z0-9._]+$');

  static bool isAllowedEmail(String email) {
    final at = email.lastIndexOf('@');
    if (at < 0) return false;
    final domain = email.substring(at + 1).trim().toLowerCase();
    return AppConfig.allowedEmailDomains.contains(domain);
  }

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? AppStrings.fieldRequired : null;

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(email)) return AppStrings.emailInvalid;
    if (!isAllowedEmail(email)) return AppStrings.emailNotAlu;
    return null;
  }

  // No strength rules at sign-in, so older passwords still work.
  static String? signInPassword(String? value) =>
      (value == null || value.isEmpty) ? AppStrings.passwordRequired : null;

  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return AppStrings.passwordRequired;
    if (password.length < AppSizes.passwordMinLength) {
      return AppStrings.passwordTooShort;
    }
    final hasLetter = password.contains(RegExp('[A-Za-z]'));
    final hasDigit = password.contains(RegExp('[0-9]'));
    if (!hasLetter || !hasDigit) return AppStrings.passwordTooWeak;
    return null;
  }

  static String? Function(String?) confirmPassword(String password) =>
      (value) => value != password ? AppStrings.passwordsDontMatch : null;

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return AppStrings.nameRequired;
    if (name.length < 2) return AppStrings.nameTooShort;
    if (name.length > AppSizes.nameMaxLength) return AppStrings.nameTooLong;
    return null;
  }

  static String? handle(String? value) {
    final handle = value?.trim().toLowerCase() ?? '';
    final bare = handle.startsWith('@') ? handle.substring(1) : handle;
    if (bare.isEmpty) return AppStrings.handleRequired;
    if (bare.length < 3 || bare.length > AppSizes.handleMaxLength) {
      return AppStrings.handleLength;
    }
    if (!_handlePattern.hasMatch(handle)) return AppStrings.handleInvalid;
    return null;
  }

  static String? Function(String?) maxLength(int max) =>
      (value) =>
          (value?.trim().length ?? 0) > max ? AppStrings.tooLong(max) : null;

  // Always 3-30 characters, as firestore.rules requires.
  static String handleFromEmail(String email) {
    final local = email.split('@').first.toLowerCase();
    var cleaned = local.replaceAll(RegExp(r'[^a-z0-9._]'), '');
    if (cleaned.isEmpty) cleaned = 'student';
    if (cleaned.length < 3) cleaned = '${cleaned}_alu';
    if (cleaned.length > AppSizes.handleMaxLength) {
      cleaned = cleaned.substring(0, AppSizes.handleMaxLength);
    }
    return '@$cleaned';
  }

  static String normalizeHandle(String handle) {
    final trimmed = handle.trim().toLowerCase();
    return trimmed.startsWith('@') ? trimmed : '@$trimmed';
  }
}
