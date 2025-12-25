import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/social_button.dart';
import '../../../../core/routing/app_router.dart';
import '../../controller/auth_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final success = await ref.read(authControllerProvider.notifier).signUp(
          fullName: _nameController.text.trim(),
          email: email,
          password: _passwordController.text,
        );

    if (success && mounted) {
      // Navigate to OTP verification screen
      Navigator.pushNamed(
        context,
        AppRouter.verifyOtp,
        arguments: email,
      );
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppResponsive.p(context, 20)),
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
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                      return 'Password must contain an uppercase letter';
                    }
                    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                      return 'Password must contain a lowercase letter';
                    }
                    if (!RegExp(r'(?=.*\d)|(?=.*\W)').hasMatch(value)) {
                      return 'Password must contain a number or special character';
                    }
                    return null;
                  },
                ),
                // Password strength indicator
                _buildPasswordStrengthIndicator(),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 14)),
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
                    onPressed: authState.isLoading ? null : _handleSignUp,
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
                            'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize:
                                        AppResponsive.fontSize(context, 16)),
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

  Widget _buildPasswordStrengthIndicator() {
    return AnimatedBuilder(
      animation: _passwordController,
      builder: (context, _) {
        final password = _passwordController.text;
        if (password.isEmpty) return const SizedBox.shrink();

        // Calculate strength (0-4)
        int score = 0;
        if (password.length >= 8) score++;
        if (RegExp(r'[A-Z]').hasMatch(password)) score++;
        if (RegExp(r'[a-z]').hasMatch(password)) score++;
        if (RegExp(r'[0-9\W]').hasMatch(password)) score++;

        // Get color and label based on score
        final colors = [
          Colors.red,
          Colors.red,
          Colors.orange,
          Colors.amber,
          Colors.green
        ];
        final labels = ['Too weak', 'Weak', 'Fair', 'Good', 'Strong'];
        final color = colors[score];
        final label = labels[score];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppResponsive.p(context, 8)),
            // Strength bars
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index < score ? color : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: AppResponsive.p(context, 4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 12),
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (score < 4)
                  Text(
                    _getMissingRequirement(password),
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 11),
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _getMissingRequirement(String password) {
    if (password.length < 8) return 'Need ${8 - password.length} more chars';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Add uppercase';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Add lowercase';
    if (!RegExp(r'[0-9\W]').hasMatch(password)) return 'Add number or symbol';
    return '';
  }
}
