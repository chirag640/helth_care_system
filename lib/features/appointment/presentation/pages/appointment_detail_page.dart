import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/prescription_file_card.dart';
import '../../../../core/widgets/category_pill.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  final AppointmentData appointment;

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
          appointment.appointmentType,
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
            // Appointment card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: AppointmentCard(
                data: appointment,
                onTap: () {},
              ),
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
