import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.welcomeBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Medical icon
              Container(
                width: AppResponsive.s(context, 64),
                height: AppResponsive.s(context, 64),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 16),
                  ),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  size: AppResponsive.icon(context, 36),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Welcome title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 28),
                        height: 1.3,
                      ),
                  children: const [
                    TextSpan(text: 'Hello! Welcome to\n'),
                    TextSpan(text: 'XpertMed. '),
                    TextSpan(text: '👋'),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Description
              Text(
                'Your Doctor Appointment Booking App.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 16),
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
              // Illustration
              SizedBox(
                height: AppResponsive.h(context, 0.35),
                child: SvgPicture.asset(
                  'assets/svgs/welcome.svg',
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(flex: 2),
              // Get Started button
              SizedBox(
                width: double.infinity,
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.signUp);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 28),
                            ),
                          ),
                        ),
                      ),
                  child: Text(
                    "Let's Get Started",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: AppResponsive.fontSize(context, 16),
                        ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 16)),
              // Sign In link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AppResponsive.fontSize(context, 14),
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to sign in
                      Navigator.pushNamed(context, AppRouter.signIn);
                    },
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontSize: AppResponsive.fontSize(context, 14),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
            ],
          ),
        ),
      ),
    );
  }
}
