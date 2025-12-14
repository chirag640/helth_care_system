import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Navigation button (arrow) for onboarding
class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.isBackButton = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final bool isBackButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 28)),
      child: Container(
        width: AppResponsive.s(context, 56),
        height: AppResponsive.s(context, 56),
        decoration: BoxDecoration(
          color: isBackButton ? Colors.transparent : AppColors.primary,
          shape: BoxShape.circle,
          border: isBackButton
              ? Border.all(
                  color: AppColors.primary,
                  width: AppResponsive.thickness(context, 2),
                )
              : null,
        ),
        child: Icon(
          icon,
          color: isBackButton ? AppColors.primary : AppColors.white,
          size: AppResponsive.icon(context, 24),
        ),
      ),
    );
  }
}
