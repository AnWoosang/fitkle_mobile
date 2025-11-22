import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EditProfileSection extends StatelessWidget {
  final String name;
  final String location;
  final String birthdate;
  final String gender;
  final List<String> selectedGoals;
  final List<Map<String, String>> goals;
  final Function(String) onNameChanged;
  final Function(String) onBirthdateChanged;
  final Function(String) onGenderChanged;
  final Function(String) onToggleGoal;

  const EditProfileSection({
    super.key,
    required this.name,
    required this.location,
    required this.birthdate,
    required this.gender,
    required this.selectedGoals,
    required this.goals,
    required this.onNameChanged,
    required this.onBirthdateChanged,
    required this.onGenderChanged,
    required this.onToggleGoal,
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Name Field
          _buildNameField(),
          const SizedBox(height: 24),

          // Location
          _buildLocationField(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Private Information
          _buildPrivateInfoHeader(),
          const SizedBox(height: 24),

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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.pink[100],
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'T',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
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
              fontSize: 16,
              color: AppTheme.foreground,
            ),
            children: [
              TextSpan(text: 'Name'),
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: name),
          onChanged: onNameChanged,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey[50],
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
          'Your Location',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(location)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit address'),
        ),
      ],
    );
  }

  Widget _buildPrivateInfoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Private Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
            children: [
              TextSpan(text: 'This helps with recommendations. Gender and Birthdate '),
              TextSpan(
                text: 'will not',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: ' appear on your public profile.'),
            ],
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
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 16, color: AppTheme.mutedForeground),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: birthdate),
          onChanged: onBirthdateChanged,
          decoration: InputDecoration(
            hintText: 'MM/DD/YYYY',
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        if (birthdate.isNotEmpty) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => onBirthdateChanged(''),
            child: const Text('Clear'),
          ),
        ],
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Gender',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 16, color: AppTheme.mutedForeground),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: gender,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
            DropdownMenuItem(value: 'non-binary', child: Text('Non-binary')),
            DropdownMenuItem(value: 'prefer-not-to-say', child: Text('Prefer not to say')),
          ],
          onChanged: (value) => onGenderChanged(value!),
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are you looking for?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: goals.map((goal) {
            final isSelected = selectedGoals.contains(goal['id']);
            return GestureDetector(
              onTap: () => onToggleGoal(goal['id'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      goal['emoji'] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      goal['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppTheme.primary : AppTheme.foreground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.add,
                      size: 16,
                      color: isSelected ? AppTheme.primary : AppTheme.foreground,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
