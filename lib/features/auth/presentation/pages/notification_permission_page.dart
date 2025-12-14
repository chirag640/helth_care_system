import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';

class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Notification icon
              Container(
                width: AppResponsive.s(context, 120),
                height: AppResponsive.s(context, 120),
                decoration: BoxDecoration(
                  color: AppColors.greyLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: AppResponsive.icon(context, 60),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Title
              Text(
                'Enable Notification Access',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 28)),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Description
              Text(
                'Enable notifications to receive real-time\nupdates.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              // Allow Notification button
              SizedBox(
                width: double.infinity,
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text(
                    'Allow Notification',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 16)),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 16)),
              // Maybe Later button
              SizedBox(
                width: double.infinity,
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyLight.withValues(alpha: 0.5),
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 28),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Maybe Later',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 16)),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 60)),
            ],
          ),
        ),
      ),
    );
  }
}
