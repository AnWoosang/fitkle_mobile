import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/member/domain/entities/account_setting_entity.dart';
import 'package:fitkle/features/member/domain/enums/language.dart';
import 'package:fitkle/features/member/domain/enums/country.dart';
import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart' as app_theme;
import 'package:fitkle/shared/widgets/dialogs/language_selection_modal.dart';

class AccountManagementSection extends StatefulWidget {
  final AccountSettingEntity accountSettings;
  final Future<void> Function(String) onLanguageChanged;
  final Future<void> Function(ContactPermission) onContactPermissionChanged;
  final Future<void> Function(bool) onEmailNotificationsChanged;
  final Future<void> Function(bool) onPushNotificationsChanged;
  final Future<void> Function(bool) onEventRemindersChanged;
  final Future<void> Function(bool) onGroupUpdatesChanged;
  final Future<void> Function(bool) onNewsletterSubscriptionChanged;
  final Future<void> Function(app_theme.Theme) onThemeChanged;
  final VoidCallback onChangePassword;
  final VoidCallback onDeleteAccount;

  const AccountManagementSection({
    super.key,
    required this.accountSettings,
    required this.onLanguageChanged,
    required this.onContactPermissionChanged,
    required this.onEmailNotificationsChanged,
    required this.onPushNotificationsChanged,
    required this.onEventRemindersChanged,
    required this.onGroupUpdatesChanged,
    required this.onNewsletterSubscriptionChanged,
    required this.onThemeChanged,
    required this.onChangePassword,
    required this.onDeleteAccount,
  });

  @override
  State<AccountManagementSection> createState() => _AccountManagementSectionState();
}

class _AccountManagementSectionState extends State<AccountManagementSection> {

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
                'Account Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Manage your account preferences and security',
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

          // Phone Verification Section
          _buildPhoneVerificationSection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Language Section
          _buildLanguageSection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Theme Section
          _buildThemeSection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Privacy Section
          _buildPrivacySection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Notifications Section
          _buildNotificationsSection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Security Section
          _buildSecuritySection(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Delete Account
          _buildDeleteAccountSection(),
        ],
      ),
    );
  }

  Widget _buildPhoneVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_android, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Verification',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Verify your phone number',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your phone',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'For identity verification',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                onPressed: () {
                  // TODO: Phone verification API integration
                },
                icon: Icons.verified_user,
                label: 'Verify',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguagePicker() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageSelectionModal(
        currentLanguageCode: widget.accountSettings.language,
        onSave: (languageCode) {
          widget.onLanguageChanged(languageCode);
        },
      ),
    );
  }

  Widget _buildLanguageSection() {
    final currentLanguage = Language.fromCode(widget.accountSettings.language);
    final currentCountry = Country.fromCode(widget.accountSettings.language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.language, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Choose your preferred language',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Language selector button
        InkWell(
          onTap: _showLanguagePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: Row(
              children: [
                Text(
                  currentCountry?.flag ?? '🌐',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    currentLanguage?.nameEn ?? 'Select language',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.brightness_6, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Choose your preferred theme',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: app_theme.Theme.values.map((theme) {
            final isSelected = theme == widget.accountSettings.theme;
            IconData icon;
            switch (theme) {
              case app_theme.Theme.light:
                icon = Icons.light_mode;
                break;
              case app_theme.Theme.dark:
                icon = Icons.dark_mode;
                break;
              case app_theme.Theme.auto:
                icon = Icons.brightness_auto;
                break;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => widget.onThemeChanged(theme),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.grey[800]! : AppTheme.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          color: isSelected ? Colors.grey[800] : AppTheme.mutedForeground,
                          size: 22,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          theme.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? Colors.grey[800] : AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Control who can reach out to you',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        Column(
          children: ContactPermission.values.map((permission) {
            final isSelected = permission == widget.accountSettings.contactPermission;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => widget.onContactPermissionChanged(permission),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.grey[800]! : AppTheme.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        permission.icon,
                        color: isSelected ? Colors.grey[800] : AppTheme.mutedForeground,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          permission.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? Colors.grey[800] : AppTheme.mutedForeground,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: Colors.grey[800], size: 18),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Manage your notification preferences',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildSwitchTile(
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          icon: Icons.email,
          value: widget.accountSettings.emailNotifications,
          onChanged: widget.onEmailNotificationsChanged,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive push notifications on your device',
          icon: Icons.phone_iphone,
          value: widget.accountSettings.pushNotifications,
          onChanged: widget.onPushNotificationsChanged,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'Event Reminders',
          subtitle: 'Get reminded about upcoming events',
          icon: Icons.event,
          value: widget.accountSettings.eventReminders,
          onChanged: widget.onEventRemindersChanged,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'Group Updates',
          subtitle: 'Receive updates from your groups',
          icon: Icons.group,
          value: widget.accountSettings.groupUpdates,
          onChanged: widget.onGroupUpdatesChanged,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'News letter',
          subtitle: 'Stay updated with our newsletter',
          icon: Icons.mail_outline,
          value: widget.accountSettings.newsletterSubscription,
          onChanged: widget.onNewsletterSubscriptionChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? AppTheme.primary : Colors.grey[400],
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value ? AppTheme.foreground : Colors.grey[600],
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: (newValue) async {
                // 알림을 끌 때만 다이얼로그 표시
                if (value && !newValue) {
                  final confirmed = await _showDisableNotificationDialog(title);
                  if (confirmed) {
                    onChanged(newValue);
                  }
                } else {
                  // 알림을 킬 때는 바로 적용
                  onChanged(newValue);
                }
              },
              activeColor: AppTheme.primary,
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDisableNotificationDialog(String notificationType) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Disable Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You will no longer receive $notificationType from Fitkle. Are you sure you want to turn off these notifications?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mutedForeground,
              fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Turn Off',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Keep your account secure',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You'll be signed out from other sessions",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                onPressed: widget.onChangePassword,
                icon: Icons.lock,
                label: 'Change',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_off, size: 16, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Permanently remove your account',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete your account',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'All your data will be permanently deleted and cannot be recovered',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                onPressed: widget.onDeleteAccount,
                icon: Icons.person_off,
                label: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
