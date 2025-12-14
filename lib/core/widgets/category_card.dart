import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Category card widget
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppResponsive.s(context, 85),
        padding: EdgeInsets.all(AppResponsive.p(context, 8)),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppResponsive.icon(context, 28),
              color: AppColors.primary,
            ),
            SizedBox(height: AppResponsive.p(context, 6)),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 11),
                      height: 1.2,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
