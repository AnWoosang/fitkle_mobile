# Interests Database Schema

## interests 테이블 정의

사용자 관심사 마스터 데이터를 저장하는 테이블입니다.

### 테이블 구조

| Column Name | Data Type | Nullable | Default | Description |
|-------------|-----------|----------|---------|-------------|
| id | uuid | NO | gen_random_uuid() | 고유 식별자 (Primary Key) |
| code | varchar | NO | - | 관심사 코드 (예: SOCIAL, OUTDOORS) |
| name_ko | varchar | NO | - | 한국어 이름 |
| name_en | varchar | NO | - | 영어 이름 |
| emoji | varchar | YES | - | 이모지 아이콘 |
| sort_order | integer | NO | 0 | 정렬 순서 |
| is_active | boolean | NO | true | 활성화 여부 |
| created_at | timestamptz | NO | now() | 생성 일시 |
| updated_at | timestamptz | NO | now() | 수정 일시 |

---

## member_interests 테이블 정의

사용자와 관심사 간의 다대다 관계를 저장하는 조인 테이블입니다.

### 테이블 구조

| Column Name | Data Type | Nullable | Default | Description |
|-------------|-----------|----------|---------|-------------|
| user_id | uuid | NO | - | 사용자 ID (Foreign Key → auth.users) |
| interest_id | uuid | NO | - | 관심사 ID (Foreign Key → interests) |
| created_at | timestamptz | NO | now() | 생성 일시 |

### Foreign Keys
- `user_id` → `auth.users.id`
- `interest_id` → `interests.id`

---

## 현재 관심사 목록 (34개)

| # | Code | 한국어 | English | Emoji |
|---|------|--------|---------|-------|
| 1 | SOCIAL | 소셜 | Social | 🎉 |
| 2 | PROFESSIONAL_NETWORKING | 프로페셔널 네트워킹 | Professional Networking | 💼 |
| 3 | BOOK_CLUB | 북 클럽 | Book Club | 📚 |
| 4 | ADVENTURE | 어드벤처 | Adventure | 🏔️ |
| 5 | WRITING_AND_PUBLISHING | 글쓰기와 출판 | Writing and Publishing | ✍️ |
| 6 | PAINTING | 페인팅 | Painting | 🎨 |
| 7 | PICKUP_SOCCER | 픽업 축구 | Pickup Soccer | ⚽ |
| 8 | SOCIAL_JUSTICE | 사회 정의 | Social Justice | ✊ |
| 9 | CAMPING | 캠핑 | Camping | ⛺ |
| 10 | GROUP_SINGING | 그룹 노래 | Group Singing | 🎤 |
| 11 | FAMILY_FRIENDLY | 가족 친화적 | Family Friendly | 👨‍👩‍👧 |
| 12 | OUTDOOR_FITNESS | 아웃도어 피트니스 | Outdoor Fitness | 🏃 |
| 13 | ECO_CONSCIOUS | 친환경 | Eco-Conscious | 🌱 |
| 14 | STRESS_RELIEF | 스트레스 해소 | Stress Relief | 😌 |
| 15 | GAME_NIGHT | 게임 나이트 | Game Night | 🎲 |
| 16 | PSYCHIC | 심령 | Psychic | 🔮 |
| 17 | VINYASA_YOGA | 빈야사 요가 | Vinyasa Yoga | 🧘 |
| 18 | BIRDS | 새 | Birds | 🦜 |
| 19 | WALKING_TOURS | 워킹 투어 | Walking Tours | 🚶 |
| 20 | GUIDED_MEDITATION | 가이드 명상 | Guided Meditation | 🧘‍♀️ |
| 21 | NEW_PARENTS | 신규 부모 | New Parents | 👶 |
| 22 | SUPPORT | 서포트 | Support | 🤝 |
| 23 | BREATHING_MEDITATION | 호흡 명상 | Breathing Meditation | 💨 |
| 24 | ROLEPLAYING_GAMES | 롤플레잉 게임 | Roleplaying Games (RPGs) | 🎭 |
| 25 | YOGA | 요가 | Yoga | 🧘‍♂️ |
| 26 | INTERNATIONAL_TRAVEL | 해외 여행 | International Travel | ✈️ |
| 27 | SOCCER | 축구 | Soccer | ⚽ |
| 28 | ACOUSTIC_MUSIC | 어쿠스틱 음악 | Acoustic Music | 🎸 |
| 29 | SOCIAL_INNOVATION | 소셜 이노베이션 | Social Innovation | 💡 |
| 30 | OUTDOORS | 아웃도어 | Outdoors | 🌲 |
| 31 | NEW_IN_TOWN | 새로운 도시 | New In Town | 🗺️ |
| 32 | MAKE_NEW_FRIENDS | 새 친구 만들기 | Make New Friends | 👥 |
| 33 | FUN_TIMES | 재미있는 시간 | Fun Times | 🎊 |
| 34 | SOCIAL_NETWORKING | 소셜 네트워킹 | Social Networking | 🤝 |

---

## 참고사항

- 관심사 데이터는 설정 페이지(`settings_screen.dart`)의 `allInterestsWithEmoji` 리스트를 기반으로 생성되었습니다.
- 각 사용자는 `member_interests` 테이블을 통해 여러 개의 관심사를 가질 수 있습니다.
- 현재 시스템에서는 각 사용자당 최소 6개의 관심사를 권장합니다.
