import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Notification Settings Page - Daily Reminders, Appointment Notifications, Audio Quality
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _dailyReminders = true;
  bool _appointmentNotifications = false;

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
          'Notification Settings',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // General Settings Section
                  Text(
                    'General Settings',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppResponsive.p(context, 16)),

                  // Daily Reminders Toggle
                  _buildToggleItem(
                    title: 'Daily Reminders',
                    description:
                        'Receive daily nudges to complete health assessments.',
                    value: _dailyReminders,
                    onChanged: (value) {
                      setState(() {
                        _dailyReminders = value;
                      });
                    },
                  ),

                  // Appointment Notifications Toggle
                  _buildToggleItem(
                    title: 'Appointment Notifications',
                    description:
                        'Receive notification for your doctor appointment',
                    value: _appointmentNotifications,
                    onChanged: (value) {
                      setState(() {
                        _appointmentNotifications = value;
                      });
                    },
                  ),

                  SizedBox(height: AppResponsive.p(context, 24)),

                  // Audio Settings Section
                  Text(
                    'Audio Settings',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppResponsive.p(context, 16)),

                  // Audio Quality
                  Container(
                    padding: EdgeInsets.all(AppResponsive.p(context, 16)),
                    decoration: BoxDecoration(
                      color: AppColors.profileCardBackground,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 12),
                      ),
                      border:
                          Border.all(color: AppColors.profileSectionDivider),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.volume_up_outlined,
                          size: AppResponsive.icon(context, 24),
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: AppResponsive.p(context, 16)),
                        Expanded(
                          child: Text(
                            'Audio Quality',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 15),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          'High',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 14)),
                        ),
                        SizedBox(width: AppResponsive.p(context, 8)),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                          size: AppResponsive.icon(context, 24),
                        ),
                      ],
                    ),
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
                  'Save Changes',
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
                    fontSize: AppResponsive.fontSize(context, 15),
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
