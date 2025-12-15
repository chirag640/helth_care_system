import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/nav_button.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../../../../core/widgets/skip_button.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/onboarding_screen.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  static const onboardingData = [
    {
      'svg': 'assets/svgs/onboarding1.svg',
      'title': 'Locate Nearby Co-Working Spaces Effortlessly',
      'highlight': 'Nearby Co-Working Spaces',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'svg': 'assets/svgs/onboarding2.svg',
      'title': 'Co-Work Favorites: Save for Later',
      'highlight': 'Co-Work Favorites:',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'svg': 'assets/svgs/onboarding3.svg',
      'title': 'Simplify Workspace Booking Tracking',
      'highlight': 'Workspace Booking Tracking',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    final currentPage = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Page View
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.setPage,
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return OnboardingScreen(
                  svgAsset: data['svg']!,
                  title: data['title']!,
                  description: data['description']!,
                  titleHighlight: data['highlight'],
                );
              },
            ),
            // Skip button
            if (currentPage < onboardingData.length - 1)
              Positioned(
                top: AppResponsive.p(context, 16),
                right: AppResponsive.p(context, 8),
                child: SkipButton(
                  onPressed: () => controller.skip(context),
                ),
              ),
            // Bottom navigation
            Positioned(
              bottom: AppResponsive.p(context, 40),
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    if (currentPage > 0)
                      NavButton(
                        onPressed: controller.previousPage,
                        icon: Icons.arrow_back,
                        isBackButton: true,
                      )
                    else
                      SizedBox(width: AppResponsive.s(context, 56)),
                    // Page indicator
                    PageIndicator(
                      currentPage: currentPage,
                      pageCount: onboardingData.length,
                    ),
                    // Forward button
                    NavButton(
                      onPressed: () => controller.nextPage(context),
                      icon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
