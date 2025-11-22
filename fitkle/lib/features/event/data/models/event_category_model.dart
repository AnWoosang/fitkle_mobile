import 'package:fitkle/features/event/domain/entities/event_category_entity.dart';

class EventCategoryModel extends EventCategoryEntity {
  const EventCategoryModel({
    required super.id,
    required super.code,
    required super.name,
    super.emoji,
    super.sortOrder,
    super.isActive = true,
  });

  factory EventCategoryModel.fromJson(Map<String, dynamic> json) {
    return EventCategoryModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String?,
      sortOrder: json['sort_order'] as int?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'emoji': emoji,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  factory EventCategoryModel.fromEntity(EventCategoryEntity entity) {
    return EventCategoryModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      emoji: entity.emoji,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
    );
  }
}
