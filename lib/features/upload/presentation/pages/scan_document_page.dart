import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/document_preview_widget.dart';

/// Scan document page with camera preview and scan controls
class ScanDocumentPage extends StatelessWidget {
  const ScanDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scanOverlay,
        body: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 20),
                vertical: AppResponsive.p(context, 16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: AppResponsive.s(context, 40),
                      height: AppResponsive.s(context, 40),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: AppResponsive.icon(context, 24),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(context, 0.02)),
                  Text(
                    'Scan Document',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppResponsive.fontSize(context, 20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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

            // Bottom controls
            Padding(
              padding: EdgeInsets.only(
                bottom: AppResponsive.p(context, 40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Retake button
                  _ScanButton(
                    icon: Icons.refresh_rounded,
                    onTap: () {
                      // Retake logic
                    },
                  ),
                  SizedBox(width: AppResponsive.w(context, 0.15)),
                  // Confirm button
                  _ScanButton(
                    icon: Icons.check_rounded,
                    isPrimary: true,
                    onTap: () {
                      Navigator.pushNamed(context, '/uploadDetail');
                    },
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

/// Scan action button (retake/confirm)
class _ScanButton extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ScanButton({
    required this.icon,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppResponsive.s(context, 70),
        height: AppResponsive.s(context, 70),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.scanButtonBackground,
          shape: BoxShape.circle,
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.scanButtonBorder,
                  width: AppResponsive.thickness(context, 3),
                ),
        ),
        child: Icon(
          icon,
          color: isPrimary ? AppColors.white : AppColors.textPrimary,
          size: AppResponsive.icon(context, 32),
        ),
      ),
    );
  }
}
