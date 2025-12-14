import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Feedback Page - Area Improvement Selection
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final List<FeedbackChip> _feedbackOptions = [
    FeedbackChip(label: 'Performance', isSelected: false),
    FeedbackChip(label: 'Bug', isSelected: false),
    FeedbackChip(label: 'UX', isSelected: true, color: Color(0xFF00BCD4)),
    FeedbackChip(label: 'UI', isSelected: false),
    FeedbackChip(label: 'Crashes', isSelected: false),
    FeedbackChip(label: 'Loading', isSelected: true, color: Color(0xFFE53935)),
    FeedbackChip(label: 'Support', isSelected: false),
    FeedbackChip(label: 'Security', isSelected: false),
    FeedbackChip(label: 'Pricing', isSelected: false),
    FeedbackChip(label: 'Lag', isSelected: true, color: Color(0xFF9C27B0)),
    FeedbackChip(
        label: 'Animation', isSelected: true, color: Color(0xFF2196F3)),
    FeedbackChip(label: 'Design', isSelected: false),
    FeedbackChip(label: 'Marketing', isSelected: false),
  ];

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
          'Send Feedback',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppResponsive.p(context, 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Which Of The Area Needs Improvement?',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppResponsive.p(context, 24)),
                  Wrap(
                    spacing: AppResponsive.p(context, 12),
                    runSpacing: AppResponsive.p(context, 12),
                    children: _feedbackOptions.map((option) {
                      return _buildFeedbackChip(option);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 16)),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selectedFeedback = _feedbackOptions
                      .where((option) => option.isSelected)
                      .map((option) => option.label)
                      .toList();

                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Thank You!'),
                      content: Text(
                        'Your feedback has been submitted.\n\nSelected areas: ${selectedFeedback.join(', ')}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Feedback',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: AppResponsive.p(context, 8)),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.white,
                      size: AppResponsive.icon(context, 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackChip(FeedbackChip option) {
    return InkWell(
      onTap: () {
        setState(() {
          option.isSelected = !option.isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.p(context, 20),
          vertical: AppResponsive.p(context, 12),
        ),
        decoration: BoxDecoration(
          color: option.isSelected
              ? (option.color ?? AppColors.feedbackChipSelected)
                  .withValues(alpha: 0.1)
              : AppColors.feedbackChipUnselected,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 24),
          ),
          border: Border.all(
            color: option.isSelected
                ? (option.color ?? AppColors.feedbackChipSelected)
                : AppColors.inputBorder,
            width: option.isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          option.label,
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: option.isSelected ? FontWeight.w600 : FontWeight.normal,
            color: option.isSelected
                ? (option.color ?? AppColors.feedbackChipSelected)
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class FeedbackChip {
  final String label;
  bool isSelected;
  final Color? color;

  FeedbackChip({
    required this.label,
    required this.isSelected,
    this.color,
  });
}
