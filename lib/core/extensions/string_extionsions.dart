extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes each word in the string
  String toTitleCase() {
    return trim().split(RegExp(r'\s+')).map((word) => word.capitalizeFirst()).join(' ');
  }

  /// Checks if the string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(trim());
  }

  /// Checks if the string is a valid phone number (simple format)
  bool isValidPhone({int minLength = 10, int maxLength = 15}) {
    final digits = replaceAll(RegExp(r'\D'), '');
    return digits.length >= minLength && digits.length <= maxLength;
  }

  /// Checks if the string is a valid URL
  bool isValidUrl() {
    final urlRegex = RegExp(r'^(http|https):\/\/([\w\-]+\.)+[\w\-]+(\/[\w\- ./?%&=]*)?$');
    return urlRegex.hasMatch(trim());
  }

  /// Removes all white space
  String removeAllWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Returns true if string is a number
  bool isNumeric() => double.tryParse(this) != null;

  /// Masks the string (e.g., for sensitive data like credit cards)
  String mask({int unmaskedStart = 0, int unmaskedEnd = 4, String maskChar = '*'}) {
    if (length <= (unmaskedStart + unmaskedEnd)) return this;
    final maskedLength = length - (unmaskedStart + unmaskedEnd);
    final maskedPart = maskChar * maskedLength;
    return substring(0, unmaskedStart) + maskedPart + substring(length - unmaskedEnd);
  }

  /// Returns null if the string is empty or only whitespace
  String? get nullIfEmpty => trim().isEmpty ? null : this;

  /// Truncates the string with an ellipsis if it exceeds the given length
  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength).trim()}...';
  }

  /// Safely parses string to int
  int? toInt() => int.tryParse(this);

  /// Safely parses string to double
  double? toDouble() => double.tryParse(this);
}
