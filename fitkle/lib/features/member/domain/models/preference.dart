/// 선호 카테고리 모델
class Preference {
  final String id;
  final String code;
  final String name;
  final String emoji;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Preference({
    required this.id,
    required this.code,
    required this.name,
    required this.emoji,
    required this.sortOrder,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
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
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 이모지 포함 표시명
  String get displayName {
    if (emoji.isEmpty) return name;
    return '$emoji $name';
  }
}
