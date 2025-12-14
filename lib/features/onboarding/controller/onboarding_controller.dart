import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/app_router.dart';

/// Onboarding state
class OnboardingState {
  final int currentPage;
  final PageController pageController;

  OnboardingState({
    required this.currentPage,
    required this.pageController,
  });

  OnboardingState copyWith({
    int? currentPage,
    PageController? pageController,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
    );
  }
}

/// Onboarding controller
class OnboardingController extends StateNotifier<int> {
  OnboardingController() : super(0) {
    _pageController = PageController(initialPage: 0);
  }

  late PageController _pageController;
  PageController get pageController => _pageController;

  final int _totalPages = 3;

  void setPage(int page) {
    state = page;
  }

  void nextPage(BuildContext context) {
    if (state < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.welcome);
    }
  }

  void previousPage() {
    if (state > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRouter.welcome);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// Onboarding controller provider
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, int>((ref) {
  return OnboardingController();
});
