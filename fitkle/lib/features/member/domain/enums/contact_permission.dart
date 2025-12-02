import 'package:flutter/material.dart';

enum ContactPermission {
  anyone('ANYONE', Icons.public, 'Anyone'),
  eventOrGroupMembers('EVENT_OR_GROUP_MEMBERS', Icons.people, 'Event or Group Members'),
  eventMembersOnly('EVENT_MEMBERS_ONLY', Icons.event, 'Event Members Only'),
  groupMembersOnly('GROUP_MEMBERS_ONLY', Icons.group, 'Group Members Only'),
  none('NONE', Icons.block, 'No One');

  final String code;
  final IconData icon;
  final String name;

  const ContactPermission(this.code, this.icon, this.name);

  String toDatabaseValue() => code;

  static ContactPermission fromDatabaseValue(String value) {
    return ContactPermission.values.firstWhere(
      (permission) => permission.code == value,
      orElse: () => ContactPermission.anyone,
    );
  }

  static ContactPermission? fromDatabaseValueOrNull(String? value) {
    if (value == null) return null;
    try {
      return ContactPermission.values.firstWhere(
        (permission) => permission.code == value,
      );
    } catch (e) {
      return null;
    }
  }
}
