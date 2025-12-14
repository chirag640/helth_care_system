import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Profile menu item widget
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppResponsive.p(context, 16)),
        margin: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppResponsive.icon(context, 24),
              color: iconColor ?? AppColors.textPrimary,
            ),
            SizedBox(width: AppResponsive.p(context, 16)),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 15),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 13),
                    ),
              ),
            SizedBox(width: AppResponsive.p(context, 8)),
            Icon(
              Icons.chevron_right,
              size: AppResponsive.icon(context, 20),
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
