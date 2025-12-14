import 'package:flutter/material.dart';

/// Responsive utility class for scaling UI elements
class AppResponsive {
  AppResponsive._();

  /// Width percentage (0.0 to 1.0)
  static double w(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Height percentage (0.0 to 1.0)
  static double h(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// Scale based on design width (390px base)
  static double s(BuildContext context, double designPx) {
    return designPx * (MediaQuery.of(context).size.width / 390);
  }

  /// Border radius scaling
  static double radius(BuildContext context, double designPx) {
    return s(context, designPx);
  }

  /// Icon size scaling
  static double icon(BuildContext context, double designPx) {
    return s(context, designPx);
  }

  /// Padding/spacing scaling
  static double p(BuildContext context, double designPx) {
    return s(context, designPx);
  }

  /// Thickness scaling (borders, dividers)
  static double thickness(BuildContext context, double designPx) {
    return s(context, designPx);
  }

  /// Font size scaling
  static double fontSize(BuildContext context, double designPx) {
    return s(context, designPx);
  }
}
