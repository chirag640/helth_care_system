import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// FAQ Page - Frequently Asked Questions
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int? _expandedIndex;

  final List<FaqItem> _faqs = [
    FaqItem(
      question: 'What is ExpertMed?',
      answer:
          'ExpertMed is an AI-powered health assistant that helps you manage your health records, appointments, and prescriptions.',
    ),
    FaqItem(
      question: 'How does ExpertMed Work?',
      answer:
          'ExpertMed uses advanced AI algorithms to analyze your health data and provide personalized health recommendations. It connects with your healthcare providers to keep your records up-to-date and helps you schedule appointments seamlessly.',
    ),
    FaqItem(
      question: 'Is ExpertMed a replacement for professional Healthcare?',
      answer:
          'No, ExpertMed is not a replacement for professional healthcare. It is a tool to help you manage your health better and stay connected with your healthcare providers.',
    ),
    FaqItem(
      question: 'How do I access ExpertMed?',
      answer:
          'You can access ExpertMed through our mobile app or web portal using your registered credentials.',
    ),
    FaqItem(
      question: 'Is ExpertMed free to use?',
      answer:
          'ExpertMed offers both free and premium plans. The free plan includes basic features, while premium plans unlock advanced features.',
    ),
    FaqItem(
      question: 'Is my data secure?',
      answer:
          'Yes, we take data security very seriously. All your health data is encrypted and stored securely following HIPAA compliance standards.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppResponsive.p(context, 20)),
              decoration: BoxDecoration(
                color: AppColors.faqHeaderBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(AppResponsive.radius(context, 24)),
                  bottomRight:
                      Radius.circular(AppResponsive.radius(context, 24)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                          size: AppResponsive.icon(context, 24),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 8)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.p(context, 16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FAQ Contents',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: AppResponsive.p(context, 8)),
                        Text(
                          'Explore more than 251 questions for you.',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 14),
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        SizedBox(height: AppResponsive.p(context, 16)),
                        // Search Bar
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.p(context, 16),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                                size: AppResponsive.icon(context, 20),
                              ),
                              SizedBox(width: AppResponsive.p(context, 12)),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search FAQs...',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: AppResponsive.fontSize(
                                                context, 14)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAQ List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppResponsive.p(context, 16)),
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  final faq = _faqs[index];
                  final isExpanded = _expandedIndex == index;

                  return Container(
                    margin:
                        EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppColors.faqExpandedBackground
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 12),
                      ),
                      border: Border.all(
                        color: AppColors.profileSectionDivider,
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? null : index;
                            });
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.all(AppResponsive.p(context, 16)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faq.question,
                                    style: TextStyle(
                                      fontSize:
                                          AppResponsive.fontSize(context, 15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                  size: AppResponsive.icon(context, 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppResponsive.p(context, 16),
                              0,
                              AppResponsive.p(context, 16),
                              AppResponsive.p(context, 16),
                            ),
                            child: Text(
                              faq.answer,
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 14),
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
