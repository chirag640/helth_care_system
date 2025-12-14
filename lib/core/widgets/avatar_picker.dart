import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Avatar picker with edit button
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.onTap,
    this.imageUrl,
  });

  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppResponsive.s(context, 120),
          height: AppResponsive.s(context, 120),
          decoration: BoxDecoration(
            color: AppColors.greyLight.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: imageUrl != null
              ? ClipOval(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: AppResponsive.icon(context, 60),
                  color: AppColors.primary,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: AppResponsive.s(context, 36),
              height: AppResponsive.s(context, 36),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: AppResponsive.thickness(context, 2),
                ),
              ),
              child: Icon(
                Icons.edit,
                size: AppResponsive.icon(context, 18),
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
