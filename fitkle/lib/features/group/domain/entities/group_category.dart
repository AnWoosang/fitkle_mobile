/// 그룹 카테고리 Code enum (타입 안정성)
///
/// 실제 이름과 이모지는 DB에서 관리되며,
/// 이 enum은 code 값에 대한 타입 체크 용도로만 사용됩니다.
enum GroupCategoryCode {
  all,
  social,
  fitness,
  language,
  tech,
  outdoor,
  food,
  music,
  arts,
  gaming,
  education,
  business,
  wellness,
  film,
  writing,
  hobbies,
  pets,
  family,
  community,
  dance,
  lgbtq,
  spirituality,
  faith,
  support,
  scifi,
  mysticism,
}

/// Deprecated: 이전 버전 호환성을 위해 유지
/// 새 코드는 Category 모델과 CategoryService를 사용하세요.
@Deprecated('Use Category model and CategoryService instead')
enum GroupCategory {
  all('all', 'All', '🌟'),
  cafe('cafe', 'Cafe Meetups', '☕'),
  food('food', 'Food & Dining', '🍽️'),
  outdoor('outdoor', 'Outdoor Activities', '🏞️'),
  culture('culture', 'Culture & Arts', '🎨'),
  sports('sports', 'Sports & Fitness', '⚽'),
  language('language', 'Language Exchange', '💬'),
  study('study', 'Study Groups', '📚'),
  gaming('gaming', 'Gaming', '🎮'),
  music('music', 'Music', '🎵'),
  tech('tech', 'Tech & Innovation', '💻'),
  social('social', 'Social & Networking', '🤝');

  final String key;
  final String label;
  final String emoji;

  const GroupCategory(this.key, this.label, this.emoji);

  static GroupCategory fromKey(String key) {
    return GroupCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => GroupCategory.all,
    );
  }

  static List<GroupCategory> get displayCategories {
    return GroupCategory.values;
  }

  bool matches(String? categoryKey) {
    if (this == GroupCategory.all) return true;
    return key == categoryKey;
  }
}
