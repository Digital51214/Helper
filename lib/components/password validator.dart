class PasswordValidator {
  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegExp = RegExp(r'[a-z]');
  static final RegExp _digitRegExp = RegExp(r'\d');
  static final RegExp _specialCharRegExp =
  RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\/\[\]=+;`~]');

      static bool hasMinLength(String value) => value.length >= 8;
  static bool hasUppercase(String value) => _uppercaseRegExp.hasMatch(value);
  static bool hasLowercase(String value) => _lowercaseRegExp.hasMatch(value);
  static bool hasDigit(String value) => _digitRegExp.hasMatch(value);
  static bool hasSpecialCharacter(String value) =>
      _specialCharRegExp.hasMatch(value);

  static bool isValid(String value) {
    return hasMinLength(value) &&
        hasUppercase(value) &&
        hasLowercase(value) &&
        hasDigit(value) &&
        hasSpecialCharacter(value);
  }

  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (!hasMinLength(value)) {
      return 'Password must be at least 8 characters';
    }
    if (!hasUppercase(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!hasLowercase(value)) {
      return 'Password must contain at least 1 lowercase letter';
    }
    if (!hasDigit(value)) {
      return 'Password must contain at least 1 digit';
    }
    if (!hasSpecialCharacter(value)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }
}