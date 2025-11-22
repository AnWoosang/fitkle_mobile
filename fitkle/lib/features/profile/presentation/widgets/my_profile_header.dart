import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';

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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withValues(alpha: 0.9),
                      AppTheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    profile['name'][0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Edit profile
                  },
                  child: Container(
                    width: 36,
                    height: 36,
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
                      border: Border.all(color: Colors.white, width: 3),
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
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name and nationality
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
              const SizedBox(width: 8),
              Tooltip(
                message: profile['nationalityFull'],
                child: Text(
                  profile['nationality'],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Username
          Text(
            '@${profile['name'].toLowerCase()}',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),

          // Social Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                context,
                Icons.email,
                profile['email'],
              ),
              const SizedBox(width: 12),
              _buildSocialButton(
                context,
                Icons.camera_alt,
                '@${profile['name'].toLowerCase()}',
              ),
              const SizedBox(width: 12),
              _buildSocialButton(
                context,
                Icons.alternate_email,
                '@${profile['name'].toLowerCase()}',
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
  ) {
    return Tooltip(
      message: value,
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          onCopyToast(icon == Icons.email ? '이메일' : '아이디');
        },
        child: Container(
          width: 36,
          height: 36,
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
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.primary,
          ),
        ),
      ),
    );
  }
}
