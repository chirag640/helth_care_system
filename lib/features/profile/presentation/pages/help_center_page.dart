import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';

/// Help Center Page - Entry point to support
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: AppResponsive.icon(context, 24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Help Center',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppResponsive.p(context, 24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Image.asset(
              'assets/images/help_illustration.png',
              height: AppResponsive.s(context, 200),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: AppResponsive.s(context, 200),
                  width: AppResponsive.s(context, 200),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 20),
                    ),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: AppResponsive.icon(context, 80),
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            SizedBox(height: AppResponsive.p(context, 32)),

            // Heading
            Text(
              'We are here to help you with your AI Health needs!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 22)),
            ),
            SizedBox(height: AppResponsive.p(context, 16)),

            // Subtext
            Text(
              'We aim to reply within a few minutes!😇',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 16),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 40)),

            // Start Live Chat Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.profileLiveChat);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: AppResponsive.p(context, 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 12),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.white,
                      size: AppResponsive.icon(context, 20),
                    ),
                    SizedBox(width: AppResponsive.p(context, 12)),
                    Text(
                      'Start Live Chat',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
