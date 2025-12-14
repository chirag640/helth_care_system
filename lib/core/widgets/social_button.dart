import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Social login button (Apple, Google, Facebook)
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 28)),
      child: Container(
        width: AppResponsive.s(context, 64),
        height: AppResponsive.s(context, 64),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.greyLight,
            width: AppResponsive.thickness(context, 1),
          ),
        ),
        child: Icon(
          icon,
          size: AppResponsive.icon(context, 24),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
