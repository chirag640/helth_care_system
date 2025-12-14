import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/profile_menu_item.dart';
import '../../../../core/routing/app_router.dart';
import '../../controller/profile_controller.dart';

/// Profile main page
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;

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
                        profile.fullName,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show QR dialog
                          _showQRDialog(context, profile);
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
                        backgroundImage: AssetImage(profile.avatarPath!),
                      ),
                      SizedBox(width: AppResponsive.p(context, 16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.phoneNumber,
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
                                'ID: ${profile.userId}',
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
                              Icons.male,
                              size: AppResponsive.icon(context, 16),
                              color: AppColors.primary,
                            ),
                            SizedBox(width: AppResponsive.p(context, 4)),
                            Text(
                              profile.gender,
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

  void _showQRDialog(BuildContext context, ProfileData profile) {
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
                    backgroundImage: AssetImage(profile.avatarPath!),
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
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(profileControllerProvider.notifier).signOut();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(AppRouter.signIn);
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.signOutText),
            ),
          ),
        ],
      ),
    );
  }
}
