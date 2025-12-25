import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';
import '../../controller/auth_controller.dart';

class VerifyRegistrationOtpPage extends ConsumerStatefulWidget {
  const VerifyRegistrationOtpPage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyRegistrationOtpPage> createState() =>
      _VerifyRegistrationOtpPageState();
}

class _VerifyRegistrationOtpPageState
    extends ConsumerState<VerifyRegistrationOtpPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _getOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _handleVerify() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyRegistrationOtp(email: widget.email, otp: otp);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.signIn,
        (route) => false,
      );
    }
  }

  Future<void> _handleResend() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .resendRegistrationOtp(widget.email);

    if (success && mounted) {
      _startResendTimer();
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppResponsive.p(context, 40)),
              Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 32),
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 16)),
              Text(
                "We've sent a 6-digit verification code to\n${widget.email}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 14),
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 48)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpField(index)),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.greyLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 28),
                      ),
                    ),
                  ),
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Verify',
                          style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 16))),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive code? ",
                      style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 14))),
                  if (_canResend)
                    GestureDetector(
                      onTap: authState.isLoading ? null : _handleResend,
                      child: Text('Resend',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 14),
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  else
                    Text('Resend in ${_resendCountdown}s',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 14),
                          color: AppColors.grey,
                        )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: AppResponsive.s(context, 50),
      height: AppResponsive.s(context, 56),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 12)),
          border: Border.all(
            color: _focusNodes[index].hasFocus
                ? AppColors.primary
                : AppColors.inputBorder,
            width: AppResponsive.thickness(context, 1.5),
          ),
        ),
        child: TextFormField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: AppResponsive.fontSize(context, 24),
                fontWeight: FontWeight.w600,
              ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counter: Offstage(),
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
