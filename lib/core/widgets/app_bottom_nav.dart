import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';
import '../routing/app_router.dart';

/// Global bottom navigation configuration
class AppBottomNav {
  AppBottomNav._();

  /// Standard bottom nav items (same for all screens)
  static const List<BottomNavItem> items = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      label: 'Records',
    ),
    BottomNavItem(
      icon: Icons.upload_outlined,
      activeIcon: Icons.upload,
      label: 'Upload',
    ),
    BottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Appointments',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  /// Standard navigation handler
  static void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRouter.records);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRouter.upload);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRouter.appointment);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRouter.profile);
        break;
    }
  }

  /// Create bottom nav bar with standard configuration
  static Widget create(BuildContext context, int currentIndex) {
    return CustomBottomNavBar(
      currentIndex: currentIndex,
      onTap: (index) => handleNavigation(context, index),
      items: items,
    );
  }
}
