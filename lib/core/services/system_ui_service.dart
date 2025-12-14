import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service to manage system UI overlays (status bar & navigation bar)
/// Handles transparent, edge-to-edge UI with theme-aware icon brightness
class SystemUIService {
  SystemUIService._();

  /// Configure transparent system UI with theme-aware icon brightness
  ///
  /// [isDark] - Whether dark mode is active
  /// - Light mode: dark icons on light/transparent bars
  /// - Dark mode: light icons on dark/transparent bars
  static void setTransparentSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // Status bar (top)
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark, // Android
        statusBarBrightness:
            isDark ? Brightness.dark : Brightness.light, // iOS (inverted)

        // Navigation bar (bottom)
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  /// Enable edge-to-edge immersive mode
  /// Content draws behind system bars
  static void setEdgeToEdgeMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }

  /// Initialize system UI on app startup
  /// Call this in main() after WidgetsFlutterBinding.ensureInitialized()
  static void initialize({bool isDark = false}) {
    setEdgeToEdgeMode();
    setTransparentSystemUI(isDark);
  }

  /// Update system UI when theme changes
  /// Call this when switching between light/dark mode
  static void updateForTheme(ThemeMode themeMode, BuildContext context) {
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    setTransparentSystemUI(isDark);
  }
}
