import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/avatar_picker.dart';
import '../../../../core/routing/app_router.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedGender = '';
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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
              SizedBox(height: AppResponsive.p(context, 24)),
              // Title
              Text(
                'Complete Your Profile',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 28)),
              ),
              SizedBox(height: AppResponsive.p(context, 8)),
              // Description
              Text(
                "Don't worry, only you can see your personal\ndata. No one else will be able to see it.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Avatar picker
              Center(
                child: AvatarPicker(
                  onTap: () {
                    // Handle image picker
                  },
                ),
              ),
              SizedBox(height: AppResponsive.p(context, 32)),
              // Full Name field
              _buildLabel('Full Name'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildTextField(
                controller: _nameController,
                hint: 'Williams John',
              ),
              SizedBox(height: AppResponsive.p(context, 20)),
              // Phone Number field
              _buildLabel('Phone Number'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildPhoneField(),
              SizedBox(height: AppResponsive.p(context, 20)),
              // Gender dropdown
              _buildLabel('Gender'),
              SizedBox(height: AppResponsive.p(context, 8)),
              _buildGenderDropdown(),
              SizedBox(height: AppResponsive.p(context, 40)),
              // Complete Profile button
              SizedBox(
                height: AppResponsive.s(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.locationPermission);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text(
                    'Complete Profile',
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
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
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
      child: Row(
        children: [
          // Country code dropdown
          Padding(
            padding: EdgeInsets.only(left: AppResponsive.p(context, 16)),
            child: DropdownButton<String>(
              value: _selectedCountryCode,
              underline: const SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: AppResponsive.icon(context, 20),
                color: AppColors.textPrimary,
              ),
              items: ['+91', '+1', '+44', '+61']
                  .map((code) => DropdownMenuItem(
                        value: code,
                        child: Text(
                          code,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 14)),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountryCode = value ?? '+91';
                });
              },
            ),
          ),
          Container(
            width: AppResponsive.thickness(context, 1),
            height: AppResponsive.s(context, 24),
            color: AppColors.greyLight,
            margin: EdgeInsets.symmetric(
              horizontal: AppResponsive.p(context, 12),
            ),
          ),
          // Phone number input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
              decoration: InputDecoration(
                hintText: 'Enter Phone Number',
                hintStyle: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppResponsive.p(context, 16),
                ),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 16)),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
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
      child: DropdownButtonFormField<String>(
        initialValue: _selectedGender.isEmpty ? null : _selectedGender,
        decoration: InputDecoration(
          hintText: 'Select',
          hintStyle: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 16),
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: AppResponsive.icon(context, 20),
          color: AppColors.textPrimary,
        ),
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppResponsive.fontSize(context, 14)),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value ?? '';
          });
        },
      ),
    );
  }
}
