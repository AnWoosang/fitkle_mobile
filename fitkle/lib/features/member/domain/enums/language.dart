/// 앱 언어 설정 목록
enum Language {
  korean('KO', '한국어', 'Korean'),
  english('EN', '영어', 'English'),
  japanese('JA', '일본어', 'Japanese'),
  chinese('ZH', '중국어', 'Chinese'),
  spanish('ES', '스페인어', 'Spanish'),
  french('FR', '프랑스어', 'French'),
  german('DE', '독일어', 'German'),
  italian('IT', '이탈리아어', 'Italian'),
  portuguese('PT', '포르투갈어', 'Portuguese'),
  russian('RU', '러시아어', 'Russian'),
  arabic('AR', '아랍어', 'Arabic'),
  hindi('HI', '힌디어', 'Hindi'),
  vietnamese('VI', '베트남어', 'Vietnamese'),
  thai('TH', '태국어', 'Thai'),
  indonesian('ID', '인도네시아어', 'Indonesian'),
  turkish('TR', '터키어', 'Turkish'),
  dutch('NL', '네덜란드어', 'Dutch'),
  polish('PL', '폴란드어', 'Polish'),
  swedish('SV', '스웨덴어', 'Swedish'),
  norwegian('NO', '노르웨이어', 'Norwegian'),
  danish('DA', '덴마크어', 'Danish'),
  finnish('FI', '핀란드어', 'Finnish'),
  greek('EL', '그리스어', 'Greek'),
  czech('CS', '체코어', 'Czech'),
  hungarian('HU', '헝가리어', 'Hungarian'),
  romanian('RO', '루마니아어', 'Romanian'),
  ukrainian('UK', '우크라이나어', 'Ukrainian'),
  hebrew('HE', '히브리어', 'Hebrew'),
  malay('MS', '말레이어', 'Malay'),
  tagalog('TL', '타갈로그어', 'Tagalog');

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
