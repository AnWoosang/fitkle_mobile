import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/edit_profile_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/account_management_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/social_media_section.dart';
import 'package:fitkle/features/profile/presentation/screens/mixins/settings_state_manager.dart';
import 'package:fitkle/features/profile/presentation/screens/mixins/settings_modal_handlers.dart';
import 'package:fitkle/features/member/presentation/providers/account_setting_provider.dart';
import 'package:fitkle/features/member/domain/enums/language.dart';
import 'package:fitkle/shared/providers/toast_provider.dart';

enum SettingSection {
  editProfile,
  accountManagement,
  socialMedia,
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin, SettingsStateManager, SettingsModalHandlers {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TabController 초기화
    _tabController = TabController(length: 3, vsync: this);

    // 탭 변경 리스너 추가 (탭 전환 시 Account Settings 자동 저장)
    _tabController.addListener(_onTabChanged);

    // 멤버 데이터 로드
    loadMemberData();
  }

  void _onTabChanged() {
    // Account 탭(index 1)에서 다른 탭으로 이동할 때 저장
    if (_tabController.previousIndex == 1 && _tabController.index != 1) {
      saveAccountSettings();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 페이지를 벗어날 때 Account Settings 저장
        await saveAccountSettings();

        if (context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header Bar
              _buildHeader(context),
              // Tab Bar
              _buildTabs(),
              // Tab View Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildEditProfileSection(),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildAccountManagementSection(),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildSocialMediaSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await saveAccountSettings();
                if (context.mounted) {
                  context.pop();
                }
              },
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              '설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.foreground,
              width: 2,
            ),
          ),
        ),
        labelColor: AppTheme.foreground,
        unselectedLabelColor: AppTheme.mutedForeground,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        dividerColor: AppTheme.border,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Edit Profile'),
          Tab(text: 'Account'),
          Tab(text: 'Social Media'),
        ],
      ),
    );
  }

  Widget _buildEditProfileSection() {
    final selectedPreferenceIds = memberPreferences.map((p) => p.id).toList();
    final selectedInterestNames = memberInterests.map((i) => i.name).toList();

    return EditProfileSection(
      name: name,
      location: location,
      birthdate: birthdate,
      gender: gender,
      avatarUrl: avatarUrl,
      isNicknameEditable: isNicknameEditable,
      selectedPreferences: selectedPreferenceIds,
      selectedInterests: selectedInterestNames,
      onNameChanged: (value) => setState(() => name = value),
      onNameTap: () => openNicknameModal(context),
      onAvatarTap: () => openProfilePictureModal(context),
      onPreferencesTap: () => openPreferencesModal(context),
      onInterestsTap: () => openInterestsModal(context),
      getPreferenceName: (id) {
        try {
          final preference = memberPreferences.firstWhere((p) => p.id == id);
          return preference.name;
        } catch (e) {
          return '';
        }
      },
      getPreferenceEmoji: (id) {
        try {
          final preference = memberPreferences.firstWhere((p) => p.id == id);
          return preference.emoji;
        } catch (e) {
          return '⭐';
        }
      },
      getInterestEmoji: (name) {
        try {
          final interest = allInterests.firstWhere((i) => i.name == name);
          return interest.emoji ?? '⭐';
        } catch (e) {
          return '⭐';
        }
      },
    );
  }

  Widget _buildAccountManagementSection() {
    final accountSettingsAsync = ref.watch(accountSettingNotifierProvider);

    return accountSettingsAsync.when(
      data: (accountSettings) {
        if (accountSettings == null) {
          return const Center(child: Text('Failed to load account settings'));
        }

        return AccountManagementSection(
          accountSettings: accountSettings.copyWith(
            language: currentLanguage,
            contactPermission: currentContactPermission,
            emailNotifications: currentEmailNotifications,
            pushNotifications: currentPushNotifications,
            eventReminders: currentEventReminders,
            groupUpdates: currentGroupUpdates,
            newsletterSubscription: currentNewsletterSubscription,
            theme: currentTheme,
          ),
          onLanguageChanged: (languageCode) async {
            // Check if there's a change
            if (languageCode == currentLanguage) {
              return;
            }

            setState(() => currentLanguage = languageCode);

            try {
              // 즉시 저장
              await ref.read(accountSettingNotifierProvider.notifier).updateLanguage(languageCode);
              if (mounted) {
                final language = Language.fromCode(languageCode);
                ref.read(toastProvider.notifier).showSuccess(
                  'Language changed to ${language?.nameEn ?? languageCode}'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update language');
              }
            }
          },
          onContactPermissionChanged: (permission) async {
            // Check if there's a change
            if (permission == currentContactPermission) {
              return;
            }

            setState(() => currentContactPermission = permission);

            try {
              // 즉시 저장
              await ref.read(accountSettingNotifierProvider.notifier).updateContactPermission(permission);
              if (mounted) {
                String permissionText = permission.toDatabaseValue().replaceAll('_', ' ');
                permissionText = permissionText[0].toUpperCase() + permissionText.substring(1);
                ref.read(toastProvider.notifier).showSuccess(
                  'Contact permission changed to $permissionText'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update contact permission');
              }
            }
          },
          onEmailNotificationsChanged: (value) async {
            setState(() => currentEmailNotifications = value);
            try {
              // 즉시 저장 (개별 필드만 업데이트)
              await ref.read(accountSettingNotifierProvider.notifier).updateNotificationSettings(
                emailNotifications: value,
              );
              if (mounted) {
                ref.read(toastProvider.notifier).showSuccess(
                  value ? 'Email notifications enabled' : 'Email notifications disabled'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update email notifications');
              }
            }
          },
          onPushNotificationsChanged: (value) async {
            setState(() => currentPushNotifications = value);
            try {
              // 즉시 저장 (개별 필드만 업데이트)
              await ref.read(accountSettingNotifierProvider.notifier).updateNotificationSettings(
                pushNotifications: value,
              );
              if (mounted) {
                ref.read(toastProvider.notifier).showSuccess(
                  value ? 'Push notifications enabled' : 'Push notifications disabled'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update push notifications');
              }
            }
          },
          onEventRemindersChanged: (value) async {
            setState(() => currentEventReminders = value);
            try {
              // 즉시 저장 (개별 필드만 업데이트)
              await ref.read(accountSettingNotifierProvider.notifier).updateNotificationSettings(
                eventReminders: value,
              );
              if (mounted) {
                ref.read(toastProvider.notifier).showSuccess(
                  value ? 'Event reminders enabled' : 'Event reminders disabled'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update event reminders');
              }
            }
          },
          onGroupUpdatesChanged: (value) async {
            setState(() => currentGroupUpdates = value);
            try {
              // 즉시 저장 (개별 필드만 업데이트)
              await ref.read(accountSettingNotifierProvider.notifier).updateNotificationSettings(
                groupUpdates: value,
              );
              if (mounted) {
                ref.read(toastProvider.notifier).showSuccess(
                  value ? 'Group updates enabled' : 'Group updates disabled'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update group updates');
              }
            }
          },
          onNewsletterSubscriptionChanged: (value) async {
            setState(() => currentNewsletterSubscription = value);
            try {
              // 즉시 저장 (개별 필드만 업데이트)
              await ref.read(accountSettingNotifierProvider.notifier).updateNotificationSettings(
                newsletterSubscription: value,
              );
              if (mounted) {
                ref.read(toastProvider.notifier).showSuccess(
                  value ? 'Newsletter subscription enabled' : 'Newsletter subscription disabled'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update newsletter subscription');
              }
            }
          },
          onThemeChanged: (theme) async {
            // Check if there's a change
            if (theme == currentTheme) {
              return;
            }

            setState(() => currentTheme = theme);

            try {
              // 즉시 저장
              await ref.read(accountSettingNotifierProvider.notifier).updateUISettings(theme: theme);
              if (mounted) {
                String themeText = theme.toDatabaseValue();
                themeText = themeText[0].toUpperCase() + themeText.substring(1);
                ref.read(toastProvider.notifier).showSuccess(
                  'Theme changed to $themeText'
                );
              }
            } catch (e) {
              if (mounted) {
                ref.read(toastProvider.notifier).showError('Failed to update theme');
              }
            }
          },
          onChangePassword: () {},
          onDeleteAccount: () {},
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSocialMediaSection() {
    return SocialMediaSection(
      email: email,
      facebook: facebook,
      instagram: instagram,
      twitter: twitter,
      linkedin: linkedin,
      onEmailTap: () => openEmailModal(context),
      onFacebookTap: () => openFacebookModal(context),
      onInstagramTap: () => openInstagramModal(context),
      onTwitterTap: () => openTwitterModal(context),
      onLinkedinTap: () => openLinkedinModal(context),
    );
  }
}
