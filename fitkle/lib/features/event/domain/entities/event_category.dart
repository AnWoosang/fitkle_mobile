/// 이벤트 카테고리 Code enum (타입 안정성)
///
/// 실제 이름과 이모지는 DB에서 관리되며,
/// 이 enum은 code 값에 대한 타입 체크 용도로만 사용됩니다.
enum EventCategoryCode {
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
enum EventCategory {
  all('ALL', 'All', '🌟'),
  cafe('CAFE', 'Cafe Meetups', '☕'),
  food('FOOD', 'Food & Dining', '🍽️'),
  outdoor('OUTDOOR', 'Outdoor Activities', '🏞️'),
  culture('CULTURE', 'Culture & Arts', '🎨'),
  sports('SPORTS', 'Sports & Fitness', '⚽'),
  language('LANGUAGE', 'Language Exchange', '💬'),
  study('STUDY', 'Study Groups', '📚'),
  gaming('GAMING', 'Gaming', '🎮'),
  music('MUSIC', 'Music', '🎵'),
  tech('TECH', 'Tech & Innovation', '💻'),
  social('SOCIAL', 'Social & Networking', '🤝');

  final String key;
  final String label;
  final String emoji;

  const EventCategory(this.key, this.label, this.emoji);

  static EventCategory fromKey(String key) {
    return EventCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => EventCategory.all,
    );
  }

  static List<EventCategory> get displayCategories {
    return EventCategory.values;
  }

  bool matches(String? categoryKey) {
    if (this == EventCategory.all) return true;
    return key == categoryKey;
  }
}
