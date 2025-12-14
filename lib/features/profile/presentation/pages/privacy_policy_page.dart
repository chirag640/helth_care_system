import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Privacy Policy Page - Terms & Conditions, Cancellation Policy
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppResponsive.p(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cancellation Policy Section
            Text(
              'Cancellation Policy',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 20)),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 24)),

            // Terms & Conditions Section
            Text(
              'Terms & Condition',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 20)),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            Text(
              'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
