import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../controller/upload_controller.dart';
import '../../models/models.dart';

/// Upload detail page with document preview and upload type selection
class UploadDetailPage extends ConsumerStatefulWidget {
  const UploadDetailPage({super.key});

  @override
  ConsumerState<UploadDetailPage> createState() => _UploadDetailPageState();
}

class _UploadDetailPageState extends ConsumerState<UploadDetailPage> {
  DocumentType? _selectedDocType;
  String? _filePath;
  String? _fileName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get file path from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _filePath == null) {
      _filePath = args;
      _fileName = args.split('/').last;
    }
  }

  Future<void> _handleSave() async {
    if (_selectedDocType == null || _filePath == null) return;

    final profileState = ref.read(profileControllerProvider);
    final patient = profileState.patient;

    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your profile first')),
      );
      return;
    }

    final controller = ref.read(uploadControllerProvider.notifier);

    // For now, use a placeholder hospital ID - this should come from app config or user selection
    const hospitalId = 'default-hospital';

    final success = await controller.uploadDocument(
      filePath: _filePath!,
      patientId: patient.id,
      hospitalId: hospitalId,
      docType: _selectedDocType!,
      fileName: _fileName,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        final error = ref.read(uploadControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to upload document'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadControllerProvider);
    final isUploading = uploadState.isUploading;

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
                    onTap: isUploading ? null : () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isUploading
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
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
                    _buildPreviewCard(context),

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
                    _buildTypeDropdown(context),

                    if (uploadState.error != null) ...[
                      SizedBox(height: AppResponsive.h(context, 0.02)),
                      Container(
                        padding: EdgeInsets.all(AppResponsive.p(context, 12)),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: AppResponsive.icon(context, 20),
                            ),
                            SizedBox(width: AppResponsive.w(context, 0.02)),
                            Expanded(
                              child: Text(
                                uploadState.error!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: AppResponsive.fontSize(context, 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Save button
            Padding(
              padding: EdgeInsets.all(AppResponsive.p(context, 20)),
              child: GestureDetector(
                onTap: isUploading ? null : _handleSave,
                child: Container(
                  width: double.infinity,
                  height: AppResponsive.s(context, 56),
                  decoration: BoxDecoration(
                    color: _selectedDocType != null && !isUploading
                        ? AppColors.uploadButtonBackground
                        : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 12),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isUploading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: AppResponsive.s(context, 20),
                              height: AppResponsive.s(context, 20),
                              child: const CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: AppResponsive.w(context, 0.02)),
                            Text(
                              'Uploading...',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppResponsive.fontSize(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
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

  Widget _buildPreviewCard(BuildContext context) {
    final hasFile = _filePath != null && File(_filePath!).existsSync();

    return Container(
      width: double.infinity,
      height: AppResponsive.h(context, 0.25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 16),
        ),
        color: AppColors.greyLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image preview
            if (hasFile)
              Image.file(
                File(_filePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.insert_drive_file,
                    size: AppResponsive.icon(context, 64),
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Center(
                child: Icon(
                  Icons.insert_drive_file,
                  size: AppResponsive.icon(context, 64),
                  color: AppColors.textSecondary,
                ),
              ),

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
              right: AppResponsive.p(context, 16),
              child: Text(
                _fileName ?? 'No file selected',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppResponsive.fontSize(context, 14),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return Container(
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
        child: DropdownButton<DocumentType>(
          value: _selectedDocType,
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
          items: DocumentType.values.map((DocumentType type) {
            return DropdownMenuItem<DocumentType>(
              value: type,
              child: Text(
                type.displayName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppResponsive.fontSize(context, 14),
                ),
              ),
            );
          }).toList(),
          onChanged: (DocumentType? newValue) {
            setState(() {
              _selectedDocType = newValue;
            });
          },
        ),
      ),
    );
  }
}
