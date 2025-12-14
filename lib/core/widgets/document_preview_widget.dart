import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Document preview widget with scan border overlay
class DocumentPreviewWidget extends StatelessWidget {
  final String? imagePath;
  final bool showBorder;
  final double borderRadius;

  const DocumentPreviewWidget({
    super.key,
    this.imagePath,
    this.showBorder = true,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image or placeholder
        Container(
          width: AppResponsive.w(context, 0.8),
          height: AppResponsive.w(context, 0.8),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, borderRadius),
            ),
            image: imagePath != null
                ? DecorationImage(
                    image: AssetImage(imagePath!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),

        // Scan border overlay
        if (showBorder)
          CustomPaint(
            size: Size(
              AppResponsive.w(context, 0.8),
              AppResponsive.w(context, 0.8),
            ),
            painter: ScanBorderPainter(
              borderColor: AppColors.scanBorder,
              cornerColor: AppColors.scanBorderCorner,
              borderRadius: AppResponsive.radius(context, borderRadius),
              cornerSize: AppResponsive.s(context, 40),
              strokeWidth: AppResponsive.thickness(context, 4),
            ),
          ),
      ],
    );
  }
}

/// Custom painter for scan border with rounded corners
class ScanBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color cornerColor;
  final double borderRadius;
  final double cornerSize;
  final double strokeWidth;

  ScanBorderPainter({
    required this.borderColor,
    required this.cornerColor,
    required this.borderRadius,
    required this.cornerSize,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw corner brackets (4 corners)
    // Top-left
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerSize),
      Offset(rect.left, rect.top + borderRadius),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        rect.left,
        rect.top,
        borderRadius * 2,
        borderRadius * 2,
      ),
      3.14159,
      1.5708,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + borderRadius, rect.top),
      Offset(rect.left + cornerSize, rect.top),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(rect.right - cornerSize, rect.top),
      Offset(rect.right - borderRadius, rect.top),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        rect.right - borderRadius * 2,
        rect.top,
        borderRadius * 2,
        borderRadius * 2,
      ),
      -1.5708,
      1.5708,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top + borderRadius),
      Offset(rect.right, rect.top + cornerSize),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(rect.right, rect.bottom - cornerSize),
      Offset(rect.right, rect.bottom - borderRadius),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        rect.right - borderRadius * 2,
        rect.bottom - borderRadius * 2,
        borderRadius * 2,
        borderRadius * 2,
      ),
      0,
      1.5708,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - borderRadius, rect.bottom),
      Offset(rect.right - cornerSize, rect.bottom),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(rect.left + cornerSize, rect.bottom),
      Offset(rect.left + borderRadius, rect.bottom),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        rect.left,
        rect.bottom - borderRadius * 2,
        borderRadius * 2,
        borderRadius * 2,
      ),
      1.5708,
      1.5708,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom - borderRadius),
      Offset(rect.left, rect.bottom - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
