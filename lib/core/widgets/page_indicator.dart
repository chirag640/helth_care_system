import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Page indicator dots for onboarding/carousel
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeColor,
    this.inactiveColor,
  });

  final int currentPage;
  final int pageCount;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          width: AppResponsive.s(context, 8),
          height: AppResponsive.s(context, 8),
          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 4),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? (activeColor ?? AppColors.primary)
                : (inactiveColor ?? AppColors.greyLight),
          ),
        ),
      ),
    );
  }
}
