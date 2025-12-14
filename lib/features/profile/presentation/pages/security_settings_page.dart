import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Security Settings Page - 2FA, Google Auth, Face ID
class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _twoFactorAuth = true;
  bool _googleAuth = false;
  bool _faceId = true;

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
          'Security Settings',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppResponsive.p(context, 16)),
              child: Column(
                children: [
                  // Illustration
                  Image.asset(
                    'assets/images/security_illustration.png',
                    height: AppResponsive.s(context, 150),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: AppResponsive.s(context, 150),
                        width: AppResponsive.s(context, 150),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 20),
                          ),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          size: AppResponsive.icon(context, 60),
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppResponsive.p(context, 32)),

                  // 2FA Toggle
                  _buildToggleItem(
                    title: '2FA',
                    description:
                        '2FA is an identity and access management security method.',
                    value: _twoFactorAuth,
                    onChanged: (value) {
                      setState(() {
                        _twoFactorAuth = value;
                      });
                    },
                  ),

                  // Google Authenticator Toggle
                  _buildToggleItem(
                    title: 'Google Authenticator',
                    description:
                        'Google Authenticator adds an extra layer of security.',
                    value: _googleAuth,
                    onChanged: (value) {
                      setState(() {
                        _googleAuth = value;
                      });
                    },
                  ),

                  // Face ID Toggle
                  _buildToggleItem(
                    title: 'Face ID',
                    description:
                        'Face ID lets you securely unlock your iPhone or iPad.',
                    value: _faceId,
                    onChanged: (value) {
                      setState(() {
                        _faceId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 16)),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                child: Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 12),
        ),
        border: Border.all(color: AppColors.profileSectionDivider),
      ),
      child: Row(
        children: [
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
                SizedBox(height: AppResponsive.p(context, 4)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 13),
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 12)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.sliderInactive,
          ),
        ],
      ),
    );
  }
}
