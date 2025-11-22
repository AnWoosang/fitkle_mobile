enum NewsCategory {
  announcement('ANNOUNCEMENT', 'Announcement'),
  information('INFORMATION', 'Information'),
  communication('COMMUNICATION', 'Communication');

  final String value;
  final String label;

  const NewsCategory(this.value, this.label);

  /// String 값으로부터 NewsCategory 생성
  static NewsCategory fromString(String value) {
    return NewsCategory.values.firstWhere(
      (category) => category.value.toLowerCase() == value.toLowerCase(),
      orElse: () => NewsCategory.announcement,
    );
  }
}
