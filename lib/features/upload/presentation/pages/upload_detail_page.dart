import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Upload detail page with document preview and upload type selection
class UploadDetailPage extends StatefulWidget {
  const UploadDetailPage({super.key});

  @override
  State<UploadDetailPage> createState() => _UploadDetailPageState();
}

class _UploadDetailPageState extends State<UploadDetailPage> {
  String? _selectedUploadType;

  final List<String> _uploadTypes = [
    'Prescription',
    'Lab Test',
    'Medication',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Header with back button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 20),
                vertical: AppResponsive.p(context, 16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                      size: AppResponsive.icon(context, 24),
                    ),
                  ),
                  SizedBox(width: AppResponsive.w(context, 0.04)),
                  Text(
                    'Upload Documents',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppResponsive.fontSize(context, 20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.p(context, 20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppResponsive.h(context, 0.02)),

                    // Document preview card
                    Container(
                      width: double.infinity,
                      height: AppResponsive.h(context, 0.25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 16),
                        ),
                        image: const DecorationImage(
                          image:
                              AssetImage('assets/images/sample_document.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Gradient overlay at bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: AppResponsive.h(context, 0.08),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    AppResponsive.radius(context, 16),
                                  ),
                                  bottomRight: Radius.circular(
                                    AppResponsive.radius(context, 16),
                                  ),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.uploadCardOverlay,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // File name
                          Positioned(
                            bottom: AppResponsive.p(context, 12),
                            left: AppResponsive.p(context, 16),
                            child: Text(
                              'Fiver and cold.pdf',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppResponsive.fontSize(context, 14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppResponsive.h(context, 0.03)),

                    // Upload Type label
                    Text(
                      'Upload Type',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: AppResponsive.h(context, 0.015)),

                    // Dropdown
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.p(context, 16),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.dropdownBackground,
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 12),
                        ),
                        border: Border.all(
                          color: AppColors.dropdownBorder,
                          width: AppResponsive.thickness(context, 1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedUploadType,
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppResponsive.fontSize(context, 14),
                            ),
                          ),
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: AppResponsive.icon(context, 24),
                          ),
                          items: _uploadTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: AppResponsive.fontSize(context, 14),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedUploadType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save button
            Padding(
              padding: EdgeInsets.all(AppResponsive.p(context, 20)),
              child: GestureDetector(
                onTap: () {
                  if (_selectedUploadType != null) {
                    // Save logic
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: AppResponsive.s(context, 56),
                  decoration: BoxDecoration(
                    color: _selectedUploadType != null
                        ? AppColors.uploadButtonBackground
                        : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 12),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppResponsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
