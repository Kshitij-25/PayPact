class AppConstants {
  // App Info
  static const String appName = 'PayPact';
  static const String appVersion = '1.0.0';

  // Default Values
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashAnimationDuration = Duration(milliseconds: 1500);

  // Debounce Timers
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration buttonDebounce = Duration(milliseconds: 1000);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
