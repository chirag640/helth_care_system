import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/social_button.dart';
import '../../../../core/routing/app_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
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
                'Sign In',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 32),
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 8)),
              // Subtitle
              Text(
                "Hi! Welcome back, you've been missed",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: AppResponsive.p(context, 40)),
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
              SizedBox(height: AppResponsive.p(context, 12)),
              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Sign In button
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 28),
                            ),
                          ),
                        ),
                      ),
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: AppResponsive.fontSize(context, 16),
                        ),
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
                      'Or sign in with',
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
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 14)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.signUp);
                    },
                    child: Text(
                      'Sign Up',
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
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: AppResponsive.fontSize(context, 14),
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
