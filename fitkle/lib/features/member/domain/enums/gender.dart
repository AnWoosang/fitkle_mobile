/// 성별 enum
enum Gender {
  male('MALE', '남성', 'Male'),
  female('FEMALE', '여성', 'Female'),
  preferNotToSay('PREFER_NOT_TO_SAY', '밝히고 싶지 않음', 'Prefer not to say');

  const Gender(this.code, this.name, this.nameEn);

  final String code;
  final String name;
  final String nameEn;

  /// 코드로 성별 찾기
  static Gender? fromCode(String code) {
    try {
      return Gender.values.firstWhere((gender) => gender.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 데이터베이스에 저장할 값 반환
  /// PREFER_NOT_TO_SAY는 null로 처리 (DB는 MALE/FEMALE만 허용)
  String? toDatabaseValue() {
    if (this == Gender.preferNotToSay) {
      return null;
    }
    return code;
  }

  /// 데이터베이스 값으로부터 Gender 생성
  static Gender? fromDatabaseValue(String? value) {
    if (value == null) {
      return Gender.preferNotToSay;
    }
    return fromCode(value);
  }
}
