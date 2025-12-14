import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/social_button.dart';
import '../../../../core/routing/app_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppResponsive.p(context, 60)),
              // Title
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 32),
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 8)),
              // Subtitle
              Text(
                'Fill your information below or register\nwith your social account.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 14),
                      height: 1.5,
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Full Name field
              _buildLabel('Full Name'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter your Full Name',
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              // Email field
              _buildLabel('Email'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _emailController,
                hint: 'email123@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              // Password field
              _buildLabel('Password'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••••••••',
                obscureText: true,
                suffixIcon: Icons.visibility_off_outlined,
              ),
              SizedBox(height: AppResponsive.p(context, 16)),
              // Terms checkbox
              Row(
                children: [
                  SizedBox(
                    width: AppResponsive.s(context, 24),
                    height: AppResponsive.s(context, 24),
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.p(context, 8)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppResponsive.fontSize(context, 14)),
                        children: [
                          const TextSpan(text: 'Agree with '),
                          TextSpan(
                            text: 'Terms & Condition',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.p(context, 24)),
              // Sign Up button
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: _agreeToTerms
                      ? () {
                          Navigator.pushNamed(context, AppRouter.verifyCode);
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
                    'Sign Up',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 16)),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Divider with text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.greyLight,
                      thickness: AppResponsive.thickness(context, 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.p(context, 16),
                    ),
                    child: Text(
                      'Or sign up with',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AppResponsive.fontSize(context, 14)),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.greyLight,
                      thickness: AppResponsive.thickness(context, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Social buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    onPressed: () {},
                    icon: Icons.apple,
                  ),
                  SizedBox(width: AppResponsive.p(context, 16)),
                  SocialButton(
                    onPressed: () {},
                    icon: Icons.g_mobiledata,
                  ),
                  SizedBox(width: AppResponsive.p(context, 16)),
                  SocialButton(
                    onPressed: () {},
                    icon: Icons.facebook,
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 14)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.signIn);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 14),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
    bool obscureText = false,
    TextInputType? keyboardType,
    IconData? suffixIcon,
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
        obscureText: obscureText && _obscurePassword,
        keyboardType: keyboardType,
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
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: AppResponsive.icon(context, 20),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
