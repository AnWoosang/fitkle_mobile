import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/user_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProfileHeader extends StatelessWidget {
  final Map<String, dynamic> profile;
  final Function(String) onCopyToast;

  const MyProfileHeader({
    super.key,
    required this.profile,
    required this.onCopyToast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Column(
        children: [
          // Settings and Logout buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildHeaderButton(
                Icons.settings,
                () => context.push('/settings'),
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(Icons.logout, () {
                // TODO: Logout
              }),
            ],
          ),
          const SizedBox(height: 24),

          // Avatar with edit button
          Stack(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: UserAvatar(
                  avatarUrl: profile['avatarUrl'],
                  size: 112,
                  backgroundColor: AppTheme.primary,
                  iconColor: Colors.white,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    context.push('/settings?tab=edit-profile');
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary,
                          AppTheme.primary.withValues(alpha: 0.9),
                        ],
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name and gender icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (profile['gender'] != null &&
                  profile['gender'] != 'Prefer Not to say') ...[
                const SizedBox(width: 8),
                Icon(
                  profile['gender'] == 'Male' ? Icons.male : Icons.female,
                  size: 24,
                  color: AppTheme.mutedForeground,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Social Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile['emailHandle'] != null)
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.solidEnvelope,
                  profile['emailHandle'],
                  '이메일',
                ),
              if (profile['emailHandle'] != null &&
                  (profile['instagramHandle'] != null ||
                   profile['twitterHandle'] != null ||
                   profile['linkedinHandle'] != null ||
                   profile['facebookHandle'] != null))
                const SizedBox(width: 12),
              if (profile['instagramHandle'] != null)
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.instagram,
                  profile['instagramHandle'],
                  '인스타그램',
                ),
              if (profile['instagramHandle'] != null &&
                  (profile['twitterHandle'] != null ||
                   profile['linkedinHandle'] != null ||
                   profile['facebookHandle'] != null))
                const SizedBox(width: 12),
              if (profile['twitterHandle'] != null)
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.twitter,
                  profile['twitterHandle'],
                  '트위터',
                ),
              if (profile['twitterHandle'] != null &&
                  (profile['linkedinHandle'] != null ||
                   profile['facebookHandle'] != null))
                const SizedBox(width: 12),
              if (profile['linkedinHandle'] != null)
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.linkedin,
                  profile['linkedinHandle'],
                  '링크드인',
                ),
              if (profile['linkedinHandle'] != null &&
                  profile['facebookHandle'] != null)
                const SizedBox(width: 12),
              if (profile['facebookHandle'] != null)
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.facebook,
                  profile['facebookHandle'],
                  '페이스북',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.muted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppTheme.foreground,
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Tooltip(
      message: value,
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          onCopyToast(label);
        },
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppTheme.muted.withValues(alpha: 0.5),
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
              icon,
              size: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
