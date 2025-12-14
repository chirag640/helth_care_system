import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prescription_card.dart';
import '../../controller/records_controller.dart';
import '../../../../core/routing/app_router.dart';

class RecordsPage extends ConsumerWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsState = ref.watch(recordsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Medical Records',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: AppResponsive.fontSize(context, 18),
              ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppResponsive.p(context, 16)),
              // Search and filter
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Row(
                  children: [
                    Expanded(
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
                            hintText: 'Search Medical Records',
                            hintStyle: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 14),
                              color: AppColors.textTertiary,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: AppResponsive.icon(context, 20),
                              color: AppColors.textTertiary,
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
                    SizedBox(width: AppResponsive.p(context, 12)),
                    Container(
                      width: AppResponsive.s(context, 48),
                      height: AppResponsive.s(context, 48),
                      decoration: BoxDecoration(
                        color: AppColors.filterIconBackground,
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 12),
                        ),
                        border: Border.all(
                          color: AppColors.searchBorder,
                          width: AppResponsive.thickness(context, 1),
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        size: AppResponsive.icon(context, 20),
                        color: AppColors.textPrimary,
                      ),
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
                child: Text(
                  'Latest Prescription',
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
                child: recordsState.latestPrescriptions.isNotEmpty
                    ? PrescriptionCard(
                        data: recordsState.latestPrescriptions.first,
                        isHighlighted: true,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.prescriptionDetail,
                            arguments: recordsState.latestPrescriptions.first,
                          );
                        },
                        onMenuTap: () {},
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Past Prescription section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 16),
                ),
                child: Text(
                  'Past Prescription',
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
                  children: recordsState.pastPrescriptions
                      .map(
                        (prescription) => PrescriptionCard(
                          data: prescription,
                          isHighlighted: false,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.prescriptionDetail,
                              arguments: prescription,
                            );
                          },
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
      bottomNavigationBar: AppBottomNav.create(context, 1),
    );
  }
}
