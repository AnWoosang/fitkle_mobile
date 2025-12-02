enum Theme {
  light('LIGHT', 'Light'),
  dark('DARK', 'Dark'),
  auto('AUTO', 'Auto');

  final String code;
  final String name;

  const Theme(this.code, this.name);

  String toDatabaseValue() => code;

  static Theme fromDatabaseValue(String value) {
    return Theme.values.firstWhere(
      (theme) => theme.code == value,
      orElse: () => Theme.auto,
    );
  }

  static Theme? fromDatabaseValueOrNull(String? value) {
    if (value == null) return null;
    try {
      return Theme.values.firstWhere(
        (theme) => theme.code == value,
      );
    } catch (e) {
      return null;
    }
  }
}
