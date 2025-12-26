import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/social_button.dart';
import '../../../../core/routing/app_router.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../controller/auth_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      // Check if this is a new user who needs to complete setup
      final tokenStorage = TokenStorage.instance;
      final arePermissionsRequested = tokenStorage.arePermissionsRequested();
      final isProfileSetupComplete = tokenStorage.isProfileSetupComplete();

      if (!arePermissionsRequested) {
        // New user - go through permission flow first
        Navigator.pushReplacementNamed(context, AppRouter.locationPermission);
        return;
      }

      if (!isProfileSetupComplete) {
        // Check if profile has required fields
        await ref.read(profileControllerProvider.notifier).loadProfile();
        final profileState = ref.read(profileControllerProvider);

        if (!profileState.isProfileComplete) {
          // Profile incomplete - go to personal info
          Navigator.pushReplacementNamed(
            context,
            AppRouter.profilePersonalInfo,
            arguments: 'initial',
          );
          return;
        }
      }

      // Everything complete - go to home
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Show error snackbar
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 24),
          ),
          child: Form(
            key: _formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppResponsive.p(context, 12)),
                // Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to forgot password
                    },
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
                    onPressed: authState.isLoading ? null : _handleSignIn,
                    style:
                        Theme.of(context).elevatedButtonTheme.style?.copyWith(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppResponsive.radius(context, 28),
                                  ),
                                ),
                              ),
                            ),
                    child: authState.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white),
                            ),
                          )
                        : Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(
          color: AppColors.inputBorder,
          width: AppResponsive.thickness(context, 1.5),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText && _obscurePassword,
        keyboardType: keyboardType,
        validator: validator,
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
