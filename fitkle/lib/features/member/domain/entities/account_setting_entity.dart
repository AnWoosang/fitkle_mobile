import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart';

class AccountSettingEntity {
  final String id;
  final String memberId;
  final String language; // Country code (ISO 3166-1 alpha-2)
  final ContactPermission contactPermission;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool eventReminders;
  final bool groupUpdates;
  final bool newsletterSubscription;
  final String timezone;
  final Theme theme; // LIGHT, DARK, AUTO
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountSettingEntity({
    required this.id,
    required this.memberId,
    required this.language,
    required this.contactPermission,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.eventReminders,
    required this.groupUpdates,
    required this.newsletterSubscription,
    required this.timezone,
    required this.theme,
    required this.createdAt,
    required this.updatedAt,
  });

  AccountSettingEntity copyWith({
    String? id,
    String? memberId,
    String? language,
    ContactPermission? contactPermission,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? eventReminders,
    bool? groupUpdates,
    bool? newsletterSubscription,
    String? timezone,
    Theme? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountSettingEntity(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      language: language ?? this.language,
      contactPermission: contactPermission ?? this.contactPermission,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      eventReminders: eventReminders ?? this.eventReminders,
      groupUpdates: groupUpdates ?? this.groupUpdates,
      newsletterSubscription: newsletterSubscription ?? this.newsletterSubscription,
      timezone: timezone ?? this.timezone,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
