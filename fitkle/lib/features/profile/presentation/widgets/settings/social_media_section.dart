import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaSection extends StatelessWidget {
  final String email;
  final String facebook;
  final String instagram;
  final String twitter;
  final String linkedin;
  final VoidCallback onEmailTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onInstagramTap;
  final VoidCallback onTwitterTap;
  final VoidCallback onLinkedinTap;

  const SocialMediaSection({
    super.key,
    required this.email,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.linkedin,
    required this.onEmailTap,
    required this.onFacebookTap,
    required this.onInstagramTap,
    required this.onTwitterTap,
    required this.onLinkedinTap,
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
                  fontSize: 12
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Email
          _buildSocialField(
            'Email',
            email,
            onEmailTap,
            'Your contact email (can be same as login email or a different one)',
            const Color(0xFF6B7280),
            FontAwesomeIcons.envelope,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Facebook
          _buildSocialField(
            'Facebook',
            facebook,
            onFacebookTap,
            'https://facebook.com/your_facebook_name',
            const Color(0xFF1877F2),
            FontAwesomeIcons.facebook,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Instagram
          _buildSocialField(
            'Instagram',
            instagram,
            onInstagramTap,
            'https://instagram.com/your_instagram_name or @username',
            Colors.pink,
            FontAwesomeIcons.instagram,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Twitter
          _buildSocialField(
            'Twitter',
            twitter,
            onTwitterTap,
            'https://twitter.com/Your_Twitter_Name or @username',
            const Color(0xFF1DA1F2),
            FontAwesomeIcons.twitter,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // LinkedIn
          _buildSocialField(
            'LinkedIn',
            linkedin,
            onLinkedinTap,
            'https://linkedin.com/in/yourlinkedinname',
            const Color(0xFF0A66C2),
            FontAwesomeIcons.linkedin,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialField(
    String label,
    String value,
    VoidCallback onTap,
    String helperText,
    Color iconColor,
    IconData faIcon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  faIcon,
                  size: 16,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.foreground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          helperText,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isNotEmpty ? value : 'Not set',
                    style: TextStyle(
                      fontSize: 14,
                      color: value.isNotEmpty ? AppTheme.foreground : AppTheme.mutedForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
