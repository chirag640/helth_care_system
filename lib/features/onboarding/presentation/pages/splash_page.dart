import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';
import '../../../auth/controller/auth_controller.dart';

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
    final isAuthenticated = ref.read(authControllerProvider).isAuthenticated;

    if (!mounted) return;

    if (isAuthenticated) {
      // User is logged in, go to home
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      // User is not logged in, go to onboarding
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
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
