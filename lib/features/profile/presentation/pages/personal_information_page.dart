import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/profile_controller.dart';
import '../../models/patient_model.dart';

/// Personal Information Edit Page - Connected to real profile data
class PersonalInformationPage extends ConsumerStatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  ConsumerState<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState
    extends ConsumerState<PersonalInformationPage> {
  final _formKey = GlobalKey<FormState>();

  // Changed from firstName/lastName to fullName to match backend
  late TextEditingController _fullNameController;
  // Changed from phoneNumber to phone to match backend
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationController;

  Gender? _selectedGender;
  BloodGroup? _selectedBloodGroup;
  DateTime? _selectedDateOfBirth;
  // Note: height and weight are NOT supported by backend UpdatePatientDto
  // They can be stored locally but won't be sent to server

  bool _isInitialized = false;
  bool _isInitialSetup = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if this is initial profile setup (coming from permission flow)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'initial') {
      _isInitialSetup = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  void _initializeFromPatient(PatientModel? patient) {
    if (_isInitialized || patient == null) return;

    // Backend uses fullName, not firstName/lastName
    _fullNameController.text = patient.fullName ?? '';
    // Backend uses phone, not phoneNumber
    _phoneController.text = patient.phone ?? '';
    _emailController.text = patient.email;
    _streetController.text = patient.address?.street ?? '';
    _cityController.text = patient.address?.city ?? '';
    _stateController.text = patient.address?.state ?? '';
    _zipCodeController.text = patient.address?.zipCode ?? '';
    _emergencyNameController.text = patient.emergencyContact?.name ?? '';
    _emergencyPhoneController.text =
        patient.emergencyContact?.phoneNumber ?? '';
    _emergencyRelationController.text =
        patient.emergencyContact?.relationship ?? '';

    _selectedGender = patient.gender;
    _selectedBloodGroup = patient.bloodGroup;
    _selectedDateOfBirth = patient.dateOfBirth;

    _isInitialized = true;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Get the raw phone number (10 digits) for backend validation
    String? phoneValue = _phoneController.text.isNotEmpty
        ? _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')
        : null;

    // Backend phone validation: /^[6-9]\d{9}$/ (Indian phone format)
    // Only send if it matches the pattern or is empty
    if (phoneValue != null &&
        phoneValue.isNotEmpty &&
        !RegExp(r'^[6-9]\d{9}$').hasMatch(phoneValue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Phone number must be a valid 10-digit Indian number starting with 6-9'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success =
        await ref.read(profileControllerProvider.notifier).updateProfile(
              UpdatePatientRequest(
                // Backend uses fullName, NOT firstName/lastName
                fullName: _fullNameController.text.isNotEmpty
                    ? _fullNameController.text
                    : null,
                // Backend uses phone, NOT phoneNumber
                phone: phoneValue,
                dateOfBirth: _selectedDateOfBirth,
                gender: _selectedGender,
                bloodGroup: _selectedBloodGroup,
                // Note: height and weight are NOT supported by backend
                address: AddressInfo(
                  street: _streetController.text.isNotEmpty
                      ? _streetController.text
                      : null,
                  city: _cityController.text.isNotEmpty
                      ? _cityController.text
                      : null,
                  state: _stateController.text.isNotEmpty
                      ? _stateController.text
                      : null,
                  zipCode: _zipCodeController.text.isNotEmpty
                      ? _zipCodeController.text
                      : null,
                ),
                emergencyContact: _emergencyNameController.text.isNotEmpty
                    ? EmergencyContact(
                        name: _emergencyNameController.text,
                        phoneNumber: _emergencyPhoneController.text,
                        relationship: _emergencyRelationController.text,
                      )
                    : null,
              ),
            );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Mark profile as complete
        await TokenStorage.instance.setProfileSetupComplete(true);

        if (_isInitialSetup) {
          // Initial setup - navigate to home and clear the stack
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.home,
            (route) => false,
          );
        } else {
          // Regular edit - just go back
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                ref.read(profileControllerProvider).error ?? 'Update failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final patient = profileState.patient;

    // Initialize form fields from patient data
    _initializeFromPatient(patient);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: AppResponsive.icon(context, 24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Personal Information',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: profileState.isLoading && patient == null
          ? const Center(child: LoadingIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppResponsive.p(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: AppResponsive.s(context, 60),
                            backgroundColor: AppColors.greyLight,
                            backgroundImage: patient?.profilePhoto != null
                                ? NetworkImage(patient!.profilePhoto!)
                                : null,
                            child: patient?.profilePhoto == null
                                ? Icon(
                                    Icons.person,
                                    size: AppResponsive.icon(context, 60),
                                    color: AppColors.textSecondary,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Implement photo upload
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.all(AppResponsive.p(context, 8)),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: AppResponsive.icon(context, 16),
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Basic Info Section
                    _buildSectionTitle('Basic Information'),
                    SizedBox(height: AppResponsive.p(context, 12)),
                    _buildFormTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Full name is required'
                          : null,
                    ),
                    _buildFormTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: false,
                    ),
                    _buildFormTextField(
                      controller: _phoneController,
                      label: 'Phone Number (10 digits)',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
                          return 'Must be a valid 10-digit number starting with 6-9';
                        }
                        return null;
                      },
                    ),

                    // Gender dropdown
                    _buildDropdownField<Gender>(
                      label: 'Gender',
                      icon: Icons.wc_outlined,
                      value: _selectedGender,
                      items: Gender.values,
                      itemLabel: (g) => g.displayName,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),

                    // Date of Birth
                    _buildDateField(),

                    // Blood Group dropdown
                    _buildDropdownField<BloodGroup>(
                      label: 'Blood Group',
                      icon: Icons.bloodtype_outlined,
                      value: _selectedBloodGroup,
                      items: BloodGroup.values
                          .where((b) => b != BloodGroup.unknown)
                          .toList(),
                      itemLabel: (b) => b.value,
                      onChanged: (value) =>
                          setState(() => _selectedBloodGroup = value),
                    ),

                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Note: Physical Information (height/weight) removed
                    // Backend UpdatePatientDto doesn't support these fields
                    // Use the Medical History / Vital Signs API for tracking these

                    // Address Section
                    _buildSectionTitle('Address'),
                    SizedBox(height: AppResponsive.p(context, 12)),
                    _buildFormTextField(
                      controller: _streetController,
                      label: 'Street Address',
                      icon: Icons.home_outlined,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormTextField(
                            controller: _cityController,
                            label: 'City',
                            icon: Icons.location_city_outlined,
                          ),
                        ),
                        SizedBox(width: AppResponsive.p(context, 12)),
                        Expanded(
                          child: _buildFormTextField(
                            controller: _stateController,
                            label: 'State',
                            icon: Icons.map_outlined,
                          ),
                        ),
                      ],
                    ),
                    _buildFormTextField(
                      controller: _zipCodeController,
                      label: 'ZIP Code',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Emergency Contact Section
                    _buildSectionTitle('Emergency Contact'),
                    SizedBox(height: AppResponsive.p(context, 12)),
                    _buildFormTextField(
                      controller: _emergencyNameController,
                      label: 'Contact Name',
                      icon: Icons.person_outline,
                    ),
                    _buildFormTextField(
                      controller: _emergencyPhoneController,
                      label: 'Contact Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildFormTextField(
                      controller: _emergencyRelationController,
                      label: 'Relationship',
                      icon: Icons.family_restroom_outlined,
                    ),

                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Allergies Section
                    if (patient?.allergies != null &&
                        patient!.allergies!.isNotEmpty) ...[
                      _buildSectionTitle('Allergies'),
                      SizedBox(height: AppResponsive.p(context, 12)),
                      Wrap(
                        spacing: AppResponsive.p(context, 8),
                        runSpacing: AppResponsive.p(context, 8),
                        children: patient.allergies!
                            .map((allergy) => _buildAllergyChip(allergy))
                            .toList(),
                      ),
                      SizedBox(height: AppResponsive.p(context, 24)),
                    ],

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            profileState.isUpdating ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            vertical: AppResponsive.p(context, 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 12),
                            ),
                          ),
                        ),
                        child: profileState.isUpdating
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: AppResponsive.p(context, 32)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppResponsive.fontSize(context, 16),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFormTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: AppResponsive.icon(context, 20)),
          filled: !enabled,
          fillColor:
              enabled ? null : AppColors.greyLight.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: AppResponsive.icon(context, 20)),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 16)),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDateOfBirth ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() => _selectedDateOfBirth = picked);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 12),
            vertical: AppResponsive.p(context, 16),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.cake_outlined,
                size: AppResponsive.icon(context, 20),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Expanded(
                child: Text(
                  _selectedDateOfBirth != null
                      ? dateFormat.format(_selectedDateOfBirth!)
                      : 'Date of Birth',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    color: _selectedDateOfBirth != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.calendar_today,
                size: AppResponsive.icon(context, 20),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllergyChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
        vertical: AppResponsive.p(context, 8),
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 14),
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
