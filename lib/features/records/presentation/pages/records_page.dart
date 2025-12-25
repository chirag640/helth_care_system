import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/prescription_card.dart';
import '../../../../core/routing/app_router.dart';
import '../../controller/records_controller.dart';
import '../../models/models.dart';

class RecordsPage extends ConsumerStatefulWidget {
  const RecordsPage({super.key});

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: _buildContent(recordsState),
      ),
      bottomNavigationBar: AppBottomNav.create(context, 1),
    );
  }

  Widget _buildContent(RecordsState state) {
    // Show loading state
    if (state.isLoading && state.prescriptions.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    // Show error state
    if (state.error != null && state.prescriptions.isEmpty) {
      return Center(
        child: ErrorDisplay(
          message: state.error!,
          onRetry: () => ref
              .read(recordsControllerProvider.notifier)
              .refreshPrescriptions(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(recordsControllerProvider.notifier).refreshPrescriptions(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppResponsive.p(context, 16)),
            // Search and filter
            _buildSearchBar(state),
            SizedBox(height: AppResponsive.p(context, 24)),

            // Show empty state if no prescriptions
            if (state.prescriptions.isEmpty) ...[
              _buildEmptyState(),
            ] else ...[
              // Active/Latest Prescription section
              if (state.activePrescriptions.isNotEmpty) ...[
                _buildSectionHeader('Active Prescriptions'),
                SizedBox(height: AppResponsive.p(context, 12)),
                _buildLatestPrescription(state.activePrescriptions.first),
                if (state.activePrescriptions.length > 1) ...[
                  SizedBox(height: AppResponsive.p(context, 8)),
                  _buildActivePrescriptionsList(
                    state.activePrescriptions.skip(1).toList(),
                  ),
                ],
                SizedBox(height: AppResponsive.p(context, 24)),
              ],

              // Needs Refill section
              if (state.needsRefillPrescriptions.isNotEmpty) ...[
                _buildRefillSection(state.needsRefillPrescriptions),
                SizedBox(height: AppResponsive.p(context, 24)),
              ],

              // Past Prescription section
              if (state.pastPrescriptions.isNotEmpty) ...[
                _buildSectionHeader('Past Prescriptions'),
                SizedBox(height: AppResponsive.p(context, 12)),
                _buildPastPrescriptionsList(state.pastPrescriptions),
              ],
            ],

            SizedBox(height: AppResponsive.p(context, 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(RecordsState state) {
    return Padding(
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
                controller: _searchController,
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
                  suffixIcon: state.searchQuery != null
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            size: AppResponsive.icon(context, 18),
                            color: AppColors.textTertiary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(recordsControllerProvider.notifier)
                                .clearSearch();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.p(context, 16),
                    vertical: AppResponsive.p(context, 12),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    ref
                        .read(recordsControllerProvider.notifier)
                        .searchPrescriptions(value);
                  }
                },
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.p(context, 32)),
        child: const EmptyState(
          icon: Icons.medical_services_outlined,
          title: 'No prescriptions yet',
          message: 'Your prescriptions will appear here',
        ),
      ),
    );
  }

  Widget _buildLatestPrescription(PrescriptionModel prescription) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      child: PrescriptionCard(
        data: _convertToPrescriptionData(prescription),
        isHighlighted: true,
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.prescriptionDetail,
            arguments: prescription,
          );
        },
        onMenuTap: () => _showPrescriptionMenu(prescription),
      ),
    );
  }

  Widget _buildActivePrescriptionsList(List<PrescriptionModel> prescriptions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      child: Column(
        children: prescriptions
            .map(
              (prescription) => PrescriptionCard(
                data: _convertToPrescriptionData(prescription),
                isHighlighted: false,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.prescriptionDetail,
                    arguments: prescription,
                  );
                },
                onMenuTap: () => _showPrescriptionMenu(prescription),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRefillSection(List<PrescriptionModel> prescriptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.refresh,
                size: AppResponsive.icon(context, 20),
                color: AppColors.warning,
              ),
              SizedBox(width: AppResponsive.p(context, 8)),
              Text(
                'Needs Refill',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 18),
                      color: AppColors.warning,
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
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return _buildRefillCard(prescription);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRefillCard(PrescriptionModel prescription) {
    return Container(
      width: AppResponsive.s(context, 200),
      margin: EdgeInsets.only(right: AppResponsive.p(context, 12)),
      padding: EdgeInsets.all(AppResponsive.p(context, 12)),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 12),
        ),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prescription.medicationWithStrength,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppResponsive.p(context, 4)),
          Text(
            '${prescription.refillsRemaining} refills remaining',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 12),
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final success = await ref
                    .read(recordsControllerProvider.notifier)
                    .requestRefill(prescription.id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refill requested!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                padding: EdgeInsets.symmetric(
                  vertical: AppResponsive.p(context, 8),
                ),
              ),
              child: Text(
                'Request Refill',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastPrescriptionsList(List<PrescriptionModel> prescriptions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
      ),
      child: Column(
        children: prescriptions
            .map(
              (prescription) => PrescriptionCard(
                data: _convertToPrescriptionData(prescription),
                isHighlighted: false,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.prescriptionDetail,
                    arguments: prescription,
                  );
                },
                onMenuTap: () => _showPrescriptionMenu(prescription),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showPrescriptionMenu(PrescriptionModel prescription) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.radius(context, 20)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppResponsive.p(context, 20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  AppRouter.prescriptionDetail,
                  arguments: prescription,
                );
              },
            ),
            if (prescription.canRefill)
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Request Refill'),
                onTap: () async {
                  Navigator.pop(context);
                  final success = await ref
                      .read(recordsControllerProvider.notifier)
                      .requestRefill(prescription.id);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refill requested!')),
                    );
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download PDF'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement download
              },
            ),
          ],
        ),
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
      prescriptionCount: prescription.dosageInstructions.length > 0
          ? prescription.dosageInstructions.length
          : 1,
    );
  }
}
