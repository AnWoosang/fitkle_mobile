/// 앱 언어 설정 목록
enum Language {
  korean('ko', '한국어', 'Korean'),
  english('en', '영어', 'English'),
  japanese('ja', '일본어', 'Japanese'),
  chinese('zh', '중국어', 'Chinese'),
  spanish('es', '스페인어', 'Spanish'),
  french('fr', '프랑스어', 'French'),
  german('de', '독일어', 'German'),
  italian('it', '이탈리아어', 'Italian'),
  portuguese('pt', '포르투갈어', 'Portuguese'),
  russian('ru', '러시아어', 'Russian'),
  arabic('ar', '아랍어', 'Arabic'),
  hindi('hi', '힌디어', 'Hindi'),
  vietnamese('vi', '베트남어', 'Vietnamese'),
  thai('th', '태국어', 'Thai'),
  indonesian('id', '인도네시아어', 'Indonesian'),
  turkish('tr', '터키어', 'Turkish'),
  dutch('nl', '네덜란드어', 'Dutch'),
  polish('pl', '폴란드어', 'Polish'),
  swedish('sv', '스웨덴어', 'Swedish'),
  norwegian('no', '노르웨이어', 'Norwegian'),
  danish('da', '덴마크어', 'Danish'),
  finnish('fi', '핀란드어', 'Finnish'),
  greek('el', '그리스어', 'Greek'),
  czech('cs', '체코어', 'Czech'),
  hungarian('hu', '헝가리어', 'Hungarian'),
  romanian('ro', '루마니아어', 'Romanian'),
  ukrainian('uk', '우크라이나어', 'Ukrainian'),
  hebrew('he', '히브리어', 'Hebrew'),
  malay('ms', '말레이어', 'Malay'),
  tagalog('tl', '타갈로그어', 'Tagalog');

  const Language(this.code, this.name, this.nameEn);

  final String code;
  final String name;
  final String nameEn;

  /// 언어 코드로 언어 찾기
  static Language? fromCode(String code) {
    try {
      return Language.values.firstWhere((language) => language.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 언어 검색 (한글, 영문 모두 지원)
  static List<Language> search(String query) {
    if (query.isEmpty) return Language.values;

    final lowerQuery = query.toLowerCase();
    return Language.values.where((language) {
      final name = language.name.toLowerCase();
      final nameEn = language.nameEn.toLowerCase();
      return name.contains(lowerQuery) || nameEn.contains(lowerQuery);
    }).toList();
  }
}
