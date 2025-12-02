import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/domain/enums/language.dart';
import 'package:fitkle/features/member/domain/enums/country.dart';
import 'package:fitkle/shared/widgets/bottom_sheet_selector.dart';

class LanguageSearchField extends StatefulWidget {
  final String? selectedLanguageCode;
  final Function(String languageCode, String languageName) onLanguageSelected;

  const LanguageSearchField({
    super.key,
    this.selectedLanguageCode,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageSearchField> createState() => _LanguageSearchFieldState();
}

class _LanguageSearchFieldState extends State<LanguageSearchField> {
  String? _selectedLanguageName;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLanguageCode != null) {
      final language = Language.fromCode(widget.selectedLanguageCode!);
      if (language != null) {
        _selectedLanguageName = language.name;
      }
    }
  }

  Future<void> _showLanguagePicker() async {
    final currentLanguage = widget.selectedLanguageCode != null
        ? Language.fromCode(widget.selectedLanguageCode!)
        : null;

    final selectedLanguage = await BottomSheetSelector.show<Language>(
      context: context,
      title: '언어 선택',
      searchHint: '언어를 검색하세요',
      items: Language.values,
      selectedItem: currentLanguage,
      getItemLabel: (language) => language.name,
      getItemSubtitle: (language) => language.nameEn,
      getItemLeading: (language) {
        final country = Country.fromCode(language.code);
        return country?.flag;
      },
      onSearch: (query) => Language.search(query),
      heightFactor: 0.85,
    );

    if (selectedLanguage != null) {
      setState(() {
        _selectedLanguageName = selectedLanguage.name;
      });
      widget.onLanguageSelected(
        selectedLanguage.code,
        selectedLanguage.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.foreground,
            ),
            children: [
              TextSpan(text: '언어 설정'),
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showLanguagePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedLanguageName ?? '언어를 선택해주세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedLanguageName != null ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
