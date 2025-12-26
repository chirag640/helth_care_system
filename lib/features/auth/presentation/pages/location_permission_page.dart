import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  bool _isRequesting = false;

  Future<void> _requestLocationPermission() async {
    if (_isRequesting) return;

    setState(() => _isRequesting = true);

    try {
      final status = await Permission.location.request();

      if (!mounted) return;

      if (status.isGranted || status.isLimited) {
        // Permission granted - proceed to notification permission
        Navigator.pushReplacementNamed(
            context, AppRouter.notificationPermission);
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open settings
        _showSettingsDialog();
      } else {
        // Permission denied but can ask again - still proceed
        Navigator.pushReplacementNamed(
            context, AppRouter.notificationPermission);
      }
    } catch (e) {
      // If permission request fails, still proceed
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, AppRouter.notificationPermission);
      }
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location permission is permanently denied. Please enable it from app settings to use location-based features.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Skip to next page
              Navigator.pushReplacementNamed(
                  context, AppRouter.notificationPermission);
            },
            child: const Text('Skip'),
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

  void _skipLocationPermission() {
    Navigator.pushReplacementNamed(context, AppRouter.notificationPermission);
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
                // Location icon
                Container(
                  width: AppResponsive.s(context, 120),
                  height: AppResponsive.s(context, 120),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: AppResponsive.icon(context, 60),
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppResponsive.p(context, 32)),
                // Title
                Text(
                  'What is Your Location?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: AppResponsive.fontSize(context, 28)),
                ),
                SizedBox(height: AppResponsive.p(context, 12)),
                // Description
                Text(
                  'We need to know your location in order to suggest\nnearby services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 14),
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                // Allow Location button
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.s(context, 56),
                  child: ElevatedButton(
                    onPressed:
                        _isRequesting ? null : _requestLocationPermission,
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
                            'Allow Location Access',
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
                // Enter Manually button
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.s(context, 56),
                  child: ElevatedButton(
                    onPressed: _isRequesting ? null : _skipLocationPermission,
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
                      'Enter Location Manually',
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
