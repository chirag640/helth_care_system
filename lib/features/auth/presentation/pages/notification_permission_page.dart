import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';
import '../../../profile/controller/profile_controller.dart';

class NotificationPermissionPage extends ConsumerStatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  ConsumerState<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends ConsumerState<NotificationPermissionPage> {
  bool _isRequesting = false;

  Future<void> _requestNotificationPermission() async {
    if (_isRequesting) return;

    setState(() => _isRequesting = true);

    try {
      final status = await Permission.notification.request();

      if (!mounted) return;

      // Mark permissions as requested regardless of result
      await TokenStorage.instance.setPermissionsRequested(true);

      if (status.isPermanentlyDenied) {
        // Show dialog to open settings but still proceed
        _showSettingsDialog();
      } else {
        // Permission granted, denied, or limited - proceed to profile check
        await _navigateToNextScreen();
      }
    } catch (e) {
      // If permission request fails, still proceed
      await TokenStorage.instance.setPermissionsRequested(true);
      if (mounted) {
        await _navigateToNextScreen();
      }
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  Future<void> _navigateToNextScreen() async {
    // Check if profile is complete
    await ref.read(profileControllerProvider.notifier).loadProfile();
    final profileState = ref.read(profileControllerProvider);

    if (!mounted) return;

    if (!profileState.isProfileComplete) {
      // Profile incomplete - go to personal info setup
      Navigator.pushReplacementNamed(
        context,
        AppRouter.profilePersonalInfo,
        arguments: 'initial',
      );
    } else {
      // Profile complete - go to home
      await TokenStorage.instance.setProfileSetupComplete(true);
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission'),
        content: const Text(
          'Notification permission is permanently denied. You can enable it later from app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _navigateToNextScreen();
            },
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _skipNotificationPermission() async {
    setState(() => _isRequesting = true);
    await TokenStorage.instance.setPermissionsRequested(true);
    await _navigateToNextScreen();
    if (mounted) {
      setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                    onPressed:
                        _isRequesting ? null : _requestNotificationPermission,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: _isRequesting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Allow Notification',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize:
                                        AppResponsive.fontSize(context, 16)),
                          ),
                  ),
                ),
                SizedBox(height: AppResponsive.p(context, 16)),
                // Maybe Later button
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.s(context, 56),
                  child: ElevatedButton(
                    onPressed:
                        _isRequesting ? null : _skipNotificationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.greyLight.withValues(alpha: 0.5),
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
      ),
    );
  }
}
