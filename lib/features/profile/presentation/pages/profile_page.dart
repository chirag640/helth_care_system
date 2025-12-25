import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/profile_menu_item.dart';
import '../../../../core/routing/app_router.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/profile_controller.dart';
import '../../models/models.dart';

/// Profile main page
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final patient = profileState.patient;

    // Show loading state
    if (profileState.isLoading && patient == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: const Center(child: LoadingIndicator()),
        bottomNavigationBar: AppBottomNav.create(context, 4),
      );
    }

    // Show error state
    if (profileState.error != null && patient == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: ErrorDisplay(
            message: profileState.error!,
            onRetry: () =>
                ref.read(profileControllerProvider.notifier).loadProfile(),
          ),
        ),
        bottomNavigationBar: AppBottomNav.create(context, 4),
      );
    }

    // Create display data from patient model
    final displayData = _ProfileDisplayData.fromPatient(patient);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with profile info
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    AppResponsive.p(context, 20),
                left: AppResponsive.p(context, 20),
                right: AppResponsive.p(context, 20),
                bottom: AppResponsive.p(context, 20),
              ),
              decoration: BoxDecoration(
                color: AppColors.profileHeaderBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    AppResponsive.radius(context, 24),
                  ),
                  bottomRight: Radius.circular(
                    AppResponsive.radius(context, 24),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayData.fullName,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show QR dialog
                          _showQRDialog(context, displayData);
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            AppResponsive.p(context, 12),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 12),
                            ),
                          ),
                          child: Icon(
                            Icons.qr_code_2,
                            color: AppColors.white,
                            size: AppResponsive.icon(context, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 8)),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppResponsive.s(context, 40),
                        backgroundImage: displayData.avatarPath != null
                            ? (displayData.avatarPath!.startsWith('http')
                                ? NetworkImage(displayData.avatarPath!)
                                : AssetImage(displayData.avatarPath!)
                                    as ImageProvider)
                            : null,
                        child: displayData.avatarPath == null
                            ? Icon(Icons.person,
                                size: AppResponsive.icon(context, 40),
                                color: AppColors.white)
                            : null,
                      ),
                      SizedBox(width: AppResponsive.p(context, 16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayData.phoneNumber,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 14),
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: AppResponsive.p(context, 8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.p(context, 12),
                                vertical: AppResponsive.p(context, 6),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppResponsive.radius(context, 16),
                                ),
                              ),
                              child: Text(
                                'ID: ${displayData.userId}',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 12),
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.p(context, 12),
                          vertical: AppResponsive.p(context, 6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              displayData.genderIcon,
                              size: AppResponsive.icon(context, 16),
                              color: AppColors.primary,
                            ),
                            SizedBox(width: AppResponsive.p(context, 4)),
                            Text(
                              displayData.gender,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 12),
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppResponsive.p(context, 16)),

            // Menu items
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    label: 'Personal Information',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profilePersonalInfo);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Smart Notifications',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profileNotificationSettings);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    label: 'Languages',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profileLanguages);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.star_outline,
                    label: 'Send Feedback',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profileFeedback);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.payment_outlined,
                    label: 'Payment Methods',
                    onTap: () {},
                  ),

                  SizedBox(height: AppResponsive.p(context, 16)),

                  // Security & Privacy section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Security & Privacy',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.p(context, 12)),
                  ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Privacy Policy',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profilePrivacyPolicy);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    label: 'Security Settings',
                    trailing: '31+',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profileSecuritySettings);
                    },
                  ),

                  SizedBox(height: AppResponsive.p(context, 16)),

                  // Help & Support section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Icon(
                        Icons.help_outline,
                        size: AppResponsive.icon(context, 20),
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 12)),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    label: 'Help Center',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.profileHelpCenter);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.contact_mail_outlined,
                    label: 'About Us',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.profileAboutUs);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.quiz_outlined,
                    label: 'FAQ',
                    trailing: '~5m Response',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.profileFaq);
                    },
                  ),

                  SizedBox(height: AppResponsive.p(context, 16)),

                  // Sign Out
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.p(context, 12)),
                  GestureDetector(
                    onTap: () {
                      // Show sign out confirmation
                      _showSignOutDialog(context, ref);
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
                      decoration: BoxDecoration(
                        color: AppColors.signOutBackground,
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: AppResponsive.icon(context, 24),
                            color: AppColors.signOutText,
                          ),
                          SizedBox(width: AppResponsive.p(context, 16)),
                          Expanded(
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 15),
                                fontWeight: FontWeight.w600,
                                color: AppColors.signOutText,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: AppResponsive.icon(context, 20),
                            color: AppColors.signOutText,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppResponsive.p(context, 24)),

                  // App version
                  Column(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        size: AppResponsive.icon(context, 32),
                        color: AppColors.primary,
                      ),
                      SizedBox(height: AppResponsive.p(context, 8)),
                      Text(
                        'expertmed v2.2.1b',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'All Rights Reserved 2026©',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 12),
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppResponsive.p(context, 100)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav.create(context, 4),
    );
  }

  void _showQRDialog(BuildContext context, _ProfileDisplayData profile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 24),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(AppResponsive.p(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: AppResponsive.s(context, 24),
                    backgroundImage: profile.avatarPath != null
                        ? (profile.avatarPath!.startsWith('http')
                            ? NetworkImage(profile.avatarPath!)
                            : AssetImage(profile.avatarPath!) as ImageProvider)
                        : null,
                    child: profile.avatarPath == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: AppResponsive.p(context, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 16)),
                        ),
                        Text(
                          'ID: ${profile.userId}',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              Container(
                padding: EdgeInsets.all(AppResponsive.p(context, 24)),
                decoration: BoxDecoration(
                  color: AppColors.profileQrBackground,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 16),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: AppResponsive.s(context, 200),
                      height: AppResponsive.s(context, 200),
                      color: AppColors.white,
                      child: Center(
                        child: Text(
                          'QR CODE',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppResponsive.p(context, 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.p(context, 12)),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppResponsive.p(context, 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 16),
          ),
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 20),
                vertical: AppResponsive.p(context, 12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              // Sign out using auth controller
              await ref.read(authControllerProvider.notifier).signOut();

              if (context.mounted) {
                // Close loading indicator
                Navigator.pop(context);
                // Navigate to sign in page and clear all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.signIn,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.signOutText,
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 20),
                vertical: AppResponsive.p(context, 12),
              ),
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class to extract display data from PatientModel
class _ProfileDisplayData {
  const _ProfileDisplayData({
    required this.fullName,
    required this.phoneNumber,
    required this.userId,
    required this.gender,
    required this.genderIcon,
    this.avatarPath,
  });

  factory _ProfileDisplayData.fromPatient(PatientModel? patient) {
    if (patient == null) {
      return _ProfileDisplayData(
        fullName: 'User',
        phoneNumber: 'Not set',
        userId: 'N/A',
        gender: 'N/A',
        genderIcon: Icons.person,
        avatarPath: null,
      );
    }

    IconData genderIcon;
    String genderDisplay;
    switch (patient.gender) {
      case Gender.male:
        genderIcon = Icons.male;
        genderDisplay = 'Male';
        break;
      case Gender.female:
        genderIcon = Icons.female;
        genderDisplay = 'Female';
        break;
      case Gender.other:
        genderIcon = Icons.transgender;
        genderDisplay = 'Other';
        break;
      case Gender.preferNotToSay:
        genderIcon = Icons.person;
        genderDisplay = 'Prefer not to say';
        break;
      case null:
        genderIcon = Icons.person;
        genderDisplay = 'N/A';
        break;
    }

    return _ProfileDisplayData(
      fullName: patient.fullName,
      phoneNumber: patient.phoneNumber ?? 'Not set',
      userId: patient.id,
      gender: genderDisplay,
      genderIcon: genderIcon,
      avatarPath: patient.profilePhoto,
    );
  }

  final String fullName;
  final String phoneNumber;
  final String userId;
  final String gender;
  final IconData genderIcon;
  final String? avatarPath;
}
