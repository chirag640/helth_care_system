import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Bottom navigation bar item data
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Custom bottom navigation bar
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: AppResponsive.s(context, 16),
            offset: Offset(0, AppResponsive.s(context, -2)),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: AppResponsive.s(context, 72),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(context, items[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, BottomNavItem item, int index) {
    final isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? (item.activeIcon ?? item.icon) : item.icon,
              size: AppResponsive.icon(context, 22),
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(height: AppResponsive.p(context, 2)),
            Text(
              item.label,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 10),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
