import 'package:flutter/widgets.dart';
import 'package:flutter/semantics.dart';

import '../utils/logger.dart';

/// Accessibility utilities for healthcare app
/// Ensures app is usable by all patients including those with disabilities
class AccessibilityUtils {
  AccessibilityUtils._();

  // Minimum touch target size (WCAG 2.1 AAA compliance)
  static const double minTouchTargetSize = 48.0;

  // Minimum contrast ratio for text (WCAG 2.1 AA compliance)
  static const double minContrastRatio = 4.5;

  // Large text contrast ratio (WCAG 2.1 AA compliance)
  static const double minContrastRatioLargeText = 3.0;

  /// Check if a color combination meets contrast requirements
  static bool meetsContrastRequirement(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = _calculateContrastRatio(foreground, background);
    final requiredRatio =
        isLargeText ? minContrastRatioLargeText : minContrastRatio;
    return ratio >= requiredRatio;
  }

  /// Calculate contrast ratio between two colors
  static double _calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = _calculateLuminance(foreground);
    final bgLuminance = _calculateLuminance(background);

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _calculateLuminance(Color color) {
    final r = _linearize((color.r * 255).round().clamp(0, 255) / 255);
    final g = _linearize((color.g * 255).round().clamp(0, 255) / 255);
    final b = _linearize((color.b * 255).round().clamp(0, 255) / 255);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    return value <= 0.03928
        ? value / 12.92
        : ((value + 0.055) / 1.055) * ((value + 0.055) / 1.055);
  }

  /// Ensure touch target meets minimum size
  static double ensureMinTouchTarget(double size) {
    if (size < minTouchTargetSize) {
      AppLogger.warning(
        'Touch target size ($size) is below minimum ($minTouchTargetSize)',
        'Accessibility',
      );
    }
    return size < minTouchTargetSize ? minTouchTargetSize : size;
  }

  /// Generate semantic label for medical values
  static String medicalValueLabel({
    required String name,
    required String value,
    String? unit,
    String? status,
  }) {
    final parts = [name, value];
    if (unit != null) parts.add(unit);
    if (status != null) parts.add('Status: $status');
    return parts.join(', ');
  }

  /// Generate semantic label for medication
  static String medicationLabel({
    required String name,
    required String dosage,
    required String frequency,
    String? instructions,
  }) {
    final label = '$name, $dosage, take $frequency';
    if (instructions != null) {
      return '$label. Instructions: $instructions';
    }
    return label;
  }

  /// Generate semantic label for appointment
  static String appointmentLabel({
    required String doctorName,
    required String specialty,
    required DateTime dateTime,
    String? status,
  }) {
    final dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final timeStr =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    var label =
        'Appointment with Dr. $doctorName, $specialty, on $dateStr at $timeStr';
    if (status != null) {
      label += '. Status: $status';
    }
    return label;
  }

  /// Generate semantic label for vital signs
  static String vitalSignLabel({
    required String type,
    required String value,
    String? unit,
    bool? isNormal,
  }) {
    var label = '$type: $value';
    if (unit != null) label += ' $unit';
    if (isNormal != null) {
      label += isNormal ? ', within normal range' : ', outside normal range';
    }
    return label;
  }

  /// Generate hint text for screen readers
  static String hintForAction(String action) {
    return 'Double tap to $action';
  }
}

/// Semantic wrapper for screen reader support
class SemanticWrapper extends StatelessWidget {
  const SemanticWrapper({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.button = false,
    this.header = false,
    this.link = false,
    this.excludeSemantics = false,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final String label;
  final String? hint;
  final bool button;
  final bool header;
  final bool link;
  final bool excludeSemantics;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      header: header,
      link: link,
      excludeSemantics: excludeSemantics,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

/// Accessible text scaling wrapper
class AccessibleText extends StatelessWidget {
  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.semanticsLabel,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final String? semanticsLabel;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}

/// Minimum touch target wrapper
class MinTouchTarget extends StatelessWidget {
  const MinTouchTarget({
    super.key,
    required this.child,
    this.minSize = AccessibilityUtils.minTouchTargetSize,
    this.onTap,
  });

  final Widget child;
  final double minSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Screen reader announcement helper
class ScreenReaderAnnouncement {
  /// Announce a message to screen readers
  /// Uses Semantics widget and SemanticsService for accessibility announcements
  static void announce(BuildContext context, String message) {
    // For newer Flutter, use SemanticsBinding for announcements
    // This is a simple implementation that works with most screen readers
    // The message will be announced through the semantics tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: deprecated_member_use
      SemanticsService.announce(message, TextDirection.ltr);
    });
  }

  /// Announce success message
  static void announceSuccess(BuildContext context, String action) {
    announce(context, '$action successful');
  }

  /// Announce error message
  static void announceError(BuildContext context, String error) {
    announce(context, 'Error: $error');
  }

  /// Announce loading state
  static void announceLoading(BuildContext context, {String? item}) {
    final message = item != null ? 'Loading $item' : 'Loading';
    announce(context, message);
  }

  /// Announce completion
  static void announceComplete(BuildContext context, {String? item}) {
    final message = item != null ? '$item loaded' : 'Loading complete';
    announce(context, message);
  }
}
