import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class SocialMediaSection extends StatelessWidget {
  final String facebook;
  final String instagram;
  final String twitter;
  final String linkedin;
  final Function(String) onFacebookChanged;
  final Function(String) onInstagramChanged;
  final Function(String) onTwitterChanged;
  final Function(String) onLinkedinChanged;
  final VoidCallback onSave;

  const SocialMediaSection({
    super.key,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.linkedin,
    required this.onFacebookChanged,
    required this.onInstagramChanged,
    required this.onTwitterChanged,
    required this.onLinkedinChanged,
    required this.onSave,
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
                'Social Media',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Connect your social accounts to display on your profile',
                style: TextStyle(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Facebook
          _buildSocialInput(
            'Facebook',
            facebook,
            onFacebookChanged,
            'your_facebook_name',
            'https://facebook.com/your_facebook_name',
            const Color(0xFF1877F2),
            Icons.facebook,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Instagram
          _buildSocialInput(
            'Instagram',
            instagram,
            onInstagramChanged,
            '@your_instagram_name',
            'https://instagram.com/your_instagram_name or @username',
            Colors.pink,
            Icons.camera_alt,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Twitter
          _buildSocialInput(
            'Twitter',
            twitter,
            onTwitterChanged,
            '@Your_Twitter_Name',
            'https://twitter.com/Your_Twitter_Name or @username',
            const Color(0xFF1DA1F2),
            Icons.flutter_dash,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // LinkedIn
          _buildSocialInput(
            'LinkedIn',
            linkedin,
            onLinkedinChanged,
            'yourlinkedinname',
            'https://linkedin.com/in/yourlinkedinname',
            const Color(0xFF0A66C2),
            Icons.work,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialInput(
    String label,
    String value,
    Function(String) onChanged,
    String placeholder,
    String helperText,
    Color iconColor,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
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
        const SizedBox(height: 8),
        Text(
          helperText,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
