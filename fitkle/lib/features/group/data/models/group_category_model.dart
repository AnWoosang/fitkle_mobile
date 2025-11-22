import 'package:fitkle/features/group/domain/entities/group_category_entity.dart';

class GroupCategoryModel extends GroupCategoryEntity {
  const GroupCategoryModel({
    required super.id,
    required super.code,
    required super.name,
    super.emoji,
    super.sortOrder,
    super.isActive = true,
  });

  factory GroupCategoryModel.fromJson(Map<String, dynamic> json) {
    return GroupCategoryModel(
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

  factory GroupCategoryModel.fromEntity(GroupCategoryEntity entity) {
    return GroupCategoryModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      emoji: entity.emoji,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
    );
  }
}
