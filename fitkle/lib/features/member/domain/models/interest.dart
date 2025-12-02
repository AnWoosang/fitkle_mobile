/// 관심사 모델
class Interest {
  final String id;
  final String code;
  final String name;
  final String? emoji;
  final String categoryCode;
  final String categoryName;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Interest({
    required this.id,
    required this.code,
    required this.name,
    this.emoji,
    required this.categoryCode,
    required this.categoryName,
    required this.sortOrder,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String?,
      categoryCode: json['category_code'] as String,
      categoryName: json['category_name'] as String,
      sortOrder: json['sort_order'] as int,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'emoji': emoji,
      'category_code': categoryCode,
      'category_name': categoryName,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 표시명 (이모지 포함)
  String get displayName {
    if (emoji == null || emoji!.isEmpty) return name;
    return '$emoji $name';
  }
}
