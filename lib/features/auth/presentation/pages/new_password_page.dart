import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routing/app_router.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                'New Password',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 32)),
              ),
              SizedBox(height: AppResponsive.p(context, 12)),
              // Description
              Text(
                'Your new password must be different from\npreviously used passwords.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
              // Password field
              _buildLabel('Password'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••••••••',
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              // Confirm Password field
              _buildLabel('Confirm Password'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: '••••••••••••••',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const Spacer(),
              // Create button
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.signIn);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text(
                    'Create New Password',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppResponsive.fontSize(context, 14),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      height: AppResponsive.s(context, 56),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(
          color: AppColors.inputBorder,
          width: AppResponsive.thickness(context, 1.5),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 16),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: AppResponsive.icon(context, 20),
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
