enum EventType {
  online('ONLINE', 'Online'),
  offline('OFFLINE', 'Offline');

  final String value;
  final String label;

  const EventType(this.value, this.label);

  /// String 값으로부터 EventType 생성
  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (type) => type.value.toUpperCase() == value.toUpperCase(),
      orElse: () => EventType.offline, // 기본값: 오프라인
    );
  }
}
