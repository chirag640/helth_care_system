import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/category_card.dart';
import '../../../../core/widgets/prescription_card.dart';
import '../../controller/home_controller.dart';
import '../../../records/models/models.dart';
import '../../../profile/controller/profile_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final profileState = ref.watch(profileControllerProvider);

    // Get user name from profile
    final userName = profileState.patient?.fullName ?? 'User';
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        greeting: greeting,
        userName: userName,
        notificationCount: homeState.unreadNotificationCount,
        onProfileTap: () {
          Navigator.of(context).pushNamed(AppRouter.profile);
        },
        onNotificationTap: () {
          Navigator.of(context).pushNamed(AppRouter.notifications);
        },
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppResponsive.p(context, 16)),
                // Banner
                _buildBanner(context),
                SizedBox(height: AppResponsive.p(context, 24)),
                // Categories section
                _buildCategoriesSection(context),
                SizedBox(height: AppResponsive.p(context, 24)),
                // Upcoming Appointments section
                if (homeState.hasUpcomingAppointments) ...[
                  _buildUpcomingAppointments(context, homeState, ref),
                  SizedBox(height: AppResponsive.p(context, 24)),
                ],
                // Latest Prescription section
                _buildPrescriptionSection(context, homeState),
                SizedBox(height: AppResponsive.p(context, 100)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav.create(context, 0),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      height: AppResponsive.h(context, 0.22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        // Use a gradient background instead of missing image asset
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2), // Healthcare blue
            Color(0xFF7BB8F5), // Lighter blue
            Color(0xFF50C9CE), // Teal accent
          ],
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

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildUpcomingAppointments(
      BuildContext context, HomeState state, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Appointments',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 20),
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.appointment);
                },
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
        SizedBox(
          height: AppResponsive.s(context, 120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.p(context, 16),
            ),
            itemCount: state.upcomingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = state.upcomingAppointments[index];
              return _buildAppointmentCard(context, appointment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(BuildContext context, dynamic appointment) {
    final date = appointment.scheduledAt ?? DateTime.now();
    final doctorName = appointment.doctorId ?? 'Doctor';

    return Container(
      width: AppResponsive.s(context, 200),
      margin: EdgeInsets.only(right: AppResponsive.p(context, 12)),
      padding: EdgeInsets.all(AppResponsive.p(context, 12)),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 12),
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppResponsive.icon(context, 16),
                color: AppColors.primary,
              ),
              SizedBox(width: AppResponsive.p(context, 8)),
              Text(
                DateFormat('MMM d, yyyy').format(date),
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.p(context, 8)),
          Text(
            doctorName,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            DateFormat('h:mm a').format(date),
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 12),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionSection(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Prescription',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 20)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.records);
                },
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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
          ),
          child: state.latestPrescriptions.isEmpty
              ? _buildEmptyPrescriptions(context)
              : Column(
                  children: state.latestPrescriptions
                      .asMap()
                      .entries
                      .map(
                        (entry) => PrescriptionCard(
                          data: _convertToPrescriptionData(entry.value),
                          isHighlighted: entry.key == 0,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.prescriptionDetail,
                              arguments: entry.value,
                            );
                          },
                          onMenuTap: () {},
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyPrescriptions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 24)),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: AppResponsive.icon(context, 48),
            color: AppColors.textTertiary,
          ),
          SizedBox(height: AppResponsive.p(context, 12)),
          Text(
            'No prescriptions yet',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Convert PrescriptionModel to PrescriptionData for the card widget
  PrescriptionData _convertToPrescriptionData(PrescriptionModel prescription) {
    final date =
        prescription.authoredOn ?? prescription.createdAt ?? DateTime.now();

    return PrescriptionData(
      date: DateFormat('dd').format(date),
      month: DateFormat('MMM').format(date).toUpperCase(),
      diagnosis: prescription.reasonText ?? prescription.medicationName,
      doctorName: prescription.prescriberName ?? 'Doctor',
      doctorQualification: prescription.form?.displayName ?? '',
      location: prescription.dosageSummary,
      prescriptionId: prescription.prescriptionNumber,
      prescriptionCount: prescription.dosageInstructions.isNotEmpty
          ? prescription.dosageInstructions.length
          : 1,
    );
  }
}
