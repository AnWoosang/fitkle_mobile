# Supabase Storage 설정 가이드

프로필 사진 업로드 기능은 Supabase Storage의 `fitkle` 버킷을 사용합니다.

## 1. Storage 구조

```
fitkle (버킷)
└── member/
    └── [member_uuid]/
        └── avatar/
            └── [timestamp].jpg
```

## 2. 이미 설정된 항목 ✅

- ✅ `fitkle` 버킷 생성 완료
- ✅ Public 버킷으로 설정 완료
- ✅ RLS 정책 설정 완료

## 3. RLS 정책 (이미 적용됨)

현재 적용된 Row Level Security 정책:

### 📥 INSERT 정책
```sql
CREATE POLICY "Insert image by Authenticated user"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'fitkle'
  AND (
    -- group, event 폴더는 기존 로직 유지
    (storage.foldername(name))[1] IN ('group', 'event')
    OR
    -- member 폴더는 본인의 UUID만 허용
    (
      (storage.foldername(name))[1] = 'member'
      AND (storage.foldername(name))[2] = auth.uid()::text
    )
  )
);
```
**설명**: 인증된 사용자는 `member/[본인UUID]/` 경로에만 업로드 가능

### ✏️ UPDATE 정책
```sql
CREATE POLICY "Update own image by Authenticated user"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'fitkle'
  AND (
    owner = auth.uid()
    OR
    (
      (storage.foldername(name))[1] = 'member'
      AND (storage.foldername(name))[2] = auth.uid()::text
    )
  )
);
```
**설명**: 본인이 업로드한 파일 또는 본인의 member 폴더만 수정 가능

### 🗑️ DELETE 정책
```sql
CREATE POLICY "Delete own image by Authenticated user"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'fitkle'
  AND (
    owner = auth.uid()
    OR
    (
      (storage.foldername(name))[1] = 'member'
      AND (storage.foldername(name))[2] = auth.uid()::text
    )
  )
);
```
**설명**: 본인이 업로드한 파일 또는 본인의 member 폴더만 삭제 가능

### 👁️ SELECT 정책
```sql
CREATE POLICY "Anyone can view fitkle bucket files"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'fitkle');
```
**설명**: 누구나 fitkle 버킷의 파일을 조회 가능 (공개)

## 4. 코드 동작 방식

### 업로드 프로세스
1. **사용자가 사진 선택/촬영**
   - ImagePicker로 이미지 선택
   - 최대 1024x1024 크기로 리사이즈
   - 이미지 품질 85%로 압축

2. **Storage 업로드**
   ```dart
   StorageService.uploadProfileImage(filePath, userId)
   ```
   - 경로: `member/{userId}/avatar/{timestamp}.{확장자}`
   - 버킷: `fitkle`
   - 업로드 성공 시 공개 URL 반환
   - **예시**: `https://xxx.supabase.co/storage/v1/object/public/fitkle/member/abc-123/avatar/1234567890.jpg`

3. **DB 업데이트**
   ```dart
   MemberService.updateAvatar(memberId, imageUrl)
   ```
   - `members` 테이블의 `avatar_url` 필드 업데이트
   - 실패 시 롤백은 하지 않음 (Storage는 이미 업로드됨)

4. **UI 새로고침**
   - Provider 무효화로 자동 새로고침

### 교체 프로세스
새 사진 업로드 시 이전 사진을 자동으로 삭제:
```dart
StorageService.replaceProfileImage(filePath, userId, oldImageUrl)
```
1. 새 이미지를 `member/{userId}/avatar/` 경로에 업로드
2. 업로드 성공 시 이전 이미지를 Storage에서 삭제
3. 새 이미지 URL 반환

### 삭제 프로세스
1. Storage에서 이미지 파일 삭제
2. DB의 `avatar_url`을 빈 문자열로 업데이트

## 5. 보안 및 권한

### 🔒 RLS 정책이 보장하는 것
- ✅ 사용자는 **본인의 UUID 폴더**에만 업로드 가능
- ✅ 다른 사용자의 `member/` 폴더에는 접근 불가
- ✅ 본인이 업로드한 파일만 수정/삭제 가능
- ✅ 모든 사용자가 프로필 사진을 조회할 수 있음 (public)

### 경로 예시
```
✅ 허용: member/abc-123-def/avatar/1234567890.jpg  (본인 UUID)
❌ 거부: member/xyz-789-ghi/avatar/1234567890.jpg  (다른 사용자 UUID)
```

## 6. 트러블슈팅

### 업로드 실패
- ✅ `fitkle` 버킷이 존재하는지 확인
- ✅ 사용자가 로그인되어 있는지 확인 (authenticated)
- ✅ 파일 크기가 제한을 초과하지 않는지 확인
- ✅ 네트워크 연결 확인
- ✅ RLS 정책 확인 - 본인의 UUID 폴더에 업로드하고 있는지 확인

### 이미지가 표시되지 않음
- ✅ Storage URL이 올바른지 확인
- ✅ 버킷이 public인지 확인
- ✅ 파일이 실제로 업로드되었는지 Supabase Dashboard에서 확인
- ✅ 경로가 `member/{userId}/avatar/` 형식인지 확인

### 권한 에러 (403 Forbidden)
- ✅ 사용자가 로그인되어 있는지 확인
- ✅ auth.uid()와 업로드 경로의 UUID가 일치하는지 확인
- ✅ RLS 정책이 올바르게 적용되었는지 확인
