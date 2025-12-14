import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Custom app bar with profile and notifications
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.greeting = 'Hello, Good Morning!',
    this.userName = 'John D. Wick',
    this.profileImage,
    this.notificationCount = 0,
    this.onProfileTap,
    this.onNotificationTap,
  });

  final String greeting;
  final String userName;
  final String? profileImage;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.p(context, 16),
          vertical: AppResponsive.p(context, 12),
        ),
        child: Row(
          children: [
            // Profile avatar
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: AppResponsive.s(context, 48),
                height: AppResponsive.s(context, 48),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: AppResponsive.thickness(context, 2),
                  ),
                ),
                child: ClipOval(
                  child: profileImage != null
                      ? Image.network(
                          profileImage!,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: AppResponsive.icon(context, 24),
                          color: AppColors.primary,
                        ),
                ),
              ),
            ),
            SizedBox(width: AppResponsive.p(context, 12)),
            // Greeting and name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 14)),
                  ),
                  SizedBox(height: AppResponsive.p(context, 2)),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Notification bell
            GestureDetector(
              onTap: onNotificationTap,
              child: Stack(
                children: [
                  Container(
                    width: AppResponsive.s(context, 48),
                    height: AppResponsive.s(context, 48),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.08),
                          blurRadius: AppResponsive.s(context, 8),
                          offset: Offset(0, AppResponsive.s(context, 2)),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: AppResponsive.icon(context, 24),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: AppResponsive.s(context, 4),
                      right: AppResponsive.s(context, 4),
                      child: Container(
                        width: AppResponsive.s(context, 18),
                        height: AppResponsive.s(context, 18),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: AppResponsive.thickness(context, 2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 9 ? '9+' : '$notificationCount',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 9),
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
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
