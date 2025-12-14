/// Consistent spacing tokens for the app
/// Use these instead of magic numbers for padding, margin, gaps, etc.
class AppSpacing {
  AppSpacing._();

  // Atomic spacing scale (base: 4px)
  static const double xxs = 4.0; // Extra extra small
  static const double xs = 8.0; // Extra small
  static const double s = 12.0; // Small
  static const double m = 16.0; // Medium (default)
  static const double l = 24.0; // Large
  static const double xl = 32.0; // Extra large
  static const double xxl = 40.0; // Extra extra large
  static const double xxxl = 48.0; // Extra extra extra large

  // Semantic spacing (for specific use cases)
  static const double cardPadding = m; // 16
  static const double screenPadding = l; // 24
  static const double sectionGap = l; // 24
  static const double itemGap = s; // 12
  static const double buttonPadding = m; // 16
  static const double iconPadding = xs; // 8
  static const double listItemSpacing = m; // 16
  static const double formFieldSpacing = m; // 16
  static const double dialogPadding = l; // 24
  static const double chipPadding = s; // 12
  static const double badgePadding = xs; // 8
  static const double dividerSpacing = s; // 12
  static const double bottomSheetPadding = l; // 24
}
