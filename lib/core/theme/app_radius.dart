import 'package:flutter/material.dart';

/// Consistent border radius tokens for the app
/// Use these instead of magic numbers for rounded corners
class AppRadius {
  AppRadius._();

  // Radius values
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;
  static const double full = 999.0; // Pill shape

  // BorderRadius presets
  static const BorderRadius noneRadius = BorderRadius.zero;
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius sRadius = BorderRadius.all(Radius.circular(s));
  static const BorderRadius mRadius = BorderRadius.all(Radius.circular(m));
  static const BorderRadius lRadius = BorderRadius.all(Radius.circular(l));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlRadius = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius xxxlRadius =
      BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius fullRadius =
      BorderRadius.all(Radius.circular(full));

  // Semantic radius (for specific use cases)
  static const double button = xxxl; // 28 (pill-shaped buttons)
  static const double card = m; // 12
  static const double dialog = l; // 16
  static const double bottomSheet = xl; // 20 (top corners only)
  static const double input = m; // 12
  static const double chip = l; // 16
  static const double avatar = full; // Circular
  static const double badge = xs; // 4
  static const double container = m; // 12

  // BorderRadius semantic presets
  static const BorderRadius buttonRadius = xxxlRadius;
  static const BorderRadius cardRadius = mRadius;
  static const BorderRadius dialogRadius = lRadius;
  static const BorderRadius inputRadius = mRadius;
  static const BorderRadius chipRadius = lRadius;
  static const BorderRadius badgeRadius = xsRadius;
  static const BorderRadius containerRadius = mRadius;

  // Top-only radius for bottom sheets
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
