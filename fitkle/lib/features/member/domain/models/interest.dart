/// 관심사 모델
class Interest {
  final String id;
  final String code;
  final String nameKo;
  final String nameEn;
  final String? emoji;
  final String categoryCode;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Interest({
    required this.id,
    required this.code,
    required this.nameKo,
    required this.nameEn,
    this.emoji,
    required this.categoryCode,
    required this.sortOrder,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as String,
      code: json['code'] as String,
      nameKo: json['name_ko'] as String,
      nameEn: json['name_en'] as String,
      emoji: json['emoji'] as String?,
      categoryCode: json['category_code'] as String,
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
      'name_ko': nameKo,
      'name_en': nameEn,
      'emoji': emoji,
      'category_code': categoryCode,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 한국어 표시명 (이모지 포함)
  String get displayNameKo {
    if (emoji == null || emoji!.isEmpty) return nameKo;
    return '$emoji $nameKo';
  }

  /// 영어 표시명 (이모지 포함)
  String get displayNameEn {
    if (emoji == null || emoji!.isEmpty) return nameEn;
    return '$emoji $nameEn';
  }
}
