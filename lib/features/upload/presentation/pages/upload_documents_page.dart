import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/document_preview_widget.dart';

/// Upload documents page with camera/gallery options
class UploadDocumentsPage extends StatelessWidget {
  const UploadDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.p(context, 20),
                    vertical: AppResponsive.p(context, 16),
                  ),
                  child: Text(
                    'Upload Documents',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppResponsive.fontSize(context, 20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.p(context, 24),
                      ),
                      child: const DocumentPreviewWidget(
                        showBorder: true,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppResponsive.h(context, 0.03)),

                // Upload from gallery button
                GestureDetector(
                  onTap: () async {
                    try {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 85,
                      );
                      if (image != null && context.mounted) {
                        // Navigate with selected image path
                        Navigator.pushNamed(
                          context,
                          '/uploadDetail',
                          arguments: image.path,
                        );
                      }
                    } catch (e) {
                      // Handle error (permission denied, etc.)
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to pick image from gallery'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.p(context, 32),
                      vertical: AppResponsive.p(context, 14),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 24),
                      ),
                      border: Border.all(
                        color: AppColors.greyLight,
                        width: AppResponsive.thickness(context, 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Upload From Gallery',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppResponsive.fontSize(context, 16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: AppResponsive.w(context, 0.02)),
                        Icon(
                          Icons.upload_rounded,
                          color: AppColors.textPrimary,
                          size: AppResponsive.icon(context, 20),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Camera button - Opens real-time scanner
                GestureDetector(
                  onTap: () async {
                    try {
                      final ImagePicker picker = ImagePicker();
                      final XFile? photo = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 85,
                      );
                      if (photo != null && context.mounted) {
                        // Navigate with captured photo path
                        Navigator.pushNamed(
                          context,
                          '/uploadDetail',
                          arguments: photo.path,
                        );
                      }
                    } catch (e) {
                      // Handle error (permission denied, camera not available, etc.)
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to open camera'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: AppResponsive.s(context, 80),
                    height: AppResponsive.s(context, 80),
                    margin: EdgeInsets.only(
                      bottom: AppResponsive.p(context, 20),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: AppResponsive.thickness(context, 3),
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.textPrimary,
                      size: AppResponsive.icon(context, 36),
                    ),
                  ),
                ),

                SizedBox(height: AppResponsive.h(context, 0.01)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav.create(context, 2),
    );
  }
}
