import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../controller/appointment_controller.dart';
import '../../../../core/routing/app_router.dart';

class AppointmentPage extends ConsumerWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(appointmentControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Appointment',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppResponsive.p(context, 16)),
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Container(
                  height: AppResponsive.s(context, 48),
                  decoration: BoxDecoration(
                    color: AppColors.searchBackground,
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 12),
                    ),
                    border: Border.all(
                      color: AppColors.searchBorder,
                      width: AppResponsive.thickness(context, 1),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Appointment...',
                      hintStyle: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 14),
                        color: AppColors.textTertiary,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        size: AppResponsive.icon(context, 20),
                        color: AppColors.textPrimary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.p(context, 16),
                        vertical: AppResponsive.p(context, 12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Upcoming Appointment section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Text(
                  'Upcoming Appointment',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: appointmentState.upcomingAppointments.isNotEmpty
                    ? AppointmentCard(
                        data: appointmentState.upcomingAppointments.first,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.appointmentDetail,
                            arguments:
                                appointmentState.upcomingAppointments.first,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Previous Appointment section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Text(
                  'Previous Appointment',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Column(
                  children: appointmentState.previousAppointments
                      .map(
                        (appointment) => AppointmentCard(
                          data: appointment,
                          showExternalLink: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.appointmentDetail,
                              arguments: appointment,
                            );
                          },
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
      bottomNavigationBar: AppBottomNav.create(context, 3),
    );
  }
}
