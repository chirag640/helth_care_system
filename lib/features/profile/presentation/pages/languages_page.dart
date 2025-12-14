import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Languages Page - Language Selection
class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  String _selectedLanguage = 'US';

  final List<LanguageItem> _languages = [
    LanguageItem(code: 'US', name: 'United States', flag: '🇺🇸'),
    LanguageItem(code: 'IL', name: 'Italian', flag: '🇮🇹'),
    LanguageItem(code: 'DE', name: 'Germany', flag: '🇩🇪'),
    LanguageItem(code: 'FR', name: 'French', flag: '🇫🇷'),
    LanguageItem(code: 'AR', name: 'Arabic', flag: '🇸🇦'),
    LanguageItem(code: 'CN', name: 'Chinese Simplified', flag: '🇨🇳'),
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
          'Languages',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 16)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              decoration: BoxDecoration(
                color: AppColors.profileCardBackground,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 12),
                ),
                border: Border.all(color: AppColors.inputBorder),
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
                        hintText: 'Search languages...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                fontSize: AppResponsive.fontSize(context, 14)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected Language Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.p(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Language',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppResponsive.p(context, 12)),
                _buildLanguageItem(
                  _languages
                      .firstWhere((lang) => lang.code == _selectedLanguage),
                  isSelected: true,
                ),
              ],
            ),
          ),

          SizedBox(height: AppResponsive.p(context, 24)),

          // All Languages Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Languages',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 14),
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.p(context, 12)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _languages.length,
                      itemBuilder: (context, index) {
                        final language = _languages[index];
                        if (language.code == _selectedLanguage) {
                          return const SizedBox.shrink();
                        }
                        return _buildLanguageItem(language);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: EdgeInsets.all(AppResponsive.p(context, 16)),
            child: SizedBox(
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
                  'Save Changes',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(LanguageItem language, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 12),
        ),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            language.flag,
            style: TextStyle(fontSize: AppResponsive.fontSize(context, 28)),
          ),
          SizedBox(width: AppResponsive.p(context, 16)),
          Expanded(
            child: Text(
              '${language.name} (${language.code})',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 15),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: AppResponsive.s(context, 20),
            height: AppResponsive.s(context, 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.languageCheckbox
                    : AppColors.inputBorder,
                width: 2,
              ),
              color:
                  isSelected ? AppColors.languageCheckbox : Colors.transparent,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: AppResponsive.icon(context, 14),
                    color: AppColors.white,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class LanguageItem {
  final String code;
  final String name;
  final String flag;

  LanguageItem({
    required this.code,
    required this.name,
    required this.flag,
  });
}
