import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../../features/appointment/models/appointment_model.dart';

/// Appointment card model (legacy - for backwards compatibility)
class AppointmentData {
  final String doctorName;
  final String specialty;
  final String timeRange;
  final String day;
  final String date;
  final String appointmentType;
  final String location;
  final bool isVerified;
  final bool isUpcoming;

  const AppointmentData({
    required this.doctorName,
    required this.specialty,
    required this.timeRange,
    required this.day,
    required this.date,
    required this.appointmentType,
    required this.location,
    this.isVerified = false,
    this.isUpcoming = false,
  });

  /// Create from AppointmentModel
  factory AppointmentData.fromModel(AppointmentModel model) {
    final timeFormat = DateFormat('h:mm a');
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('d MMMM');

    return AppointmentData(
      doctorName: model.doctor?.name ?? 'Unknown Doctor',
      specialty: model.doctor?.specialty ?? 'General Practitioner',
      timeRange:
          '${timeFormat.format(model.scheduledAt)} - ${timeFormat.format(model.endTime)}',
      day: dayFormat.format(model.scheduledAt),
      date: dateFormat.format(model.scheduledAt),
      appointmentType: model.reasonForVisit ?? model.type.displayName,
      location: model.hospital?.fullAddress ?? 'Location not specified',
      isVerified: model.doctor?.isVerified ?? false,
      isUpcoming: model.isUpcoming,
    );
  }
}

/// Appointment card widget - now supports both AppointmentData and AppointmentModel
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    this.data,
    this.appointment,
    this.onTap,
    this.showExternalLink = false,
  }) : assert(data != null || appointment != null,
            'Either data or appointment must be provided');

  final AppointmentData? data;
  final AppointmentModel? appointment;
  final VoidCallback? onTap;
  final bool showExternalLink;

  AppointmentData get _displayData =>
      data ?? AppointmentData.fromModel(appointment!);

  @override
  Widget build(BuildContext context) {
    final displayData = _displayData;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
        padding: EdgeInsets.all(AppResponsive.p(context, 12)),
        decoration: BoxDecoration(
          color: displayData.isUpcoming
              ? AppColors.appointmentCardBackground
              : AppColors.white,
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 16)),
          border: Border.all(
            color: displayData.isUpcoming
                ? Colors.transparent
                : AppColors.greyLight,
            width: AppResponsive.thickness(context, 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Doctor avatar
                CircleAvatar(
                  radius: AppResponsive.s(context, 24),
                  backgroundColor: AppColors.greyLight,
                  backgroundImage:
                      const AssetImage('assets/images/doctor_avatar.png'),
                ),
                SizedBox(width: AppResponsive.p(context, 10)),
                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayData.doctorName,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 15),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (displayData.isVerified) ...[
                            SizedBox(width: AppResponsive.p(context, 4)),
                            Icon(
                              Icons.verified,
                              size: AppResponsive.icon(context, 16),
                              color: AppColors.verifiedBadge,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: AppResponsive.p(context, 2)),
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            size: AppResponsive.icon(context, 12),
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppResponsive.p(context, 4)),
                          Flexible(
                            child: Text(
                              displayData.specialty,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 12),
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showExternalLink)
                  Icon(
                    Icons.open_in_new,
                    size: AppResponsive.icon(context, 20),
                    color: AppColors.externalLinkIcon,
                  ),
              ],
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            // Time and date
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.p(context, 10),
                      vertical: AppResponsive.p(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: displayData.isUpcoming
                          ? AppColors.appointmentTimeBackground
                          : AppColors.appointmentTimeBackground,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: AppResponsive.icon(context, 14),
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppResponsive.p(context, 4)),
                        Flexible(
                          child: Text(
                            displayData.timeRange,
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppResponsive.p(context, 8)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.p(context, 10),
                      vertical: AppResponsive.p(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: displayData.isUpcoming
                          ? AppColors.appointmentTimeBackground
                          : AppColors.appointmentTimeBackground,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppResponsive.icon(context, 14),
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppResponsive.p(context, 4)),
                        Flexible(
                          child: Text(
                            '${displayData.day}, ${displayData.date}',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            // Appointment type badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 12),
                vertical: AppResponsive.p(context, 6),
              ),
              decoration: BoxDecoration(
                color: displayData.isUpcoming
                    ? AppColors.appointmentBadgeBackground
                    : AppColors.appointmentTimeBackground,
                borderRadius:
                    BorderRadius.circular(AppResponsive.radius(context, 8)),
              ),
              child: Text(
                displayData.appointmentType,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 8)),
            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: AppResponsive.icon(context, 14),
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppResponsive.p(context, 4)),
                Expanded(
                  child: Text(
                    displayData.location,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 12),
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
