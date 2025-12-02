import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/member/domain/models/preference.dart';
import 'package:fitkle/features/member/domain/services/interest_service.dart';
import 'package:fitkle/features/member/domain/services/preference_service.dart';
import 'package:fitkle/features/member/domain/enums/gender.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/country_search_field.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/language_search_field.dart';
import 'package:fitkle/shared/widgets/selectable_option.dart';
import 'package:fitkle/features/auth/domain/models/signup_data.dart';
import 'package:fitkle/shared/widgets/selection_field.dart';
import 'package:fitkle/shared/widgets/selection_modal.dart';

class AdditionalInfoStep extends StatefulWidget {
  final SignupData initialData;
  final Function(SignupData) onSubmit;

  const AdditionalInfoStep({
    super.key,
    required this.initialData,
    required this.onSubmit,
  });

  @override
  State<AdditionalInfoStep> createState() => _AdditionalInfoStepState();
}

class _AdditionalInfoStepState extends State<AdditionalInfoStep> {
  late String _nationality;
  late String? _language;
  late String? _gender;

  // Store selected items as names (String) for modal
  List<String> _selectedInterestNames = [];
  List<String> _selectedPreferenceNames = [];

  // All available items
  List<Interest> _availableInterests = [];
  List<Preference> _availablePreferences = [];
  bool _isLoadingInterests = false;
  bool _isLoadingPreferences = false;
  final InterestService _interestService = InterestService();
  final PreferenceService _preferenceService = PreferenceService();

  @override
  void initState() {
    super.initState();
    _nationality = widget.initialData.nationality;
    _language = widget.initialData.language;
    _gender = widget.initialData.gender;

    // Initialize selected names from initial data
    _selectedInterestNames = widget.initialData.selectedInterests
        .map((interest) => interest.name)
        .toList();
    _selectedPreferenceNames = widget.initialData.selectedPreferences
        .map((preference) => preference.name)
        .toList();

    _loadInterests();
    _loadPreferences();
  }

  Future<void> _loadInterests() async {
    setState(() => _isLoadingInterests = true);
    try {
      final interests = await _interestService.getInterests();
      setState(() {
        _availableInterests = interests;
        _isLoadingInterests = false;
      });
    } catch (e) {
      setState(() => _isLoadingInterests = false);
    }
  }

  Future<void> _loadPreferences() async {
    setState(() => _isLoadingPreferences = true);
    try {
      final preferences = await _preferenceService.getPreferences();
      setState(() {
        _availablePreferences = preferences;
        _isLoadingPreferences = false;
      });
    } catch (e) {
      setState(() => _isLoadingPreferences = false);
    }
  }

