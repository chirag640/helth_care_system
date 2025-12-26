import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../models/models.dart';

/// Prescription Detail Page - Shows full prescription information
class PrescriptionDetailPage extends StatelessWidget {
  const PrescriptionDetailPage({
    super.key,
    required this.prescription,
  });

  final PrescriptionModel prescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            size: AppResponsive.icon(context, 24),
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Prescription Details',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppResponsive.p(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prescription Header Card
            _buildPrescriptionHeader(context),
            SizedBox(height: AppResponsive.p(context, 24)),

            // Medication Information
            _buildSectionTitle(context, 'Medication'),
            SizedBox(height: AppResponsive.p(context, 12)),
            _buildMedicationCard(context),
            SizedBox(height: AppResponsive.p(context, 24)),

            // Dosage Instructions
            if (prescription.dosageInstructions.isNotEmpty) ...[
              _buildSectionTitle(context, 'Dosage Instructions'),
              SizedBox(height: AppResponsive.p(context, 12)),
              _buildDosageCard(context),
              SizedBox(height: AppResponsive.p(context, 24)),
            ],

            // Prescriber Information
            _buildSectionTitle(context, 'Prescribed By'),
            SizedBox(height: AppResponsive.p(context, 12)),
            _buildPrescriberCard(context),
            SizedBox(height: AppResponsive.p(context, 24)),

            // Dispense Information
            if (prescription.dispenseRequest != null) ...[
              _buildSectionTitle(context, 'Dispense Information'),
              SizedBox(height: AppResponsive.p(context, 12)),
              _buildDispenseCard(context),
              SizedBox(height: AppResponsive.p(context, 24)),
            ],

            // Notes
            if (prescription.notes != null &&
                prescription.notes!.isNotEmpty) ...[
              _buildSectionTitle(context, 'Notes'),
              SizedBox(height: AppResponsive.p(context, 12)),
              _buildNotesCard(context),
              SizedBox(height: AppResponsive.p(context, 24)),
            ],

            // Request Refill Button (if applicable)
            if (prescription.canRequestRefill) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement refill request
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refill request feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Request Refill'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppResponsive.p(context, 16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionHeader(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: _getStatusColor(prescription.status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
        border: Border.all(
          color: _getStatusColor(prescription.status).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  prescription.prescriptionNumber ?? 'Prescription',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: AppResponsive.p(context, 12)),
          _buildInfoRow(
            context,
            Icons.calendar_today,
            'Prescribed',
            prescription.authoredOn != null
                ? dateFormat.format(prescription.authoredOn!)
                : 'N/A',
          ),
          if (prescription.effectivePeriodEnd != null) ...[
            SizedBox(height: AppResponsive.p(context, 8)),
            _buildInfoRow(
              context,
              Icons.event_busy,
              'Valid Until',
              dateFormat.format(prescription.effectivePeriodEnd!),
            ),
          ],
          if (prescription.reasonCode != null) ...[
            SizedBox(height: AppResponsive.p(context, 8)),
            _buildInfoRow(
              context,
              Icons.medical_information,
              'Reason',
              prescription.reasonCode!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 12),
        vertical: AppResponsive.p(context, 6),
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(prescription.status),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
      ),
      child: Text(
        prescription.status.displayName,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 12),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppResponsive.p(context, 12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppResponsive.radius(context, 12)),
                ),
                child: Icon(
                  Icons.medication,
                  size: AppResponsive.icon(context, 24),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription.medicationName,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (prescription.medicationCode != null)
                      Text(
                        'Code: ${prescription.medicationCode}',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (prescription.form != null) ...[
            SizedBox(height: AppResponsive.p(context, 12)),
            _buildDetailChip(context, 'Form', prescription.form!.displayName),
          ],
        ],
      ),
    );
  }

  Widget _buildDosageCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: prescription.dosageInstructions.map((dosage) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dosage.text != null)
                  Text(
                    dosage.text!,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textPrimary,
                    ),
                  ),
                if (dosage.doseQuantityValue != null &&
                    dosage.doseQuantityUnit != null)
                  Text(
                    'Dose: ${dosage.doseQuantityValue} ${dosage.doseQuantityUnit}',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (dosage.route != null)
                  Text(
                    'Route: ${dosage.route}',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrescriberCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppResponsive.s(context, 24),
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              size: AppResponsive.icon(context, 24),
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescription.prescriber?.name ?? 'Unknown Doctor',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (prescription.prescriber?.specialty != null)
                  Text(
                    prescription.prescriber!.specialty!,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDispenseCard(BuildContext context) {
    final dispense = prescription.dispenseRequest!;
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          if (dispense.quantityValue != null)
            _buildDispenseRow(context, 'Quantity',
                '${dispense.quantityValue} ${dispense.quantityUnit ?? 'units'}'),
          if (dispense.numberOfRepeatsAllowed != null)
            _buildDispenseRow(context, 'Refills Allowed',
                '${dispense.numberOfRepeatsAllowed}'),
          if (dispense.expectedSupplyDurationValue != null)
            _buildDispenseRow(context, 'Supply Duration',
                '${dispense.expectedSupplyDurationValue} ${dispense.expectedSupplyDurationUnit ?? 'days'}'),
        ],
      ),
    );
  }

  Widget _buildDispenseRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Text(
        prescription.notes!,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 14),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppResponsive.fontSize(context, 16),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppResponsive.icon(context, 16),
          color: AppColors.textSecondary,
        ),
        SizedBox(width: AppResponsive.p(context, 8)),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChip(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 12),
        vertical: AppResponsive.p(context, 6),
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 12),
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.active:
        return Colors.green;
      case PrescriptionStatus.completed:
        return Colors.blue;
      case PrescriptionStatus.cancelled:
      case PrescriptionStatus.stopped:
        return Colors.red;
      case PrescriptionStatus.onHold:
        return Colors.orange;
      case PrescriptionStatus.draft:
        return Colors.grey;
    }
  }
}
