import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Prescription file card model
class PrescriptionFileData {
  final String fileName;
  final String thumbnailPath;
  final String hospitalName;
  final String doctorName;
  final String doctorQualification;
  final String date;
  final String time;

  const PrescriptionFileData({
    required this.fileName,
    required this.thumbnailPath,
    required this.hospitalName,
    required this.doctorName,
    required this.doctorQualification,
    required this.date,
    required this.time,
  });
}

/// Prescription file card widget (used in Dengue detail page)
class PrescriptionFileCard extends StatelessWidget {
  const PrescriptionFileCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final PrescriptionFileData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: AppResponsive.s(context, 8),
              offset: Offset(0, AppResponsive.s(context, 2)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: AppResponsive.h(context, 0.25),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppResponsive.radius(context, 12)),
                  topRight: Radius.circular(AppResponsive.radius(context, 12)),
                ),
                image: DecorationImage(
                  image: AssetImage(data.thumbnailPath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.prescriptionFileOverlay,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(AppResponsive.radius(context, 12)),
                        topRight:
                            Radius.circular(AppResponsive.radius(context, 12)),
                      ),
                    ),
                  ),
                  // File name
                  Positioned(
                    left: AppResponsive.p(context, 12),
                    bottom: AppResponsive.p(context, 12),
                    child: Text(
                      data.fileName,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Padding(
              padding: EdgeInsets.all(AppResponsive.p(context, 12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.hospitalName,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppResponsive.p(context, 6)),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppResponsive.s(context, 10),
                        backgroundColor: AppColors.greyLight,
                        child: Icon(
                          Icons.person,
                          size: AppResponsive.icon(context, 12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: AppResponsive.p(context, 6)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.doctorName,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              data.doctorQualification,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 10),
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 8)),
                  Text(
                    '$data.date $data.time',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
