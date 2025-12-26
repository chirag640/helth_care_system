import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../profile/controller/profile_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Show splash for minimum 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is already authenticated
    await ref.read(authControllerProvider.notifier).checkAuthStatus();
    final authState = ref.read(authControllerProvider);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      // User is logged in, check if profile is complete
      await ref.read(profileControllerProvider.notifier).loadProfile();
      final profileState = ref.read(profileControllerProvider);

      if (!mounted) return;

      // Check if user has completed initial setup
      final tokenStorage = TokenStorage.instance;
      final isProfileSetupComplete = tokenStorage.isProfileSetupComplete();
      final arePermissionsRequested = tokenStorage.arePermissionsRequested();

      if (!arePermissionsRequested) {
        // New user - go through permission flow
        Navigator.pushReplacementNamed(context, AppRouter.locationPermission);
      } else if (!isProfileSetupComplete && !profileState.isProfileComplete) {
        // User hasn't completed profile setup
        Navigator.pushReplacementNamed(
          context,
          AppRouter.profilePersonalInfo,
          arguments: 'initial',
        );
      } else {
        // Everything complete - go to home
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    } else {
      // User is not logged in
      final isOnboardingComplete = TokenStorage.instance.isOnboardingComplete();

      if (isOnboardingComplete) {
        // User has seen onboarding before, go to welcome
        Navigator.pushReplacementNamed(context, AppRouter.welcome);
      } else {
        // First time user, show onboarding
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Text(
            'LOGO',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.white,
                  fontSize: AppResponsive.fontSize(context, 48),
                  letterSpacing: 4,
                ),
          ),
        ),
      ),
    );
  }
}
