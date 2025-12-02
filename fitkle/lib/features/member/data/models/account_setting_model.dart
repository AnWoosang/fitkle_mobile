import 'package:fitkle/features/member/domain/entities/account_setting_entity.dart';
import 'package:fitkle/features/member/domain/enums/contact_permission.dart';
import 'package:fitkle/features/member/domain/enums/theme.dart';

class AccountSettingModel extends AccountSettingEntity {
  const AccountSettingModel({
    required super.id,
    required super.memberId,
    required super.language,
    required super.contactPermission,
    required super.emailNotifications,
    required super.pushNotifications,
    required super.eventReminders,
    required super.groupUpdates,
    required super.newsletterSubscription,
    required super.timezone,
    required super.theme,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AccountSettingModel.fromJson(Map<String, dynamic> json) {
    return AccountSettingModel(
      id: json['id'] as String,
      memberId: json['member_id'] as String,
      language: json['language'] as String,
      contactPermission: ContactPermission.fromDatabaseValue(
        json['contact_permission'] as String,
      ),
      emailNotifications: json['email_notifications'] as bool,
      pushNotifications: json['push_notifications'] as bool,
      eventReminders: json['event_reminders'] as bool,
      groupUpdates: json['group_updates'] as bool,
      newsletterSubscription: json['newsletter_subscription'] as bool,
      timezone: json['timezone'] as String,
      theme: Theme.fromDatabaseValue(json['theme'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'language': language,
      'contact_permission': contactPermission.toDatabaseValue(),
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'event_reminders': eventReminders,
      'group_updates': groupUpdates,
      'newsletter_subscription': newsletterSubscription,
      'timezone': timezone,
      'theme': theme.toDatabaseValue(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  AccountSettingModel copyWith({
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
    return AccountSettingModel(
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

  AccountSettingEntity toEntity() {
    return AccountSettingEntity(
      id: id,
      memberId: memberId,
      language: language,
      contactPermission: contactPermission,
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      eventReminders: eventReminders,
      groupUpdates: groupUpdates,
      newsletterSubscription: newsletterSubscription,
      timezone: timezone,
      theme: theme,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
