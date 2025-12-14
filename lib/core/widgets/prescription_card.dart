import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Prescription card model
class PrescriptionData {
  final String date;
  final String month;
  final String diagnosis;
  final String doctorName;
  final String doctorQualification;
  final String location;
  final String prescriptionId;
  final int prescriptionCount;

  const PrescriptionData({
    required this.date,
    required this.month,
    required this.diagnosis,
    required this.doctorName,
    required this.doctorQualification,
    required this.location,
    required this.prescriptionId,
    required this.prescriptionCount,
  });
}

/// Prescription card widget
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({
    super.key,
    required this.data,
    this.onTap,
    this.onMenuTap,
    this.isHighlighted = false,
  });

  final PrescriptionData data;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
        padding: EdgeInsets.all(AppResponsive.p(context, 12)),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primary : AppColors.white,
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 16)),
          border: Border.all(
            color: isHighlighted ? AppColors.primary : AppColors.greyLight,
            width: AppResponsive.thickness(context, 1.5),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date box
              Container(
                width: AppResponsive.s(context, 60),
                padding: EdgeInsets.symmetric(
                  vertical: AppResponsive.p(context, 8),
                ),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? AppColors.white.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.date,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 24),
                        fontWeight: FontWeight.bold,
                        color:
                            isHighlighted ? AppColors.white : AppColors.primary,
                      ),
                    ),
                    Text(
                      data.month,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                        color:
                            isHighlighted ? AppColors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.p(context, 10)),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Diagnosis
                    Text(
                      'Diagnosis : ${data.diagnosis}',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 14),
                        fontWeight: FontWeight.w600,
                        color: isHighlighted
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppResponsive.p(context, 6)),
                    // Doctor info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: AppResponsive.s(context, 12),
                          backgroundColor: isHighlighted
                              ? AppColors.white.withValues(alpha: 0.2)
                              : AppColors.greyLight,
                          child: Icon(
                            Icons.person,
                            size: AppResponsive.icon(context, 14),
                            color: isHighlighted
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: AppResponsive.p(context, 8)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.doctorName,
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 14),
                                  fontWeight: FontWeight.w600,
                                  color: isHighlighted
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                data.doctorQualification,
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 11),
                                  color: isHighlighted
                                      ? AppColors.white.withValues(alpha: 0.8)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppResponsive.p(context, 6)),
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppResponsive.icon(context, 14),
                          color: isHighlighted
                              ? AppColors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: AppResponsive.p(context, 4)),
                        Expanded(
                          child: Text(
                            data.location,
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 12),
                              color: isHighlighted
                                  ? AppColors.white.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppResponsive.p(context, 8)),
                    // Footer
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.p(context, 10),
                            vertical: AppResponsive.p(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: isHighlighted
                                ? AppColors.white.withValues(alpha: 0.2)
                                : AppColors.greyLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 8),
                            ),
                          ),
                          child: Text(
                            data.prescriptionId,
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 11),
                              fontWeight: FontWeight.w600,
                              color: isHighlighted
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.p(context, 10),
                              vertical: AppResponsive.p(context, 4),
                            ),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? AppColors.white
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppResponsive.radius(context, 8),
                              ),
                            ),
                            child: Text(
                              '${data.prescriptionCount} Prescription',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 10),
                                fontWeight: FontWeight.w600,
                                color: isHighlighted
                                    ? AppColors.primary
                                    : AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu icon
              IconButton(
                onPressed: onMenuTap,
                icon: Icon(
                  Icons.more_vert,
                  size: AppResponsive.icon(context, 18),
                  color:
                      isHighlighted ? AppColors.white : AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
