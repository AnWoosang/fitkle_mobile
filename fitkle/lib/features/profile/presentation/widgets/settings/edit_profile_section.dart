import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/user_avatar.dart';
import 'package:fitkle/shared/widgets/text_input_field.dart';
import 'package:fitkle/shared/widgets/selection_field.dart';

class EditProfileSection extends StatelessWidget {
  final String name;
  final String location;
  final String birthdate;
  final String gender;
  final String? avatarUrl;
  final bool isNicknameEditable;
  final List<String> selectedPreferences; // preference IDs
  final List<String> selectedInterests; // interest names
  final Function(String) onNameChanged;
  final VoidCallback onNameTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onPreferencesTap;
  final VoidCallback onInterestsTap;
  final String Function(String) getPreferenceName;
  final String Function(String) getPreferenceEmoji;
  final String Function(String) getInterestEmoji;

  const EditProfileSection({
    super.key,
    required this.name,
    required this.location,
    required this.birthdate,
    required this.gender,
    this.avatarUrl,
    required this.isNicknameEditable,
    required this.selectedPreferences,
    required this.selectedInterests,
    required this.onNameChanged,
    required this.onNameTap,
    required this.onAvatarTap,
    required this.onPreferencesTap,
    required this.onInterestsTap,
    required this.getPreferenceName,
    required this.getPreferenceEmoji,
    required this.getInterestEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 768),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This information will appear on your public profile',
                style: TextStyle(
                  color: AppTheme.mutedForeground,
                  fontSize: 12
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Profile Photo
          _buildProfilePhoto(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Basic Information
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),

          // Name Field
          _buildNameField(),
          const SizedBox(height: 24),

          // Location
          _buildLocationField(),
          const SizedBox(height: 16),

          // Birthdate
          _buildBirthdateField(),
          const SizedBox(height: 24),

          // Gender
          _buildGenderField(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Goals Section
          _buildGoalsSection(),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Photo',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppTheme.foreground
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onAvatarTap,
          child: Stack(
            children: [
              UserAvatar(
                avatarUrl: avatarUrl,
                size: 112,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.foreground,
              fontWeight: FontWeight.w600
            ),
            children: [
              TextSpan(text: 'Nickname'),
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Can only be changed once every 30 days',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: isNicknameEditable ? onNameTap : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isNicknameEditable ? Colors.white : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name.isNotEmpty ? name : 'Enter your nickname',
                    style: TextStyle(
                      fontSize: 14,
                      color: name.isNotEmpty ? AppTheme.foreground : AppTheme.mutedForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: isNicknameEditable ? AppTheme.mutedForeground : Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.foreground,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 12),
        TextInputField(
          controller: TextEditingController(text: location),
          readOnly: true,
          enabled: false,
          prefixIcon: const Icon(Icons.location_on, color: AppTheme.mutedForeground, size: 18),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit, size: 15),
          label: const Text(
            'Edit address',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthdateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Birthdate',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.foreground,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 16, color: AppTheme.mutedForeground),
          ],
        ),
        const SizedBox(height: 8),
        TextInputField(
          controller: TextEditingController(text: birthdate.isNotEmpty ? birthdate : 'Not set'),
          readOnly: true,
          enabled: false,
          prefixIcon: const Icon(Icons.calendar_today, size: 16, color: AppTheme.mutedForeground),
        ),
        const SizedBox(height: 8),
        Text(
          'Birthdate cannot be changed',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    String getGenderDisplay(String genderValue) {
      switch (genderValue) {
        case 'male':
          return 'Male';
        case 'female':
          return 'Female';
        case 'non-binary':
          return 'Non-binary';
        case 'prefer-not-to-say':
          return 'Prefer not to say';
        default:
          return 'Not set';
      }
    }

    IconData getGenderIcon(String genderValue) {
      switch (genderValue) {
        case 'male':
          return Icons.male;
        case 'female':
          return Icons.female;
        default:
          return Icons.person;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.foreground,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 14, color: AppTheme.mutedForeground),
          ],
        ),
        const SizedBox(height: 8),
        TextInputField(
          controller: TextEditingController(text: getGenderDisplay(gender)),
          readOnly: true,
          enabled: false,
          prefixIcon: Icon(
            getGenderIcon(gender),
            size: 20,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gender cannot be changed',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preferences Section
        _buildCompactPreferencesSection(),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        // Interests Section
        _buildCompactInterestsSection(),
      ],
    );
  }

  Widget _buildCompactPreferencesSection() {
    return SelectionField(
      title: 'My Preferences',
      description: 'Select categories to personalize your experience',
      selectedItemIds: selectedPreferences,
      getItemName: getPreferenceName,
      getItemEmoji: getPreferenceEmoji,
      onTap: onPreferencesTap,
      emptyMessage: 'No preferences selected',
    );
  }

  Widget _buildCompactInterestsSection() {
    return SelectionField(
      title: 'Interests',
      description: 'Select your interests to personalize your experience',
      selectedItemIds: selectedInterests,
      getItemName: (interest) => interest,
      getItemEmoji: getInterestEmoji,
      onTap: onInterestsTap,
      emptyMessage: 'No interests selected',
    );
  }

}
