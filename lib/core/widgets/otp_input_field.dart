import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// OTP input field
class OtpInputField extends StatelessWidget {
  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppResponsive.s(context, 64),
      height: AppResponsive.s(context, 64),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(
          color:
              controller.text.isEmpty ? AppColors.greyLight : AppColors.primary,
          width: AppResponsive.thickness(context, 2),
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 24),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
