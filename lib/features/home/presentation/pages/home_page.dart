import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helth_care_system/core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/category_card.dart';
import '../../../../core/widgets/prescription_card.dart';
import '../../controller/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        greeting: 'Hello, Good Morning!',
        userName: 'John D. Wick',
        notificationCount: 3,
        onProfileTap: () {},
        onNotificationTap: () {
          Navigator.of(context).pushNamed(AppRouter.notifications);
        },
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppResponsive.p(context, 16)),
              // Banner
              _buildBanner(context),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Categories section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: AppResponsive.fontSize(context, 20),
                          ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: AppResponsive.fontSize(context, 14),
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Categories grid
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppResponsive.p(context, 12),
                  crossAxisSpacing: AppResponsive.p(context, 12),
                  childAspectRatio: 0.85,
                  children: [
                    CategoryCard(
                      icon: Icons.medical_services_outlined,
                      label: 'Allergies',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.medication_outlined,
                      label: 'Medications',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.thermostat_outlined,
                      label: 'Symptoms',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.science_outlined,
                      label: 'Lab Tests',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.biotech_outlined,
                      label: 'DNA Tests',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.monitor_heart_outlined,
                      label: 'Diagnoses',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.family_restroom_outlined,
                      label: 'Family',
                      onTap: () {},
                    ),
                    CategoryCard(
                      icon: Icons.more_horiz,
                      label: 'More',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Latest Prescription section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Prescription',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: AppResponsive.fontSize(context, 20)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Prescriptions list
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Column(
                  children: homeState.prescriptions
                      .asMap()
                      .entries
                      .map(
                        (entry) => PrescriptionCard(
                          data: entry.value,
                          isHighlighted: entry.key == 0,
                          onTap: () {},
                          onMenuTap: () {},
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 100)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav.create(context, 0),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      height: AppResponsive.h(context, 0.22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        image: const DecorationImage(
          image: AssetImage('assets/images/home_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 20),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Social icons
          Positioned(
            top: AppResponsive.p(context, 20),
            right: AppResponsive.p(context, 20),
            child: Column(
              children: [
                _buildSocialIcon(context, Icons.favorite, AppColors.error),
                SizedBox(height: AppResponsive.p(context, 8)),
                _buildSocialIcon(context, Icons.shopping_bag, AppColors.white),
                SizedBox(height: AppResponsive.p(context, 8)),
                _buildSocialIcon(context, Icons.email, AppColors.white),
                SizedBox(height: AppResponsive.p(context, 8)),
                _buildSocialIcon(context, Icons.chat_bubble, AppColors.primary),
                SizedBox(height: AppResponsive.p(context, 8)),
                _buildSocialIcon(context, Icons.location_on, AppColors.white),
                SizedBox(height: AppResponsive.p(context, 8)),
                _buildSocialIcon(context, Icons.person, AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      width: AppResponsive.s(context, 32),
      height: AppResponsive.s(context, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: AppResponsive.s(context, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: AppResponsive.icon(context, 18),
        color: color,
      ),
    );
  }
}
