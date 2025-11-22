import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/edit_profile_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/account_management_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/social_media_section.dart';
import 'package:fitkle/features/profile/presentation/widgets/settings/interests_section.dart';

enum SettingSection {
  editProfile,
  accountManagement,
  socialMedia,
  interests,
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingSection activeSection = SettingSection.editProfile;

  // Edit Profile State
  String name = 'Tony';
  String location = 'Seoul, Korea (South)';
  String birthdate = '10/02/1997';
  String gender = 'male';
  List<String> selectedGoals = [];

  // Account State
  String language = 'english';
  String contactPermission = 'anyone';

  // Social Media State
  String facebook = '';
  String instagram = '';
  String twitter = '';
  String linkedin = '';

  // Interests State
  List<String> selectedInterests = ['Outdoors', 'New In Town', 'Make New Friends', 'Fun Times', 'Social Networking'];
  String notificationRadius = '50 mi';
  String interestSearchQuery = '';

  final goals = [
    {'id': 'hobbies', 'label': 'Practice Hobbies', 'emoji': '🎨'},
    {'id': 'socialize', 'label': 'Socialize', 'emoji': '💬'},
    {'id': 'friends', 'label': 'Make Friends', 'emoji': '🙌'},
    {'id': 'network', 'label': 'Professionally Network', 'emoji': '💼'},
  ];

  final allInterestsWithEmoji = [
    {'label': 'Social', 'emoji': '🎉'},
    {'label': 'Professional Networking', 'emoji': '💼'},
    {'label': 'Book Club', 'emoji': '📚'},
    {'label': 'Adventure', 'emoji': '🏔️'},
    {'label': 'Writing and Publishing', 'emoji': '✍️'},
    {'label': 'Painting', 'emoji': '🎨'},
    {'label': 'Pickup Soccer', 'emoji': '⚽'},
    {'label': 'Social Justice', 'emoji': '✊'},
    {'label': 'Camping', 'emoji': '⛺'},
    {'label': 'Group Singing', 'emoji': '🎤'},
    {'label': 'Family Friendly', 'emoji': '👨‍👩‍👧'},
    {'label': 'Outdoor Fitness', 'emoji': '🏃'},
    {'label': 'Eco-Conscious', 'emoji': '🌱'},
    {'label': 'Stress Relief', 'emoji': '😌'},
    {'label': 'Game Night', 'emoji': '🎲'},
    {'label': 'Psychic', 'emoji': '🔮'},
    {'label': 'Vinyasa Yoga', 'emoji': '🧘'},
    {'label': 'Birds', 'emoji': '🦜'},
    {'label': 'Walking Tours', 'emoji': '🚶'},
    {'label': 'Guided Meditation', 'emoji': '🧘‍♀️'},
    {'label': 'New Parents', 'emoji': '👶'},
    {'label': 'Support', 'emoji': '🤝'},
    {'label': 'Breathing Meditation', 'emoji': '💨'},
    {'label': 'Roleplaying Games (RPGs)', 'emoji': '🎭'},
    {'label': 'Yoga', 'emoji': '🧘‍♂️'},
    {'label': 'International Travel', 'emoji': '✈️'},
    {'label': 'Soccer', 'emoji': '⚽'},
    {'label': 'Acoustic Music', 'emoji': '🎸'},
    {'label': 'Social Innovation', 'emoji': '💡'},
    {'label': 'Outdoors', 'emoji': '🌲'},
    {'label': 'New In Town', 'emoji': '🗺️'},
    {'label': 'Make New Friends', 'emoji': '👥'},
    {'label': 'Fun Times', 'emoji': '🎊'},
    {'label': 'Social Networking', 'emoji': '🤝'}
  ];

  void toggleGoal(String goalId) {
    setState(() {
      if (selectedGoals.contains(goalId)) {
        selectedGoals.remove(goalId);
      } else {
        selectedGoals.add(goalId);
      }
    });
  }

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  String getInterestEmoji(String label) {
    final interest = allInterestsWithEmoji.firstWhere(
      (i) => i['label'] == label,
      orElse: () => {'label': label, 'emoji': '⭐'},
    );
    return interest['emoji'] as String;
  }

