import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Notification item widget
class NotificationItemWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    this.onTap,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: AppResponsive.s(context, 48),
              height: AppResponsive.s(context, 48),
              decoration: BoxDecoration(
                color: AppColors.notificationIconBackground,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 12),
                ),
              ),
              child: Icon(
                icon,
                size: AppResponsive.icon(context, 24),
                color: iconColor,
              ),
            ),
            SizedBox(width: AppResponsive.p(context, 12)),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 15),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 12),
                          color: AppColors.notificationTimeText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 4)),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