  void _openInterestsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectionModal(
        title: 'Select your interests',
        selectedItems: _selectedInterestNames,
        allItems: _availableInterests
            .map((i) => {
                  'id': i.id,
                  'label': i.name,
                  'emoji': i.emoji ?? '⭐',
                  'category': i.categoryCode,
                })
            .toList(),
        onSave: (selectedNames) {
          setState(() {
            _selectedInterestNames = selectedNames;
          });
        },
        getItemEmoji: (name) {
          final interest = _availableInterests.firstWhere(
            (i) => i.name == name,
            orElse: () => _availableInterests.first,
          );
          return interest.emoji ?? '⭐';
        },
        maxSelection: 10,
        categoryKey: 'category',
      ),
    );
  }

  void _openPreferencesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectionModal(
        title: 'Select your preferred event types',
        selectedItems: _selectedPreferenceNames,
        allItems: _availablePreferences
            .map((p) => {'id': p.id, 'label': p.name, 'emoji': p.emoji})
            .toList(),
        onSave: (selectedNames) {
          setState(() {
            _selectedPreferenceNames = selectedNames;
          });
        },
        getItemEmoji: (name) {
          final preference = _availablePreferences.firstWhere(
            (p) => p.name == name,
            orElse: () => _availablePreferences.first,
          );
          return preference.emoji;
        },
        maxSelection: 10,
        categoryKey: '',
      ),
    );
  }

  void _handleSubmit() {
    if (_nationality.isEmpty) {
      _showSnackBar('국적을 선택해주세요.');
      return;
    }
    if (_language == null) {
      _showSnackBar('언어를 선택해주세요.');
      return;
    }
    if (_gender == null) {
      _showSnackBar('성별을 선택해주세요.');
      return;
    }
    if (_selectedInterestNames.isEmpty) {
      _showSnackBar('관심사를 최소 1개 이상 선택해주세요.');
      return;
    }

    // Convert names back to full objects
    final selectedInterests = _availableInterests
        .where((interest) => _selectedInterestNames.contains(interest.name))
        .toList();
    final selectedPreferences = _availablePreferences
        .where((preference) => _selectedPreferenceNames.contains(preference.name))
        .toList();

    final data = widget.initialData.copyWith(
      nationality: _nationality,
      language: _language,
      gender: _gender,
      selectedInterests: selectedInterests,
      selectedPreferences: selectedPreferences,
    );

    widget.onSubmit(data);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '추가 정보 입력',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '프로필 설정을 위한 정보를 입력해주세요',
          style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
        ),
        const SizedBox(height: 32),

        // Nationality search field
        CountrySearchField(
          selectedCountryCode: _nationality.isEmpty ? null : _nationality,
          onCountrySelected: (countryCode, countryName) {
            setState(() => _nationality = countryCode);
          },
        ),
        const SizedBox(height: 24),

        // Language
        LanguageSearchField(
          selectedLanguageCode: _language,
          onLanguageSelected: (languageCode, languageName) {
            setState(() => _language = languageCode);
          },
        ),
        const SizedBox(height: 24),

        // Gender selection
        Column(
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
                  TextSpan(text: '성별'),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: Gender.values.map((gender) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: gender != Gender.values.last ? 12 : 0,
                    ),
                    child: SelectableOption(
                      value: gender.code,
                      label: gender.nameEn,
                      icon: gender == Gender.male
                          ? Icons.male
                          : gender == Gender.female
                              ? Icons.female
                              : Icons.more_horiz,
                      isSelected: _gender == gender.code,
                      onTap: () => setState(() => _gender = gender.code),
                      style: SelectableOptionStyle.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Interests using SelectionField
        _isLoadingInterests
            ? const Center(child: CircularProgressIndicator())
            : SelectionField(
                title: '관심사 *',
                description: '최대 10개까지 선택 가능 (${_selectedInterestNames.length}/10)',
                selectedItemIds: _selectedInterestNames,
                getItemName: (name) => name,
                getItemEmoji: (name) {
                  final interest = _availableInterests.firstWhere(
                    (i) => i.name == name,
                    orElse: () => _availableInterests.first,
                  );
                  return interest.emoji ?? '⭐';
                },
                onTap: _openInterestsModal,
                emptyMessage: '관심사를 선택해주세요',
              ),
        const SizedBox(height: 24),

        // Preferences using SelectionField
        _isLoadingPreferences
            ? const Center(child: CircularProgressIndicator())
            : SelectionField(
                title: '내가 찾는 카테고리',
                description: '최대 10개까지 선택 가능 (${_selectedPreferenceNames.length}/10)',
                selectedItemIds: _selectedPreferenceNames,
                getItemName: (name) => name,
                getItemEmoji: (name) {
                  final preference = _availablePreferences.firstWhere(
                    (p) => p.name == name,
                    orElse: () => _availablePreferences.first,
                  );
                  return preference.emoji;
                },
                onTap: _openPreferencesModal,
                emptyMessage: '선호하는 카테고리를 선택해주세요',
              ),
        const SizedBox(height: 32),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_nationality.isNotEmpty &&
                       _language != null &&
                       _gender != null &&
                       _selectedInterestNames.isNotEmpty)
                ? _handleSubmit
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              disabledBackgroundColor: AppTheme.mutedForeground.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '가입 완료',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
