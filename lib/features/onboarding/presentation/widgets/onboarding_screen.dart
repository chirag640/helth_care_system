import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive.dart';

/// Onboarding screen widget
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.description,
    this.titleHighlight,
  });

  final String svgAsset;
  final String title;
  final String description;
  final String? titleHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.onboardingBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.p(context, 24),
        ),
        child: Column(
          children: [
            const Spacer(flex: 1),
            // Illustration
            SizedBox(
              height: AppResponsive.h(context, 0.45),
              child: Image.asset(
                svgAsset,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(flex: 1),
            // Title
            _buildTitle(context),
            SizedBox(height: AppResponsive.p(context, 16)),
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppResponsive.fontSize(context, 14),
                height: 1.5,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (titleHighlight == null) {
      return Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppResponsive.fontSize(context, 24),
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      );
    }

    final parts = title.split(titleHighlight!);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppResponsive.fontSize(context, 24),
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: titleHighlight,
            style: const TextStyle(color: AppColors.primary),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
