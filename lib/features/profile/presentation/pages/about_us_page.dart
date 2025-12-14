import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// About Us Page - Company Information
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
          'About Us',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppResponsive.p(context, 16)),
        child: Column(
          children: [
            // Logo & Company Name
            Image.asset(
              'assets/images/logo.png',
              height: AppResponsive.s(context, 80),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: AppResponsive.s(context, 80),
                  width: AppResponsive.s(context, 80),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: AppResponsive.icon(context, 40),
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            SizedBox(height: AppResponsive.p(context, 16)),
            Text(
              'ExpertMed, Inc',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 24)),
            ),
            SizedBox(height: AppResponsive.p(context, 8)),
            Text(
              'AI Health Assistant Solutions since 2025',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
            ),
            SizedBox(height: AppResponsive.p(context, 32)),

            // Office Address Section
            _buildSection(
              context,
              icon: Icons.location_on_outlined,
              title: 'Office Address',
              content: [
                'Expertmed Tower',
                'X Avenue, North Detroit',
                'Texas, United States 11578',
              ],
            ),

            // Telephone Section
            _buildSection(
              context,
              icon: Icons.phone_outlined,
              title: 'Telephone',
              content: [
                '(+1) 234-567-8900 (Office 1)',
                '(+1) 234-567-8901 (Office 2)',
                '(+1) 234-567-8902 (Office 3)',
              ],
            ),

            // Email Section
            _buildSection(
              context,
              icon: Icons.email_outlined,
              title: 'Email',
              content: [
                'support@expertmed.com',
                'contact@expertmed.com',
                'info@expertmed.com',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.profileSectionDivider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(AppResponsive.radius(context, 10)),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppResponsive.icon(context, 24),
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppResponsive.p(context, 8)),
                ...content.map((text) => Padding(
                      padding:
                          EdgeInsets.only(bottom: AppResponsive.p(context, 4)),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppResponsive.fontSize(context, 14)),
                      ),
                    )),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: AppResponsive.icon(context, 24),
          ),
        ],
      ),
    );
  }
}
