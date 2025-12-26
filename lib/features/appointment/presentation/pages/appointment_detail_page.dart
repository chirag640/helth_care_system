import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/prescription_file_card.dart';
import '../../../../core/widgets/category_pill.dart';
import '../../models/appointment_model.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final files = _getDummyFiles();

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
          appointment.type.displayName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppResponsive.p(context, 16)),
            // Appointment info card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: _buildAppointmentInfoCard(context),
            ),
            SizedBox(height: AppResponsive.p(context, 16)),
            // Appointment details
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: _buildAppointmentDetails(context),
            ),
            SizedBox(height: AppResponsive.p(context, 16)),
            // Category pills
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: Wrap(
                spacing: AppResponsive.p(context, 8),
                runSpacing: AppResponsive.p(context, 8),
                children: const [
                  CategoryPill(
                    icon: Icons.description_outlined,
                    label: 'Prescriptions',
                    isActive: true,
                  ),
                  CategoryPill(
                    icon: Icons.science_outlined,
                    label: 'Lab Tests',
                  ),
                  CategoryPill(
                    icon: Icons.medication_outlined,
                    label: 'Medications',
                  ),
                  CategoryPill(
                    icon: Icons.more_horiz,
                    label: 'Others',
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
            // Files grid
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: Column(
                children: files
                    .map(
                      (file) => PrescriptionFileCard(
                        data: file,
                        onTap: () {},
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentInfoCard(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');

    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.appointmentCardBackground,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppResponsive.s(context, 28),
                backgroundColor: AppColors.white,
                child: Icon(
                  Icons.person,
                  size: AppResponsive.icon(context, 28),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            appointment.doctor?.name ?? 'Unknown Doctor',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 16),
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (appointment.doctor?.isVerified ?? false) ...[
                          SizedBox(width: AppResponsive.p(context, 4)),
                          Icon(
                            Icons.verified,
                            size: AppResponsive.icon(context, 16),
                            color: AppColors.verifiedBadge,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: AppResponsive.p(context, 4)),
                    Text(
                      appointment.doctor?.specialty ?? 'General Practitioner',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 13),
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.p(context, 16)),
          Divider(color: AppColors.white.withValues(alpha: 0.3), height: 1),
          SizedBox(height: AppResponsive.p(context, 16)),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppResponsive.icon(context, 16),
                color: AppColors.white,
              ),
              SizedBox(width: AppResponsive.p(context, 8)),
              Expanded(
                child: Text(
                  dateFormat.format(appointment.scheduledAt),
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 13),
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.p(context, 8)),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: AppResponsive.icon(context, 16),
                color: AppColors.white,
              ),
              SizedBox(width: AppResponsive.p(context, 8)),
              Text(
                '${timeFormat.format(appointment.scheduledAt)} - ${timeFormat.format(appointment.endTime)}',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 13),
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.p(context, 8)),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: AppResponsive.icon(context, 16),
                color: AppColors.white,
              ),
              SizedBox(width: AppResponsive.p(context, 8)),
              Expanded(
                child: Text(
                  appointment.hospital?.name ?? 'Location not specified',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 13),
                    color: AppColors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Details',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppResponsive.p(context, 12)),
          _buildDetailRow(context, 'Status', appointment.status.displayName),
          _buildDetailRow(context, 'Type', appointment.type.displayName),
          if (appointment.reasonForVisit != null)
            _buildDetailRow(context, 'Reason', appointment.reasonForVisit!),
          if (appointment.symptoms != null && appointment.symptoms!.isNotEmpty)
            _buildDetailRow(
                context, 'Symptoms', appointment.symptoms!.join(', ')),
          if (appointment.notes != null)
            _buildDetailRow(context, 'Notes', appointment.notes!),
          _buildDetailRow(
              context, 'Duration', '${appointment.duration} minutes'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppResponsive.s(context, 100),
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PrescriptionFileData> _getDummyFiles() {
    return [
      const PrescriptionFileData(
        fileName: 'Fiver and cold.pdf',
        thumbnailPath: 'assets/images/prescription_thumb.png',
        hospitalName: 'MMPJ HOSPITAL (Leva Patel Hospital)-Bhuj 370105',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: '(M.B.B.S)',
        date: '11/12/2024',
        time: '11:20:30 AM',
      ),
      const PrescriptionFileData(
        fileName: 'Fiver and cold.pdf',
        thumbnailPath: 'assets/images/prescription_thumb.png',
        hospitalName: 'MMPJ HOSPITAL (Leva Patel Hospital)-Bhuj 370105',
        doctorName: 'Dr. Mahek Mahta',
        doctorQualification: '(M.B.B.S)',
        date: '11/12/2024',
        time: '11:20:30 AM',
      ),
    ];
  }
}
