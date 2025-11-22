/// 관심사 모델
class Interest {
  final String id;
  final String code;
  final String nameKo;
  final String nameEn;
  final String? iconName;
  final int? sortOrder;
  final bool isActive;

  Interest({
    required this.id,
    required this.code,
    required this.nameKo,
    required this.nameEn,
    this.iconName,
    this.sortOrder,
    this.isActive = true,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as String,
      code: json['code'] as String,
      nameKo: json['name_ko'] as String,
      nameEn: json['name_en'] as String,
      iconName: json['icon_name'] as String?,
      sortOrder: json['sort_order'] as int?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name_ko': nameKo,
      'name_en': nameEn,
      'icon_name': iconName,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  /// 한국어 표시명 (이모지 포함)
  String get displayNameKo {
    if (iconName == null) return nameKo;
    return '${_getEmoji()} $nameKo';
  }

  /// 영어 표시명 (이모지 포함)
  String get displayNameEn {
    if (iconName == null) return nameEn;
    return '${_getEmoji()} $nameEn';
  }

  /// 아이콘 이모지 매핑
  String _getEmoji() {
    switch (code) {
      case 'WORKOUT':
        return '💪';
      case 'ART':
        return '🎨';
      case 'MUSIC':
        return '🎵';
      case 'READING':
        return '📚';
      case 'MOVIE':
        return '🎬';
      case 'COOKING':
        return '👨‍🍳';
      case 'TRAVEL':
        return '✈️';
      case 'TECHNOLOGY':
        return '💻';
      default:
        return '';
    }
  }
}
