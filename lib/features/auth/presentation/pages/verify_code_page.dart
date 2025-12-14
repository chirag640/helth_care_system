import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/otp_input_field.dart';
import '../../../../core/routing/app_router.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppResponsive.p(context, 24)),
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: AppResponsive.s(context, 44),
                    height: AppResponsive.s(context, 44),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.greyLight,
                        width: AppResponsive.thickness(context, 1),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: AppResponsive.icon(context, 20),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
              // Title
              Text(
                'Verify Code',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 32)),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Description
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 14),
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  children: const [
                    TextSpan(
                        text: 'Please enter the code we just sent to email\n'),
                    TextSpan(
                      text: 'example@email.com',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
              // OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.p(context, 8),
                    ),
                    child: OtpInputField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Resend code
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 14)),
                    children: [
                      const TextSpan(text: "Didn't receive OTP?\n"),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Resend code',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 14),
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              // Verify button
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: _controllers.every((c) => c.text.isNotEmpty)
                      ? () {
                          Navigator.pushNamed(
                              context, AppRouter.completeProfile);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.greyLight,
                    disabledForegroundColor: AppColors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 28),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Verify',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 16)),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
            ],
          ),
        ),
      ),
    );
  }
}
