/// 사용자 관심사 Code enum (타입 안정성)
///
/// 실제 이름과 아이콘은 DB에서 관리되며,
/// 이 enum은 code 값에 대한 타입 체크 용도로만 사용됩니다.
///
/// 참고: 관심사 데이터는 Interest 모델과 InterestService를 통해 관리됩니다.
enum MemberInterestCode {
  workout,
  art,
  music,
  reading,
  movie,
  cooking,
  travel,
  technology,
}
