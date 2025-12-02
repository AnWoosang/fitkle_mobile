import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/member/domain/entities/account_setting_entity.dart';
import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart';
import 'package:fitkle/features/member/domain/services/account_setting_service.dart';

final accountSettingServiceProvider = Provider<AccountSettingService>((ref) {
  return AccountSettingService();
});

final accountSettingProvider = FutureProvider<AccountSettingEntity?>((ref) async {
  final service = ref.read(accountSettingServiceProvider);
  return service.getAccountSettings();
});

final accountSettingNotifierProvider =
    StateNotifierProvider<AccountSettingNotifier, AsyncValue<AccountSettingEntity?>>(
  (ref) => AccountSettingNotifier(ref),
);

class AccountSettingNotifier extends StateNotifier<AsyncValue<AccountSettingEntity?>> {
  AccountSettingNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadAccountSettings();
  }

  final Ref ref;

  Future<void> loadAccountSettings() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(accountSettingServiceProvider);
      final settings = await service.getAccountSettings();
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateLanguage(String language) async {
    try {
      final service = ref.read(accountSettingServiceProvider);
      final updatedSettings = await service.updateLanguage(language);
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateContactPermission(ContactPermission permission) async {
    try {
      final service = ref.read(accountSettingServiceProvider);
      final updatedSettings = await service.updateContactPermission(permission);
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateNotificationSettings({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? eventReminders,
    bool? groupUpdates,
    bool? newsletterSubscription,
  }) async {
    try {
      final service = ref.read(accountSettingServiceProvider);
      final updatedSettings = await service.updateNotificationSettings(
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        eventReminders: eventReminders,
        groupUpdates: groupUpdates,
        newsletterSubscription: newsletterSubscription,
      );
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUISettings({
    String? timezone,
    Theme? theme,
  }) async {
    try {
      final service = ref.read(accountSettingServiceProvider);
      final updatedSettings = await service.updateUISettings(
        timezone: timezone,
        theme: theme,
      );
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateAccountSettings({
    String? language,
    ContactPermission? contactPermission,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? eventReminders,
    bool? groupUpdates,
    bool? newsletterSubscription,
    String? timezone,
    Theme? theme,
  }) async {
    try {
      final service = ref.read(accountSettingServiceProvider);
      final updatedSettings = await service.updateAccountSettings(
        language: language,
        contactPermission: contactPermission,
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        eventReminders: eventReminders,
        groupUpdates: groupUpdates,
        newsletterSubscription: newsletterSubscription,
        timezone: timezone,
        theme: theme,
      );
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
