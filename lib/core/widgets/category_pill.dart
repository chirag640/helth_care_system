import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Category pill widget (used in detail pages)
class CategoryPill extends StatelessWidget {
  const CategoryPill({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.p(context, 12),
          vertical: AppResponsive.p(context, 8),
        ),
        decoration: BoxDecoration(
          color:
              isActive ? AppColors.primary : AppColors.detailCategoryBackground,
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppResponsive.icon(context, 16),
              color: isActive ? AppColors.white : AppColors.primary,
            ),
            SizedBox(width: AppResponsive.p(context, 6)),
            Text(
              label,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
