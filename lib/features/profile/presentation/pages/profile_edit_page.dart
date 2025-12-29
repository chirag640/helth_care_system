import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/profile_controller.dart';
import '../../models/patient_model.dart';

/// Profile Edit Page - Pixel Perfect Design matching the UI mockup
/// Features:
/// - Profile photo with edit button
/// - Full Name with person icon
/// - Location dropdown
/// - Gender dropdown
/// - Phone Number field
/// - Current Age with +/- controls
/// - Preferred Language dropdown
/// - Weight slider
/// - Emergency Contact button
/// - Allergies & Reactions chips with Edit
/// - Save button
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  // State
  Gender? _selectedGender;
  String _selectedLanguage = 'Japanese (JP)';
  int _currentAge = 17;
  double _weight = 65.0;
  List<String> _allergies = [];
  EmergencyContact? _emergencyContact;

  bool _isInitialized = false;
  bool _isInitialSetup = false;

  // Language options
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English (US)', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'Hindi (IN)', 'flag': '🇮🇳'},
    {'code': 'jp', 'name': 'Japanese (JP)', 'flag': '🇯🇵'},
    {'code': 'zh', 'name': 'Chinese (CN)', 'flag': '🇨🇳'},
    {'code': 'es', 'name': 'Spanish (ES)', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French (FR)', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German (DE)', 'flag': '🇩🇪'},
    {'code': 'ar', 'name': 'Arabic (AR)', 'flag': '🇸🇦'},
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'initial') {
      _isInitialSetup = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeFromPatient(PatientModel? patient) {
    if (_isInitialized || patient == null) return;

    _fullNameController.text = patient.fullName ?? '';
    _phoneController.text = patient.phone ?? '';

    // Build location string
    if (patient.address != null) {
      final parts = <String>[];
      if (patient.address?.city != null && patient.address!.city!.isNotEmpty) {
        parts.add(patient.address!.city!);
      }
      if (patient.address?.state != null &&
          patient.address!.state!.isNotEmpty) {
        parts.add(patient.address!.state!);
      }
      if (patient.address?.country != null &&
          patient.address!.country!.isNotEmpty) {
        parts.add(patient.address!.country!);
      }
      _locationController.text = parts.join(', ');
    }

    _selectedGender = patient.gender;

    // Calculate age from DOB
    if (patient.dateOfBirth != null) {
      final today = DateTime.now();
      int age = today.year - patient.dateOfBirth!.year;
      if (today.month < patient.dateOfBirth!.month ||
          (today.month == patient.dateOfBirth!.month &&
              today.day < patient.dateOfBirth!.day)) {
        age--;
      }
      _currentAge = age > 0 ? age : 17;
    }

    // Allergies
    if (patient.allergies != null && patient.allergies!.isNotEmpty) {
      _allergies = List.from(patient.allergies!);
    }

    // Emergency contact
    _emergencyContact = patient.emergencyContact;

    _isInitialized = true;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Get phone number
    String? phoneValue = _phoneController.text.isNotEmpty
        ? _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')
        : null;

    // Validate Indian phone format
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

    // Calculate DOB from age
    final dob =
        DateTime(DateTime.now().year - _currentAge, DateTime.now().month, 1);

    // Parse location
    final locationParts = _locationController.text.split(', ');

    final success =
        await ref.read(profileControllerProvider.notifier).updateProfile(
              UpdatePatientRequest(
                fullName: _fullNameController.text.isNotEmpty
                    ? _fullNameController.text
                    : null,
                phone: phoneValue,
                dateOfBirth: dob,
                gender: _selectedGender,
                address: AddressInfo(
                  city: locationParts.isNotEmpty ? locationParts[0] : null,
                  state: locationParts.length > 1 ? locationParts[1] : null,
                  country: locationParts.length > 2 ? locationParts[2] : null,
                ),
                emergencyContact: _emergencyContact,
                allergies: _allergies.isNotEmpty ? _allergies : null,
              ),
            );

    if (mounted) {
      if (success) {
        // Mark profile setup as complete
        await TokenStorage.instance.setProfileSetupComplete(true);

        // Refresh profile to get updated data
        await ref.read(profileControllerProvider.notifier).loadProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Small delay to show success message
          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            if (_isInitialSetup) {
              // Initial setup complete - go to home
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (route) => false,
              );
            } else {
              // Regular profile edit - go back
              Navigator.pop(context);
            }
          }
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

    _initializeFromPatient(patient);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
          'Profile',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: profileState.isLoading && patient == null
          ? const Center(child: LoadingIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Profile Photo Section
                    _buildProfilePhoto(patient),
                    SizedBox(height: AppResponsive.p(context, 32)),

                    // Full Name Field
                    _buildFieldLabel('Full Name'),
                    _buildNameField(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Location Field
                    _buildFieldLabel('Location'),
                    _buildLocationDropdown(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Gender Field
                    _buildFieldLabel('Gender'),
                    _buildGenderDropdown(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Phone Number Field
                    _buildFieldLabel('Phone Number'),
                    _buildPhoneField(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Current Age Field
                    _buildFieldLabel('Current Age'),
                    _buildAgeSelector(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Preferred Language Field
                    _buildFieldLabel('Preferred Language'),
                    _buildLanguageDropdown(),
                    SizedBox(height: AppResponsive.p(context, 20)),

                    // Weight Slider
                    _buildFieldLabel('Weight', suffix: '(kilograms)'),
                    _buildWeightSlider(),
                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Emergency Contact Section
                    _buildFieldLabel('Emergency Contact'),
                    _buildEmergencyContactButton(),
                    SizedBox(height: AppResponsive.p(context, 24)),

                    // Allergies Section
                    _buildAllergiesSection(),
                    SizedBox(height: AppResponsive.p(context, 32)),

                    // Save Button
                    _buildSaveButton(profileState),
                    SizedBox(height: AppResponsive.p(context, 40)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfilePhoto(PatientModel? patient) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: AppResponsive.s(context, 120),
            height: AppResponsive.s(context, 120),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyLight,
              image: patient?.profilePhoto != null
                  ? DecorationImage(
                      image: NetworkImage(patient!.profilePhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
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
                // TODO: Implement photo picker
                _showPhotoOptions();
              },
              child: Container(
                width: AppResponsive.s(context, 36),
                height: AppResponsive.s(context, 36),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  size: AppResponsive.icon(context, 18),
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {String? suffix}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.p(context, 8)),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 4),
            Text(
              suffix,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextFormField(
        controller: _fullNameController,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 16),
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your full name',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              Icons.person_outline,
              size: AppResponsive.icon(context, 22),
              color: AppColors.textSecondary,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              Icons.edit_outlined,
              size: AppResponsive.icon(context, 20),
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 14),
          ),
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Full name is required' : null,
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextFormField(
        controller: _locationController,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 16),
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Select location',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              Icons.location_on_outlined,
              size: AppResponsive.icon(context, 22),
              color: AppColors.textSecondary,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: AppResponsive.icon(context, 24),
              color: AppColors.textSecondary,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 14),
          ),
        ),
        readOnly: true,
        onTap: () => _showLocationPicker(),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButtonFormField<Gender>(
        value: _selectedGender,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              _selectedGender == Gender.male
                  ? Icons.male
                  : _selectedGender == Gender.female
                      ? Icons.female
                      : Icons.transgender,
              size: AppResponsive.icon(context, 22),
              color: AppColors.textSecondary,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 4),
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(right: AppResponsive.p(context, 8)),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: AppResponsive.icon(context, 24),
            color: AppColors.textSecondary,
          ),
        ),
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 16),
          color: AppColors.textPrimary,
        ),
        hint: Text(
          'Select gender',
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
        items: Gender.values.map((gender) {
          return DropdownMenuItem<Gender>(
            value: gender,
            child: Text(gender.displayName),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedGender = value);
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _PhoneNumberFormatter(),
        ],
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 16),
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: '(+1) 012 - 456 - 789',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Icon(
              Icons.phone_android_outlined,
              size: AppResponsive.icon(context, 22),
              color: AppColors.textSecondary,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 14),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 12),
        vertical: AppResponsive.p(context, 8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: AppResponsive.icon(context, 22),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: AppResponsive.p(context, 12)),
          Text(
            '$_currentAge',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 16),
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          // Minus button
          GestureDetector(
            onTap: () {
              if (_currentAge > 1) {
                setState(() => _currentAge--);
              }
            },
            child: Container(
              width: AppResponsive.s(context, 36),
              height: AppResponsive.s(context, 36),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius:
                    BorderRadius.circular(AppResponsive.radius(context, 8)),
              ),
              child: Icon(
                Icons.remove,
                size: AppResponsive.icon(context, 20),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 12)),
          // Plus button
          GestureDetector(
            onTap: () {
              if (_currentAge < 120) {
                setState(() => _currentAge++);
              }
            },
            child: Container(
              width: AppResponsive.s(context, 36),
              height: AppResponsive.s(context, 36),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius:
                    BorderRadius.circular(AppResponsive.radius(context, 8)),
              ),
              child: Icon(
                Icons.add,
                size: AppResponsive.icon(context, 20),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedLanguage,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 12)),
            child: Text(
              '🏴',
              style: TextStyle(fontSize: AppResponsive.fontSize(context, 20)),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 4),
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(right: AppResponsive.p(context, 8)),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: AppResponsive.icon(context, 24),
            color: AppColors.textSecondary,
          ),
        ),
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 16),
          color: AppColors.textPrimary,
        ),
        items: _languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang['name'],
            child: Row(
              children: [
                Text(lang['flag'] ?? ''),
                SizedBox(width: AppResponsive.p(context, 8)),
                Text(lang['name'] ?? ''),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedLanguage = value);
          }
        },
      ),
    );
  }

  Widget _buildWeightSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.greyLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: AppResponsive.s(context, 10),
            ),
          ),
          child: Slider(
            value: _weight,
            min: 30,
            max: 150,
            divisions: 120,
            onChanged: (value) {
              setState(() => _weight = value);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '60',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${_weight.round()}',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '70',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactButton() {
    final hasContact = _emergencyContact != null &&
        _emergencyContact!.name != null &&
        _emergencyContact!.name!.isNotEmpty;

    return GestureDetector(
      onTap: () => _showEmergencyContactDialog(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: AppResponsive.p(context, 14),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasContact
                  ? '${_emergencyContact!.name} (${_emergencyContact!.relationship ?? "Contact"})'
                  : 'Add Emergency Contact',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 16),
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppResponsive.p(context, 8)),
            Icon(
              hasContact ? Icons.edit : Icons.add,
              size: AppResponsive.icon(context, 20),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Allergies & Reactions',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => _showAllergiesDialog(),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.p(context, 12)),
        if (_allergies.isEmpty)
          GestureDetector(
            onTap: () => _showAllergiesDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
                vertical: AppResponsive.p(context, 10),
              ),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withOpacity(0.5),
                borderRadius:
                    BorderRadius.circular(AppResponsive.radius(context, 20)),
                border: Border.all(
                  color: AppColors.inputBorder,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: AppResponsive.icon(context, 18),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppResponsive.p(context, 4)),
                  Text(
                    'Add Allergy',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: AppResponsive.p(context, 8),
            runSpacing: AppResponsive.p(context, 8),
            children: _allergies.map((allergy) {
              return _buildAllergyChip(allergy);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildAllergyChip(String allergy) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
        vertical: AppResponsive.p(context, 10),
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
      ),
      child: Text(
        allergy,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 14),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSaveButton(ProfileState profileState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: profileState.isUpdating ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.p(context, 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 12),
            ),
          ),
          elevation: 0,
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
                'Save',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  // Helper methods for dialogs
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.radius(context, 20)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppResponsive.p(context, 20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    final locations = [
      'New York, USA',
      'Mumbai, Maharashtra, India',
      'Tokyo, Japan',
      'London, UK',
      'Sydney, Australia',
      'Dubai, UAE',
      'Singapore',
      'Berlin, Germany',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.radius(context, 20)),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: AppResponsive.p(context, 12),
              ),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppResponsive.p(context, 16)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 12),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(locations[index]),
                    onTap: () {
                      setState(() {
                        _locationController.text = locations[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyContactDialog() {
    final nameController =
        TextEditingController(text: _emergencyContact?.name ?? '');
    final phoneController =
        TextEditingController(text: _emergencyContact?.phoneNumber ?? '');
    final relationController =
        TextEditingController(text: _emergencyContact?.relationship ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 16)),
        ),
        title: const Text('Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 16)),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 16)),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                prefixIcon: Icon(Icons.family_restroom_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _emergencyContact = EmergencyContact(
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  relationship: relationController.text,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAllergiesDialog() {
    final allergyController = TextEditingController();
    final tempAllergies = List<String>.from(_allergies);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 16)),
          ),
          title: const Text('Manage Allergies'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: allergyController,
                        decoration: InputDecoration(
                          hintText: 'Enter allergy name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppResponsive.p(context, 8)),
                    IconButton(
                      onPressed: () {
                        if (allergyController.text.isNotEmpty) {
                          setDialogState(() {
                            tempAllergies.add(allergyController.text.trim());
                            allergyController.clear();
                          });
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: AppResponsive.icon(context, 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.p(context, 16)),
                if (tempAllergies.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(AppResponsive.p(context, 20)),
                    child: Text(
                      'No allergies added yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppResponsive.fontSize(context, 14),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: AppResponsive.p(context, 8),
                    runSpacing: AppResponsive.p(context, 8),
                    children: tempAllergies.map((allergy) {
                      return Chip(
                        label: Text(allergy),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setDialogState(() {
                            tempAllergies.remove(allergy);
                          });
                        },
                        backgroundColor: AppColors.greyLight.withOpacity(0.5),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _allergies = tempAllergies;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phone number formatter for display
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length <= 3) {
      return TextEditingValue(
        text: text.isEmpty ? '' : '(+91) $text',
        selection: TextSelection.collapsed(offset: text.length + 6),
      );
    } else if (text.length <= 6) {
      return TextEditingValue(
        text: '(+91) ${text.substring(0, 3)} - ${text.substring(3)}',
        selection: TextSelection.collapsed(offset: text.length + 9),
      );
    } else {
      final formatted =
          '(+91) ${text.substring(0, 3)} - ${text.substring(3, 6)} - ${text.substring(6, text.length > 10 ? 10 : text.length)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
}
