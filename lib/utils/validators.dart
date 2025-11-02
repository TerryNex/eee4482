/// Input Validation Utilities
/// Comprehensive validation for all user-submitted data
/// Student: HE HUALIANG (230263367)

class Validators {
  /// Validate if a string is not empty
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate string length
  static String? length(
    String? value, {
    int? min,
    int? max,
    String fieldName = 'This field',
  }) {
    if (value == null) return null;

    final length = value.trim().length;

    if (min != null && length < min) {
      return '$fieldName must be at least $min characters';
    }

    if (max != null && length > max) {
      return '$fieldName must not exceed $max characters';
    }

    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate number (integer or double)
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    return null;
  }

  /// Validate integer
  static String? integer(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid integer';
    }

    return null;
  }

  /// Validate number range
  static String? range(
    String? value, {
    num? min,
    num? max,
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must not exceed $max';
    }

    return null;
  }

  /// Validate ISBN format (ISBN-10 or ISBN-13)
  static String? isbn(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Remove hyphens and spaces
    final cleanIsbn = value.replaceAll(RegExp(r'[-\s]'), '');

    // Check ISBN-10
    if (cleanIsbn.length == 10) {
      final isbn10Regex = RegExp(r'^\d{9}[\dXx]$');
      if (!isbn10Regex.hasMatch(cleanIsbn)) {
        return 'Invalid ISBN-10 format. Expected: XXX-X-XXXX-XXXX-X';
      }
      return null;
    }

    // Check ISBN-13
    if (cleanIsbn.length == 13) {
      final isbn13Regex = RegExp(r'^\d{13}$');
      if (!isbn13Regex.hasMatch(cleanIsbn)) {
        return 'Invalid ISBN-13 format. Expected: XXX-X-XXXX-XXXX-X';
      }
      return null;
    }

    return 'ISBN must be 10 or 13 digits';
  }

  /// Validate date format (YYYY-MM-DD)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final date = DateTime.parse(value);
      // Check if the date is not in the future
      if (date.isAfter(DateTime.now())) {
        return 'Date cannot be in the future';
      }
      return null;
    } catch (e) {
      return 'Invalid date format. Expected: YYYY-MM-DD';
    }
  }

  /// Validate URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    // Check length (should be at least 7 digits)
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7) {
      return 'Phone number must have at least 7 digits';
    }

    return null;
  }

  /// Validate alphabetic characters only
  static String? alphabetic(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final alphaRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!alphaRegex.hasMatch(value)) {
      return '$fieldName must contain only letters';
    }

    return null;
  }

  /// Validate alphanumeric characters
  static String? alphanumeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final alphanumRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphanumRegex.hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }

    return null;
  }

  /// Custom pattern validation
  static String? pattern(
    String? value,
    RegExp pattern, {
    String? errorMessage,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!pattern.hasMatch(value)) {
      return errorMessage ?? 'Invalid format';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Validate book title
  static String? bookTitle(String? value) {
    return combine(value, [
      (val) => required(val, fieldName: 'Title'),
      (val) => length(val, min: 1, max: 200, fieldName: 'Title'),
    ]);
  }

  /// Validate author name
  static String? authorName(String? value) {
    return combine(value, [
      (val) => required(val, fieldName: 'Author'),
      (val) => length(val, min: 2, max: 100, fieldName: 'Author'),
    ]);
  }

  /// Validate publisher name
  static String? publisherName(String? value) {
    return combine(value, [
      (val) => required(val, fieldName: 'Publisher'),
      (val) => length(val, min: 2, max: 100, fieldName: 'Publisher'),
    ]);
  }

  /// Validate publication date
  static String? publicationDate(String? value) {
    return combine(value, [
      (val) => required(val, fieldName: 'Publication date'),
      (val) => date(val),
    ]);
  }

  /// Validate ISBN with required check
  static String? isbnRequired(String? value) {
    return combine(value, [
      (val) => required(val, fieldName: 'ISBN'),
      (val) => isbn(val),
    ]);
  }
}
