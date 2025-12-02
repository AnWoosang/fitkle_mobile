import 'package:fitkle/features/member/data/models/account_setting_model.dart';
import 'package:fitkle/features/member/domain/entities/account_setting_entity.dart';
import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSettingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get account settings for the current user
  Future<AccountSettingEntity?> getAccountSettings() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('account_settings')
          .select()
          .eq('member_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return AccountSettingModel.fromJson(response).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  /// Get account settings for a specific user
  Future<AccountSettingEntity?> getAccountSettingsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('account_settings')
          .select()
          .eq('member_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return AccountSettingModel.fromJson(response).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  /// Update account settings
  Future<AccountSettingEntity> updateAccountSettings({
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
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final Map<String, dynamic> updates = {};

      if (language != null) updates['language'] = language;
      if (contactPermission != null) {
        updates['contact_permission'] = contactPermission.toDatabaseValue();
      }
      if (emailNotifications != null) {
        updates['email_notifications'] = emailNotifications;
      }
      if (pushNotifications != null) {
        updates['push_notifications'] = pushNotifications;
      }
      if (eventReminders != null) updates['event_reminders'] = eventReminders;
      if (groupUpdates != null) updates['group_updates'] = groupUpdates;
      if (newsletterSubscription != null) {
        updates['newsletter_subscription'] = newsletterSubscription;
      }
      if (timezone != null) updates['timezone'] = timezone;
      if (theme != null) updates['theme'] = theme.toDatabaseValue();

      final response = await _supabase
          .from('account_settings')
          .update(updates)
          .eq('member_id', userId)
          .select()
          .single();

      return AccountSettingModel.fromJson(response).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  /// Update language setting
  Future<AccountSettingEntity> updateLanguage(String language) async {
    return updateAccountSettings(language: language);
  }

  /// Update contact permission setting
  Future<AccountSettingEntity> updateContactPermission(
    ContactPermission permission,
  ) async {
    return updateAccountSettings(contactPermission: permission);
  }

  /// Update notification settings
  Future<AccountSettingEntity> updateNotificationSettings({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? eventReminders,
    bool? groupUpdates,
    bool? newsletterSubscription,
  }) async {
    return updateAccountSettings(
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      eventReminders: eventReminders,
      groupUpdates: groupUpdates,
      newsletterSubscription: newsletterSubscription,
    );
  }

  /// Update UI settings
  Future<AccountSettingEntity> updateUISettings({
    String? timezone,
    Theme? theme,
  }) async {
    return updateAccountSettings(
      timezone: timezone,
      theme: theme,
    );
  }

  /// Create default account settings (usually called by trigger, but kept for manual usage)
  Future<AccountSettingEntity> createDefaultAccountSettings(String userId) async {
    try {
      final response = await _supabase
          .from('account_settings')
          .insert({
            'member_id': userId,
          })
          .select()
          .single();

      return AccountSettingModel.fromJson(response).toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