  List<Map<String, String>> get filteredInterests {
    return allInterestsWithEmoji
        .where((interest) =>
            !selectedInterests.contains(interest['label']) &&
            (interest['label'] as String)
                .toLowerCase()
                .contains(interestSearchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            if (isMobile) _buildMobileHeader(),
            if (isMobile) _buildMobileTabs(),
            Expanded(
              child: isMobile
                  ? _buildMobileContent()
                  : _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '설정',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabs() {
    final menuItems = [
      {'id': SettingSection.editProfile, 'label': 'Edit Profile', 'icon': Icons.person},
      {'id': SettingSection.accountManagement, 'label': 'Account', 'icon': Icons.settings},
      {'id': SettingSection.socialMedia, 'label': 'Social Media', 'icon': Icons.share},
      {'id': SettingSection.interests, 'label': 'Interests', 'icon': Icons.favorite_border},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: menuItems.map((item) {
            final isActive = activeSection == item['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => activeSection = item['id'] as SettingSection),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 16,
                        color: isActive ? Colors.white : Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _renderContent(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildDesktopSidebar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: _renderContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopSidebar() {
    final menuItems = [
      {'id': SettingSection.editProfile, 'label': 'Edit Profile', 'icon': Icons.person},
      {'id': SettingSection.accountManagement, 'label': 'Account', 'icon': Icons.settings},
      {'id': SettingSection.socialMedia, 'label': 'Social Media', 'icon': Icons.share},
      {'id': SettingSection.interests, 'label': 'Interests', 'icon': Icons.favorite_border},
    ];

    return Container(
      width: 288,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppTheme.border),
        ),
      ),
      child: Column(
        children: [
          // Back button
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20, color: AppTheme.mutedForeground),
                  const SizedBox(width: 8),
                  Text(
                    '뒤로 가기',
                    style: TextStyle(
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: menuItems.map((item) {
                final isActive = activeSection == item['id'];
                return GestureDetector(
                  onTap: () => setState(() => activeSection = item['id'] as SettingSection),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.primary.withValues(alpha: 0.05) : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isActive ? AppTheme.primary : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 20,
                          color: isActive ? AppTheme.primary : AppTheme.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            color: isActive ? AppTheme.primary : AppTheme.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderContent() {
    switch (activeSection) {
      case SettingSection.editProfile:
        return EditProfileSection(
          name: name,
          location: location,
          birthdate: birthdate,
          gender: gender,
          selectedGoals: selectedGoals,
          goals: goals,
          onNameChanged: (value) => setState(() => name = value),
          onBirthdateChanged: (value) => setState(() => birthdate = value),
          onGenderChanged: (value) => setState(() => gender = value),
          onToggleGoal: toggleGoal,
        );
      case SettingSection.accountManagement:
        return AccountManagementSection(
          language: language,
          contactPermission: contactPermission,
          onLanguageChanged: (value) => setState(() => language = value),
          onContactPermissionChanged: (value) => setState(() => contactPermission = value),
          onChangePassword: () {},
          onDeleteAccount: () {},
        );
      case SettingSection.socialMedia:
        return SocialMediaSection(
          facebook: facebook,
          instagram: instagram,
          twitter: twitter,
          linkedin: linkedin,
          onFacebookChanged: (value) => setState(() => facebook = value),
          onInstagramChanged: (value) => setState(() => instagram = value),
          onTwitterChanged: (value) => setState(() => twitter = value),
          onLinkedinChanged: (value) => setState(() => linkedin = value),
          onSave: () {},
        );
      case SettingSection.interests:
        return InterestsSection(
          selectedInterests: selectedInterests,
          notificationRadius: notificationRadius,
          interestSearchQuery: interestSearchQuery,
          filteredInterests: filteredInterests,
          onToggleInterest: toggleInterest,
          onNotificationRadiusChanged: (value) => setState(() => notificationRadius = value),
          onSearchQueryChanged: (value) => setState(() => interestSearchQuery = value),
          onClearAllInterests: () => setState(() => selectedInterests.clear()),
          onSaveInterests: () {},
          getInterestEmoji: getInterestEmoji,
        );
    }
  }
}
