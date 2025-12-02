import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/member/presentation/providers/member_provider.dart';
import 'package:fitkle/features/member/presentation/providers/account_setting_provider.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/member/domain/models/preference.dart';
import 'package:fitkle/features/member/domain/services/interest_service.dart';
import 'package:fitkle/features/member/domain/services/preference_service.dart';
import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart' as app_theme;

/// 설정 화면의 상태 관리를 제공하는 Mixin
mixin SettingsStateManager<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // Edit Profile State
  String name = '';
  String location = '';
  String birthdate = '';
  String gender = '';
  String? avatarUrl;
  bool isNicknameEditable = true;
  DateTime? nicknameUpdatedAt;

  // Social Media State
  String email = '';
  String facebook = '';
  String instagram = '';
  String twitter = '';
  String linkedin = '';

  // Account Settings State
  String currentLanguage = 'en';
  ContactPermission currentContactPermission = ContactPermission.anyone;
  bool currentEmailNotifications = true;
  bool currentPushNotifications = true;
  bool currentEventReminders = true;
  bool currentGroupUpdates = true;
  bool currentNewsletterSubscription = false;
  app_theme.Theme currentTheme = app_theme.Theme.auto;

  // 세션 시작 시점의 Account Settings 값들
  String sessionStartLanguage = 'en';
  ContactPermission sessionStartContactPermission = ContactPermission.anyone;
  bool sessionStartEmailNotifications = true;
  bool sessionStartPushNotifications = true;
  bool sessionStartEventReminders = true;
  bool sessionStartGroupUpdates = true;
  bool sessionStartNewsletterSubscription = false;
  app_theme.Theme sessionStartTheme = app_theme.Theme.auto;

  // Interests State
  List<Interest> memberInterests = [];
  List<Interest> allInterests = [];
  String interestSearchQuery = '';
  Set<String> sessionStartInterestIds = {}; // 설정 화면 진입 시점의 interest IDs

  // Preferences State
  List<Preference> memberPreferences = [];
  List<Preference> allPreferences = [];
  String preferenceSearchQuery = '';
  Set<String> sessionStartPreferenceIds = {}; // 설정 화면 진입 시점의 preference IDs

  /// Interests 토글
  void toggleInterest(String interestId) {
    setState(() {
      final interest = allInterests.firstWhere((i) => i.id == interestId);
      if (memberInterests.any((i) => i.id == interestId)) {
        memberInterests.removeWhere((i) => i.id == interestId);
      } else {
        memberInterests.add(interest);
      }
    });
  }

  /// Interest Emoji 가져오기
  String getInterestEmoji(String interestId) {
    final interest = allInterests.firstWhere(
      (i) => i.id == interestId,
      orElse: () => allInterests.first,
    );
    return interest.emoji ?? '⭐';
  }

  /// Preferences 토글
  void togglePreference(String preferenceId) {
    setState(() {
      final preference = allPreferences.firstWhere((p) => p.id == preferenceId);
      if (memberPreferences.any((p) => p.id == preferenceId)) {
        memberPreferences.removeWhere((p) => p.id == preferenceId);
      } else {
        memberPreferences.add(preference);
      }
    });
  }

  /// 필터링된 Interests 목록
  List<Map<String, String>> get filteredInterests {
    final memberInterestIds = memberInterests.map((i) => i.id).toSet();
    return allInterests
        .where((interest) =>
            !memberInterestIds.contains(interest.id) &&
            interest.name.toLowerCase().contains(interestSearchQuery.toLowerCase()))
        .map((i) => {'id': i.id, 'label': i.name, 'emoji': i.emoji ?? ''})
        .toList();
  }

  /// 필터링된 Preferences 목록
  List<Map<String, String>> get filteredPreferences {
    final memberPreferenceIds = memberPreferences.map((p) => p.id).toSet();
    return allPreferences
        .where((pref) =>
            !memberPreferenceIds.contains(pref.id) &&
            pref.name.toLowerCase().contains(preferenceSearchQuery.toLowerCase()))
        .map((p) => {'id': p.id, 'name': p.name, 'emoji': p.emoji})
        .toList();
  }

  /// Account Settings 변경사항 확인
  bool get hasAccountSettingsChanges {
    return currentLanguage != sessionStartLanguage ||
        currentContactPermission != sessionStartContactPermission ||
        currentEmailNotifications != sessionStartEmailNotifications ||
        currentPushNotifications != sessionStartPushNotifications ||
        currentEventReminders != sessionStartEventReminders ||
        currentGroupUpdates != sessionStartGroupUpdates ||
        currentNewsletterSubscription != sessionStartNewsletterSubscription ||
        currentTheme != sessionStartTheme;
  }

  /// 멤버 데이터 로드
  Future<void> loadMemberData() async {
    final memberAsync = ref.read(currentMemberProvider);
    memberAsync.whenData((member) async {
      if (member != null && mounted) {
        // InterestService를 통해 전체 interest 목록 로드
        final interestService = InterestService();
        final interests = await interestService.getInterests();

        // PreferenceService를 통해 전체 preference 목록 로드
        final preferenceService = PreferenceService();
        final preferences = await preferenceService.getPreferences();

        if (mounted) {
          setState(() {
            // Edit Profile 데이터 로드
            name = member.nickname ?? member.displayName;
            location = member.location;
            gender = member.gender?.toDatabaseValue() ?? 'male';
            birthdate = member.birthdate != null
                ? '${member.birthdate!.month.toString().padLeft(2, '0')}/${member.birthdate!.day.toString().padLeft(2, '0')}/${member.birthdate!.year}'
                : '';
            avatarUrl = member.avatarUrl;

            // Nickname 수정 가능 여부 확인 (마지막 수정으로부터 30일 경과 여부)
            nicknameUpdatedAt = member.nicknameUpdatedAt;
            if (nicknameUpdatedAt != null) {
              final daysSinceUpdate = DateTime.now().difference(nicknameUpdatedAt!).inDays;
              isNicknameEditable = daysSinceUpdate >= 30;
            } else {
              isNicknameEditable = true;
            }

            // Social Media 데이터 로드
            email = member.emailHandle ?? '';
            facebook = member.facebookHandle ?? '';
            instagram = member.instagramHandle ?? '';
            twitter = member.twitterHandle ?? '';
            linkedin = member.linkedinHandle ?? '';

            // Interests 데이터 로드
            memberInterests = List.from(member.interests);
            allInterests = interests;
            // 설정 화면 진입 시점의 interest IDs 저장 (세션 시작 시점)
            sessionStartInterestIds = member.interests.map((i) => i.id).toSet();

            // Preferences 데이터 로드
            memberPreferences = List.from(member.preferences);
            allPreferences = preferences;
            // 설정 화면 진입 시점의 preference IDs 저장 (세션 시작 시점)
            sessionStartPreferenceIds = member.preferences.map((p) => p.id).toSet();
          });
        }
      }
    });

    // Account Settings 데이터 로드
    final accountSettingsAsync = ref.read(accountSettingNotifierProvider);
    accountSettingsAsync.whenData((accountSettings) {
      if (accountSettings != null && mounted) {
        setState(() {
          currentLanguage = accountSettings.language;
          currentContactPermission = accountSettings.contactPermission;
          currentEmailNotifications = accountSettings.emailNotifications;
          currentPushNotifications = accountSettings.pushNotifications;
          currentEventReminders = accountSettings.eventReminders;
          currentGroupUpdates = accountSettings.groupUpdates;
          currentNewsletterSubscription = accountSettings.newsletterSubscription;
          currentTheme = accountSettings.theme;

          // 세션 시작 시점 값 저장
          sessionStartLanguage = accountSettings.language;
          sessionStartContactPermission = accountSettings.contactPermission;
          sessionStartEmailNotifications = accountSettings.emailNotifications;
          sessionStartPushNotifications = accountSettings.pushNotifications;
          sessionStartEventReminders = accountSettings.eventReminders;
          sessionStartGroupUpdates = accountSettings.groupUpdates;
          sessionStartNewsletterSubscription = accountSettings.newsletterSubscription;
          sessionStartTheme = accountSettings.theme;
        });
      }
    });
  }

  /// Account Settings 저장
  Future<void> saveAccountSettings() async {
    if (!hasAccountSettingsChanges) return;

    try {
      await ref.read(accountSettingNotifierProvider.notifier).updateAccountSettings(
        language: currentLanguage,
        contactPermission: currentContactPermission,
        emailNotifications: currentEmailNotifications,
        pushNotifications: currentPushNotifications,
        eventReminders: currentEventReminders,
        groupUpdates: currentGroupUpdates,
        newsletterSubscription: currentNewsletterSubscription,
        theme: currentTheme,
      );

      // 저장 성공 시 세션 시작 값 업데이트
      setState(() {
        sessionStartLanguage = currentLanguage;
        sessionStartContactPermission = currentContactPermission;
        sessionStartEmailNotifications = currentEmailNotifications;
        sessionStartPushNotifications = currentPushNotifications;
        sessionStartEventReminders = currentEventReminders;
        sessionStartGroupUpdates = currentGroupUpdates;
        sessionStartNewsletterSubscription = currentNewsletterSubscription;
        sessionStartTheme = currentTheme;
      });
    } catch (e) {
      // 에러 처리는 조용히 무시 (사용자 경험을 위해)
    }
  }
}
