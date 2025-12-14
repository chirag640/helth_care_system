import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Personal Information Edit Page
class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  double _weight = 65;

  @override
  Widget build(BuildContext context) {
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
          'Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppResponsive.p(context, 16)),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: AppResponsive.s(context, 60),
                  backgroundImage:
                      const AssetImage('assets/images/profile_avatar.png'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppResponsive.p(context, 8)),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: AppResponsive.icon(context, 16),
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.p(context, 24)),
            _buildTextField('Full Name', 'Kaori Miyazonol'),
            _buildDropdown('Location', 'New york, USA'),
            _buildDropdown('Gender', 'Male'),
            _buildTextField('Phone Number', '(+1) 012 - 456 - 789'),
            _buildAgeSelector(),
            _buildDropdown('Prefered Language', 'Japanese (JP)'),
            _buildWeightSlider(),
            _buildEmergencyContact(),
            _buildAllergiesSection(),
            SizedBox(height: AppResponsive.p(context, 24)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 8)),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            suffixIcon: Icon(Icons.edit_outlined),
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
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 16)),
      ],
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 14),
          ),
          decoration: BoxDecoration(
            color: AppColors.profileCardBackground,
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: AppResponsive.icon(context, 20),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Expanded(
                child: Text(
                  value,
                  style:
                      TextStyle(fontSize: AppResponsive.fontSize(context, 14)),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: AppResponsive.icon(context, 20),
              ),
            ],
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 16)),
      ],
    );
  }

  Widget _buildAgeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Age',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.p(context, 16),
            vertical: AppResponsive.p(context, 12),
          ),
          decoration: BoxDecoration(
            color: AppColors.profileCardBackground,
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.cake_outlined, size: AppResponsive.icon(context, 20)),
              SizedBox(width: AppResponsive.p(context, 12)),
              Text(
                '17',
                style: TextStyle(fontSize: AppResponsive.fontSize(context, 14)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 16)),
      ],
    );
  }

  Widget _buildWeightSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (kilograms)',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 8)),
        Row(
          children: [
            Text(
              '60',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 12),
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(
              child: Slider(
                value: _weight,
                min: 60,
                max: 70,
                activeColor: AppColors.sliderActive,
                inactiveColor: AppColors.sliderInactive,
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
            ),
            Text(
              '70',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            _weight.toStringAsFixed(0),
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 16)),
      ],
    );
  }

  Widget _buildEmergencyContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 8)),
        Container(
          padding: EdgeInsets.all(AppResponsive.p(context, 16)),
          decoration: BoxDecoration(
            color: AppColors.profileBadgeBackground,
            borderRadius:
                BorderRadius.circular(AppResponsive.radius(context, 12)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: AppColors.primary,
                size: AppResponsive.icon(context, 20),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Text(
                'Add Emergency Contact',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppResponsive.p(context, 16)),
      ],
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
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Edit',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 14),
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.p(context, 12)),
        Wrap(
          spacing: AppResponsive.p(context, 8),
          runSpacing: AppResponsive.p(context, 8),
          children: [
            _buildAllergyChip('Peanuts'),
            _buildAllergyChip('Cherry'),
            _buildAllergyChip('Pipe Bomb'),
            _buildAllergyChip('Apple'),
          ],
        ),
      ],
    );
  }

  Widget _buildAllergyChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.p(context, 16),
        vertical: AppResponsive.p(context, 8),
      ),
      decoration: BoxDecoration(
        color: AppColors.allergyChipBackground,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
      ),
    );
  }
}
