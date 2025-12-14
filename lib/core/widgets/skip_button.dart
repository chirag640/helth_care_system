import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Skip button for onboarding screens
class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
    required this.onPressed,
    this.text = 'Skip',
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.p(context, 20),
          vertical: AppResponsive.p(context, 12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.skipButton,
          fontSize: AppResponsive.fontSize(context, 16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
