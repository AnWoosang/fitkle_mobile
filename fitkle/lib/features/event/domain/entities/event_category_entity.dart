import 'package:equatable/equatable.dart';

class EventCategoryEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? emoji;
  final int? sortOrder;
  final bool isActive;

  const EventCategoryEntity({
    required this.id,
    required this.code,
    required this.name,
    this.emoji,
    this.sortOrder,
    this.isActive = true,
  });

  /// 이모지 포함 표시명
  String get displayName {
    if (emoji == null || emoji!.isEmpty) return name;
    return '$emoji $name';
  }

  @override
  List<Object?> get props => [id, code, name, emoji, sortOrder, isActive];
}
