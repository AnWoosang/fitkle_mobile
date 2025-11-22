import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/member/domain/services/interest_service.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/country_search_field.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/language_search_field.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/selectable_chip.dart';
import 'package:fitkle/features/auth/presentation/widgets/signup/gender_option.dart';
import 'package:fitkle/features/auth/domain/models/signup_data.dart';

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
  late List<Interest> _selectedInterests;

  List<Interest> _availableInterests = [];
  bool _isLoadingInterests = false;
  final InterestService _interestService = InterestService();

  @override
  void initState() {
    super.initState();
    _nationality = widget.initialData.nationality;
    _language = widget.initialData.language;
    _gender = widget.initialData.gender;
    _selectedInterests = List.from(widget.initialData.selectedInterests);
    _loadInterests();
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
      print('Error loading interests: $e');
    }
  }

  void _toggleInterest(Interest interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
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
    if (_selectedInterests.isEmpty) {
      _showSnackBar('관심사를 최소 1개 이상 선택해주세요.');
      return;
    }

    final data = widget.initialData.copyWith(
      nationality: _nationality,
      language: _language,
      gender: _gender,
      selectedInterests: _selectedInterests,
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
            const Text(
              '성별',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GenderOption(
                    value: 'MALE',
                    label: 'Male',
                    icon: Icons.male,
                    isSelected: _gender == 'MALE',
                    onTap: () => setState(() => _gender = 'MALE'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GenderOption(
                    value: 'FEMALE',
                    label: 'Female',
                    icon: Icons.female,
                    isSelected: _gender == 'FEMALE',
                    onTap: () => setState(() => _gender = 'FEMALE'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GenderOption(
                    value: 'PREFER_NOT_TO_SAY',
                    label: 'Other',
                    icon: Icons.more_horiz,
                    isSelected: _gender == 'PREFER_NOT_TO_SAY',
                    onTap: () => setState(() => _gender = 'PREFER_NOT_TO_SAY'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Interests
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '관심사 (복수 선택 가능)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _isLoadingInterests
                ? const Center(child: CircularProgressIndicator())
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests
                        .map((interest) => SelectableChip(
                              label: interest.displayNameEn,
                              selected: _selectedInterests.contains(interest),
                              onTap: () => _toggleInterest(interest),
                            ))
                        .toList(),
                  ),
          ],
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
                       _selectedInterests.isNotEmpty)
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
