# iOS 권한 관리 완벽 가이드

> iOS 앱에서 카메라, 갤러리, 알림 등의 권한이 어떻게 작동하는지 완벽 정리

## 목차
1. [핵심 개념: 권한은 누가 관리하나?](#핵심-개념-권한은-누가-관리하나)
2. [iOS 권한 시스템 아키텍처](#ios-권한-시스템-아키텍처)
3. [권한 종류별 상세 설명](#권한-종류별-상세-설명)
4. [권한 설정 방법](#권한-설정-방법)
5. [Flutter에서 권한 사용하기](#flutter에서-권한-사용하기)
6. [권한 상태 관리](#권한-상태-관리)
7. [실제 구현 예시 (Fitkle 프로젝트)](#실제-구현-예시-fitkle-프로젝트)
8. [문제 해결 가이드](#문제-해결-가이드)

---

## 핵심 개념: 권한은 누가 관리하나?

### 🎯 결론부터: iOS가 전부 관리합니다!

```
┌─────────────────────────────────────────────────────────────┐
│                    당신의 생각                                │
│  "DB에 저장? 앱 메타데이터? 어디에 저장되지?"                 │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    실제 답                                    │
│  iOS 시스템이 직접 관리! (앱은 읽기만 가능)                   │
│  위치: /var/mobile/Library/TCC/TCC.db (시스템 영역)          │
│  접근: 불가능! (루팅해도 제한적)                              │
└─────────────────────────────────────────────────────────────┘
```

### 권한 저장 위치

```
iOS 시스템 영역 (앱이 절대 접근 불가)
├─ TCC.db (Transparency, Consent, and Control)
│  ├─ 카메라 권한 상태
│  ├─ 사진 라이브러리 권한 상태
│  ├─ 위치 권한 상태
│  ├─ 마이크 권한 상태
│  ├─ 연락처 권한 상태
│  └─ 알림 권한 상태
│
└─ 각 앱별로 권한 상태 저장:
   - 앱 Bundle ID (com.example.fitkle)
   - 권한 타입 (Camera, Photos, Location...)
   - 권한 상태 (Authorized, Denied, NotDetermined)
   - 권한 요청 날짜
```

**핵심:**
- ❌ 앱의 DB에 저장되지 않음
- ❌ 앱 메타데이터에 저장되지 않음
- ✅ **iOS 시스템이 직접 관리**
- ✅ 앱은 "현재 상태 확인"만 가능
- ✅ 사용자만 설정 앱에서 변경 가능

---

## iOS 권한 시스템 아키텍처

### 전체 흐름도

```
┌─────────────────────────────────────────────────────────────┐
│ 1. 앱 개발자 (당신)                                           │
│    Info.plist에 권한 사용 이유 작성                           │
│    "카메라를 프로필 사진 촬영에 사용합니다"                    │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. 앱 실행 & 권한 요청                                        │
│    사용자가 "프로필 사진 변경" 버튼 클릭                      │
│    → 앱이 카메라 API 호출                                     │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. iOS 시스템 개입                                            │
│    "이미 권한 있나?" → TCC.db 확인                            │
│    ├─ 있음: 바로 카메라 열기                                  │
│    └─ 없음: 권한 요청 다이얼로그 표시                         │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. 사용자 선택                                                │
│    ┌──────────────────────────────────────────────┐         │
│    │ "Fitkle"이(가) 카메라에 접근하려고 합니다.   │         │
│    │ 카메라를 프로필 사진 촬영에 사용합니다       │         │
│    │                                              │         │
│    │      [허용 안 함]      [허용]                │         │
│    └──────────────────────────────────────────────┘         │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. iOS 시스템이 TCC.db에 저장                                 │
│    com.example.fitkle → Camera → Authorized (날짜/시간)      │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. 결과 반환                                                  │
│    앱 → "권한 있음" → 카메라 열기 → 사진 촬영                 │
└─────────────────────────────────────────────────────────────┘
```

### 권한 관리 주체 비교

| 항목 | iOS 시스템 | 앱 개발자 | 사용자 |
|------|-----------|----------|--------|
| 권한 저장 위치 | ✅ TCC.db | ❌ 접근 불가 | ❌ 몰라도 됨 |
| 권한 상태 관리 | ✅ 전담 | ❌ 읽기만 가능 | ❌ 변경만 가능 |
| 권한 요청 | ✅ 시스템 다이얼로그 표시 | ✅ API 호출로 트리거 | ✅ 허용/거부 선택 |
| 권한 변경 | ❌ 불가능 | ❌ 불가능 | ✅ 설정 앱에서만 |
| 권한 확인 | ✅ 저장된 상태 반환 | ✅ API로 조회 | ✅ 설정 앱에서 확인 |

---

## 권한 종류별 상세 설명

### 1. 카메라 (Camera)

**시스템 프레임워크:** AVFoundation
**Info.plist 키:** `NSCameraUsageDescription`
**권한 ID:** `kTCCServiceCamera`

```swift
// iOS 시스템 내부 동작 (개념적)
class AVCaptureDevice {
    static func requestAccess(for mediaType: AVMediaType,
                            completionHandler: @escaping (Bool) -> Void) {
        // 1. TCC.db 확인
        let currentStatus = TCC.checkAccess(bundleID: currentApp,
                                           service: .camera)

        // 2. 상태에 따른 처리
        switch currentStatus {
        case .authorized:
            completionHandler(true)
        case .denied:
            completionHandler(false)
        case .notDetermined:
            // 3. 시스템 다이얼로그 표시
            showSystemAlert(
                title: "앱 이름",
                message: Info.plist의 NSCameraUsageDescription,
                buttons: ["허용 안 함", "허용"]
            )
        }
    }
}
```

**저장되는 정보:**
```json
{
  "bundle_id": "com.example.fitkle",
  "service": "kTCCServiceCamera",
  "client": "Fitkle",
  "auth_value": 2,  // 0=Denied, 1=Unknown, 2=Authorized
  "auth_reason": 3,
  "last_modified": 1733123456,
  "prompt_count": 1
}
```

### 2. 사진 라이브러리 (Photos)

**시스템 프레임워크:** Photos
**Info.plist 키:**
- `NSPhotoLibraryUsageDescription` (읽기)
- `NSPhotoLibraryAddUsageDescription` (쓰기)

**권한 레벨:**
```
iOS 14+ 권한 옵션:
├─ Full Access (전체 접근)
│  └─ 모든 사진 접근 가능
│
├─ Selected Photos (선택한 사진만)
│  └─ 사용자가 선택한 사진만 접근
│
└─ None (접근 안 함)
   └─ 거부
```

**iOS의 권한 처리:**
```swift
// iOS 시스템이 관리하는 권한 상태
enum PHAuthorizationStatus {
    case notDetermined      // 아직 물어보지 않음
    case restricted         // 시스템 제한 (자녀 보호 등)
    case denied             // 사용자가 거부
    case authorized         // 전체 접근 허용
    case limited            // iOS 14+: 선택한 사진만 허용
}
```

### 3. 위치 (Location)

**시스템 프레임워크:** CoreLocation
**Info.plist 키:**
- `NSLocationWhenInUseUsageDescription` (앱 사용 중)
- `NSLocationAlwaysAndWhenInUseUsageDescription` (항상)

**권한 레벨:**
```
위치 권한 옵션:
├─ 정확한 위치 (Precise Location)
│  ├─ 앱 사용 중에만
│  └─ 항상
│
└─ 대략적인 위치 (Approximate Location) [iOS 14+]
   ├─ 앱 사용 중에만
   └─ 항상
```

### 4. 알림 (Notifications)

**시스템 프레임워크:** UserNotifications
**Info.plist 키:** 필요 없음 (자동)

**특징:**
```
알림 권한의 특별한 점:
✓ Info.plist 설명 불필요
✓ 앱에서 직접 시스템에 요청
✓ 권한 요청 = 알림 활성화

알림 옵션:
├─ 배너
├─ 알림 센터
├─ 소리
├─ 잠금 화면 표시
└─ 앱 배지
```

### 5. 마이크 (Microphone)

**시스템 프레임워크:** AVFoundation
**Info.plist 키:** `NSMicrophoneUsageDescription`
**권한 ID:** `kTCCServiceMicrophone`

### 6. 연락처 (Contacts)

**시스템 프레임워크:** Contacts
**Info.plist 키:** `NSContactsUsageDescription`
**권한 ID:** `kTCCServiceAddressBook`

### 7. 캘린더 (Calendar)

**시스템 프레임워크:** EventKit
**Info.plist 키:** `NSCalendarsUsageDescription`
**권한 ID:** `kTCCServiceCalendar`

### 권한 요청 순서 및 제한

```
iOS의 권한 요청 규칙:
1. 권한 요청은 앱당 1회만 자동 표시
2. 거부 후 재요청 = 자동으로 거부 (다이얼로그 안 뜸)
3. 사용자는 설정 앱에서만 변경 가능
4. 앱 재설치 시 = 권한 초기화 (NotDetermined)
5. iOS 업데이트 시 = 권한 유지
```

---

## 권한 설정 방법

### Step 1: Info.plist 설정 (필수!)

**위치:** `ios/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 카메라 권한 -->
    <key>NSCameraUsageDescription</key>
    <string>Fitkle needs access to your camera to take profile pictures</string>

    <!-- 사진 라이브러리 읽기 권한 -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Fitkle needs access to your photo library to select profile pictures</string>

    <!-- 사진 라이브러리 쓰기 권한 -->
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Fitkle needs permission to save photos to your library</string>

    <!-- 위치 권한 (앱 사용 중) -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Fitkle needs your location to show nearby events</string>

    <!-- 위치 권한 (항상) - 필요 시만 -->
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Fitkle needs your location to notify you about nearby events</string>

    <!-- 마이크 권한 -->
    <key>NSMicrophoneUsageDescription</key>
    <string>Fitkle needs access to your microphone for voice messages</string>

    <!-- 연락처 권한 -->
    <key>NSContactsUsageDescription</key>
    <string>Fitkle needs access to your contacts to invite friends</string>

    <!-- 캘린더 권한 -->
    <key>NSCalendarsUsageDescription</key>
    <string>Fitkle needs access to your calendar to add events</string>

    <!-- 알림 권한 - Info.plist 설정 불필요 (자동) -->
</dict>
</plist>
```

**설명 작성 가이드:**
```
✅ 좋은 설명:
"Fitkle needs access to your camera to take profile pictures"
→ 구체적이고 명확한 사용 목적

❌ 나쁜 설명:
"This app needs camera access"
→ 너무 막연함, App Store 심사 거부 가능

❌ 최악의 경우:
"" (빈 문자열)
→ 앱 크래시! (iOS가 강제 종료)
```

### Step 2: 권한 요청 타이밍

**좋은 타이밍:**
```dart
// ✅ 사용자가 기능을 사용하려고 할 때
void onTakePhotoButtonPressed() {
  // 이 순간에 권한 요청!
  _pickImageFromCamera();
}
```

**나쁜 타이밍:**
```dart
// ❌ 앱 시작하자마자 모든 권한 요청
void initState() {
  super.initState();
  _requestCameraPermission();    // ❌
  _requestPhotoPermission();     // ❌
  _requestLocationPermission();  // ❌
  _requestNotificationPermission(); // ❌
}
```

**권장 패턴:**
```
1. 기능 사용 직전에 요청
2. 권한이 필요한 이유를 먼저 설명 (선택)
3. 그 다음 실제 권한 요청
4. 거부 시 기능 제한 안내
```

---

## Flutter에서 권한 사용하기

### 방법 1: Flutter Plugin 자동 처리 (권장)

대부분의 Flutter 플러그인은 권한을 자동으로 처리합니다.

#### image_picker 예시 (Fitkle 프로젝트)

```dart
import 'package:image_picker/image_picker.dart';

// 카메라로 사진 촬영
Future<void> _pickImageFromCamera() async {
  final ImagePicker picker = ImagePicker();

  // 이 함수 호출 시:
  // 1. image_picker가 iOS AVFoundation 호출
  // 2. iOS가 TCC.db 확인
  // 3. 권한 없으면 자동으로 시스템 다이얼로그 표시
  // 4. 사용자 선택 후 결과 반환
  final XFile? image = await picker.pickImage(
    source: ImageSource.camera,  // 카메라 권한 필요
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );

  if (image != null) {
    print('사진 촬영 성공: ${image.path}');
  } else {
    // null = 사용자가 취소했거나 권한 거부
    print('사진 촬영 취소 또는 권한 없음');
  }
}

// 갤러리에서 사진 선택
Future<void> _pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,  // 사진 라이브러리 권한 필요
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );

  if (image != null) {
    print('사진 선택 성공: ${image.path}');
  }
}
```

**내부 동작 흐름:**
```
1. Dart 코드: picker.pickImage() 호출
       ↓
2. Flutter Engine: Platform Channel 통해 iOS 전달
       ↓
3. iOS Native 코드 (image_picker plugin):
   UIImagePickerController 또는 PHPickerViewController 사용
       ↓
4. iOS 시스템: TCC.db 확인
   - 권한 있음 → 바로 카메라/갤러리 열기
   - 권한 없음 → 시스템 다이얼로그 표시
       ↓
5. 사용자 선택 → iOS가 TCC.db 업데이트
       ↓
6. 결과를 Flutter로 반환
```

### 방법 2: 수동 권한 체크 (고급)

더 세밀한 제어가 필요할 때 `permission_handler` 패키지 사용:

```yaml
# pubspec.yaml
dependencies:
  permission_handler: ^11.0.0
```

```dart
import 'package:permission_handler/permission_handler.dart';

// 권한 상태 확인
Future<void> checkCameraPermission() async {
  // iOS TCC.db 조회
  final status = await Permission.camera.status;

  if (status.isGranted) {
    print('카메라 권한 있음');
  } else if (status.isDenied) {
    print('카메라 권한 거부됨 - 재요청 가능');
  } else if (status.isPermanentlyDenied) {
    print('카메라 권한 영구 거부 - 설정 앱으로 이동 필요');
  } else if (status.isRestricted) {
    print('카메라 권한 제한됨 (자녀 보호 등)');
  }
}

// 권한 요청
Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    // 권한 획득 성공
    _openCamera();
  } else if (status.isPermanentlyDenied) {
    // 설정 앱으로 이동 안내
    _showSettingsDialog();
  }
}

// 설정 앱으로 이동
Future<void> _showSettingsDialog() async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('카메라 권한 필요'),
      content: Text('프로필 사진을 촬영하려면 카메라 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();  // iOS 설정 앱 열기
            Navigator.pop(context);
          },
          child: Text('설정으로 이동'),
        ),
      ],
    ),
  );
}
```

### 방법 3: 알림 권한 (Firebase Cloud Messaging)

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;

  // iOS에서는 권한 요청 필요
  final settings = await messaging.requestPermission(
    alert: true,    // 배너 표시
    badge: true,    // 앱 배지 표시
    sound: true,    // 알림 소리
    provisional: false,  // iOS 12+: 임시 권한 (조용한 알림)
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('알림 권한 허용됨');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('임시 알림 권한 (조용한 알림만)');
  } else {
    print('알림 권한 거부됨');
  }
}
```

---

## 권한 상태 관리

### iOS의 권한 상태 (TCC.db에 저장)

```swift
// iOS 시스템이 관리하는 권한 상태
enum AuthorizationStatus {
    case notDetermined   // 0: 아직 물어보지 않음
    case restricted      // 1: 시스템 제한 (자녀 보호 등)
    case denied          // 2: 사용자가 거부
    case authorized      // 3: 허용됨
    case limited         // 4: 제한적 허용 (iOS 14+ 사진)
}
```

### 권한 생명주기

```
1단계: NotDetermined (초기 상태)
   ↓
   첫 권한 요청 시 → 시스템 다이얼로그 표시
   ↓
2단계: 사용자 선택
   ├─ "허용" → Authorized (영구 저장)
   └─ "허용 안 함" → Denied (영구 저장)
   ↓
3단계: 이후 동작
   ├─ Authorized: API 호출 시 바로 작동
   └─ Denied: API 호출 시 자동 거부 (다이얼로그 안 뜸!)
   ↓
4단계: 권한 변경 (사용자만 가능)
   iOS 설정 → Fitkle → 권한 토글
   ↓ (앱에서는 변경 불가능!)
   TCC.db 업데이트
```

### 앱에서 할 수 있는 것 vs 없는 것

| 작업 | 가능 여부 | 방법 |
|------|----------|------|
| 권한 상태 확인 | ✅ 가능 | `Permission.camera.status` |
| 권한 요청 (첫 요청) | ✅ 가능 | `Permission.camera.request()` |
| 권한 요청 (재요청) | ⚠️ 제한적 | 다이얼로그 안 뜸, 설정 앱 유도만 |
| 권한 강제 허용 | ❌ 불가능 | iOS가 절대 허용 안 함 |
| 권한 초기화 | ❌ 불가능 | 앱 삭제 후 재설치만 가능 |
| TCC.db 직접 수정 | ❌ 불가능 | 시스템 보호 영역 |
| 설정 앱 열기 | ✅ 가능 | `openAppSettings()` |

---

## 실제 구현 예시 (Fitkle 프로젝트)

### 현재 Fitkle 프로젝트 권한 설정

**Info.plist 확인:**
```xml
<!-- /ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>Fitkle needs access to your camera to take profile pictures</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Fitkle needs access to your photo library to select profile pictures</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Fitkle needs permission to save photos to your library</string>
```

✅ **현재 상태: 잘 설정되어 있음!**

### Fitkle의 권한 사용 흐름

**파일:** `lib/features/profile/presentation/screens/mixins/settings_modal_handlers.dart:70-105`

```dart
/// 카메라로 사진 촬영
Future<void> _pickImageFromCamera() async {
  try {
    print('🎥 [Camera] Starting camera picker...');

    // macOS와 웹에서는 카메라가 지원되지 않음
    if (!kIsWeb && Platform.isMacOS) {
      print('⚠️ [Camera] Camera not supported on macOS');
      ref.read(toastProvider.notifier).showError(
        'Camera is not supported on macOS. Please use "Choose from Gallery" instead.'
      );
      return;
    }

    final ImagePicker picker = ImagePicker();

    // 🔑 이 순간에 iOS 권한 체크!
    print('🎥 [Camera] Calling pickImage...');
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      print('🎥 [Camera] Starting upload process...');
      await _uploadAndUpdateAvatar(image.path);
    } else {
      print('🎥 [Camera] User cancelled camera');
    }
  } catch (e, stackTrace) {
    print('❌ [Camera] Error: $e');
    ref.read(toastProvider.notifier).showError('Failed to take photo: $e');
  }
}
```

**실제 사용자 경험:**
```
1. 사용자가 "프로필 사진 변경" 클릭
   ↓
2. "Take Photo" 버튼 클릭
   ↓
3. _pickImageFromCamera() 함수 실행
   ↓
4. picker.pickImage() 호출
   ↓
5. iOS 시스템 개입:
   ├─ TCC.db 확인
   ├─ 권한 없으면 → 다이얼로그 표시
   │  "Fitkle이(가) 카메라에 접근하려고 합니다."
   │  "Fitkle needs access to your camera to take profile pictures"
   │  [허용 안 함] [허용]
   └─ 권한 있으면 → 바로 카메라 열림
   ↓
6. 사용자 선택:
   ├─ "허용" → 카메라 열림 → 사진 촬영
   └─ "허용 안 함" → null 반환 → 에러 메시지
```

### 실제 코드 흐름 분석

```dart
// 1단계: 모달에서 옵션 선택
void openProfilePictureModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ProfilePictureModal(
      hasCurrentPhoto: avatarUrl != null && avatarUrl!.isNotEmpty,
      onTakePhoto: () {
        // 카메라 권한 필요!
        _pickImageFromCamera();
      },
      onChooseFromGallery: () {
        // 사진 라이브러리 권한 필요!
        _pickImageFromGallery();
      },
      onRemovePhoto: () {
        // 권한 불필요
        _removeProfilePhoto();
      },
    ),
  );
}

// 2단계: 이미지 선택 (권한 자동 처리)
final XFile? image = await picker.pickImage(
  source: ImageSource.camera,  // iOS가 자동으로 권한 체크
);

// 3단계: 결과 처리
if (image != null) {
  // 권한 OK → 업로드
  await _uploadAndUpdateAvatar(image.path);
} else {
  // null = 취소 또는 권한 거부
  // Fitkle에서는 별도 처리 안 함 (사용자가 알아서 판단)
}
```

### 개선 가능한 부분 (선택사항)

```dart
// 현재 코드: 권한 거부 시 명확한 피드백 없음
if (image == null) {
  print('🎥 [Camera] User cancelled camera');
  // 사용자가 취소한 건지, 권한이 없는 건지 구분 안 됨
}

// 개선안: permission_handler 사용
Future<void> _pickImageFromCamera() async {
  // 1. 권한 상태 먼저 확인
  final status = await Permission.camera.status;

  if (status.isPermanentlyDenied) {
    // 권한 영구 거부 → 설정 앱 안내
    _showPermissionDeniedDialog('카메라');
    return;
  }

  // 2. 권한 없으면 요청
  if (!status.isGranted) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      // 거부됨
      ref.read(toastProvider.notifier).showError('카메라 권한이 필요합니다');
      return;
    }
  }

  // 3. 권한 확보 → 카메라 열기
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.camera,
  );

  if (image != null) {
    await _uploadAndUpdateAvatar(image.path);
  }
}

void _showPermissionDeniedDialog(String permissionName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$permissionName 권한 필요'),
      content: Text('프로필 사진을 촬영하려면 $permissionName 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: Text('설정으로 이동'),
        ),
      ],
    ),
  );
}
```

---

## 권한과 데이터 저장의 차이

많은 개발자들이 혼동하는 부분을 명확히 정리:

### 권한 (Permission) - iOS 시스템 관리

```
┌─────────────────────────────────────────────────────────────┐
│ iOS 시스템 (TCC.db)                                           │
│ ✓ 카메라 접근 권한: Authorized                                │
│ ✓ 사진 라이브러리 권한: Limited (선택한 사진만)                │
│ ✓ 위치 권한: Denied                                          │
│ ✓ 알림 권한: Authorized                                       │
└─────────────────────────────────────────────────────────────┘

특징:
- iOS가 직접 관리 (앱은 읽기만)
- 앱 삭제 후 재설치 시 초기화
- 사용자만 설정 앱에서 변경 가능
- 하드웨어/시스템 리소스 접근 제어
```

### 앱 설정 (App Settings) - 앱이 관리

```
┌─────────────────────────────────────────────────────────────┐
│ Fitkle 앱 데이터 (Supabase DB 또는 로컬 저장소)               │
│ ✓ 알림 받을지 여부: true                                      │
│ ✓ 이메일 알림: false                                         │
│ ✓ 다크 모드: true                                            │
│ ✓ 언어: Korean                                               │
│ ✓ 연락처 공개 설정: Only Friends                             │
└─────────────────────────────────────────────────────────────┘

특징:
- 앱이 직접 관리 (DB 또는 SharedPreferences)
- 앱 삭제 시 함께 삭제
- 앱 내에서 자유롭게 변경 가능
- 비즈니스 로직 제어
```

### 실제 예시: Fitkle의 Contact Permission

**파일:** `lib/features/member/domain/enums/contact_permission.dart`

```dart
enum ContactPermission {
  everyone('EVERYONE', Icons.public, 'Everyone'),
  onlyFriends('ONLY_FRIENDS', Icons.people, 'Only Friends'),
  nobody('NOBODY', Icons.lock, 'Nobody');

  const ContactPermission(this.code, this.icon, this.name);

  final String code;
  final IconData icon;
  final String name;
}
```

**이것은 iOS 권한이 아닙니다!**
```
✅ 맞는 이해:
- Fitkle 앱 내부의 설정
- "내 연락처를 누구에게 보여줄지" 선택
- Supabase DB에 저장: member_settings.contact_permission
- 앱이 직접 관리하고 변경 가능

❌ 틀린 이해:
- iOS 시스템 권한이 아님
- iOS 연락처 앱 접근 권한과는 무관
- TCC.db와는 관련 없음
```

### 두 가지 권한의 조합 예시

```dart
// 시나리오: 친구에게 내 연락처 보여주기

// 1. iOS 시스템 권한 (TCC.db)
final contactPermission = await Permission.contacts.status;
if (!contactPermission.isGranted) {
  // iOS 연락처 앱 접근 권한 없음
  // → 연락처 동기화 불가
  return;
}

// 2. 앱 내부 설정 (Supabase DB)
final memberSettings = await getMemberSettings();
if (memberSettings.contactPermission == ContactPermission.nobody) {
  // 앱 설정에서 "아무에게도 보여주지 않음"
  // → 연락처 공유 안 함
  return;
}

// 두 조건 모두 만족 → 연락처 공유
shareContactWithFriend();
```

---

## 문제 해결 가이드

### 자주 발생하는 문제

#### 1. 앱 크래시: Info.plist 누락

**증상:**
```
Thread 1: signal SIGABRT
[access] This app has crashed because it attempted to access privacy-sensitive data
without a usage description.
```

**원인:** Info.plist에 Usage Description 누락

**해결:**
```xml
<!-- Info.plist에 추가 -->
<key>NSCameraUsageDescription</key>
<string>카메라 사용 목적 설명</string>
```

#### 2. 권한 다이얼로그가 안 뜸

**증상:** 두 번째 요청부터 다이얼로그가 표시되지 않음

**원인:** 이미 거부했기 때문 (iOS 정책)

**해결:**
```dart
// 권한 상태 확인 후 설정 앱 유도
final status = await Permission.camera.status;
if (status.isPermanentlyDenied) {
  // 설정 앱으로 이동
  openAppSettings();
}
```

#### 3. 권한 허용했는데도 작동 안 함

**원인 1:** 시뮬레이터 버그
```bash
# 시뮬레이터 권한 초기화
xcrun simctl privacy booted reset all com.example.fitkle
```

**원인 2:** 앱 재설치 필요
```bash
# 완전 삭제 후 재설치
flutter clean
cd ios && rm -rf Pods Podfile.lock
pod install
flutter run
```

**원인 3:** Info.plist 변경 후 빌드 안 함
```bash
# Clean build 필수
flutter clean
flutter build ios
```

#### 4. 사진 라이브러리 "선택한 사진만" 제한

**증상:** iOS 14+ 사용자가 "선택한 사진만" 선택

**해결:**
```dart
// 사용자에게 더 많은 사진 선택 유도
if (await Permission.photos.status == PermissionStatus.limited) {
  // iOS는 자동으로 "더 많은 사진 선택" UI 제공
  // 앱에서는 별도 처리 불필요
}
```

### 디버깅 팁

```bash
# 1. 현재 권한 상태 확인 (시뮬레이터)
xcrun simctl privacy booted grant photos com.example.fitkle
xcrun simctl privacy booted grant camera com.example.fitkle

# 2. 권한 초기화 (시뮬레이터)
xcrun simctl privacy booted reset all com.example.fitkle

# 3. TCC.db 직접 확인 (macOS에서만)
# ⚠️ iOS 실제 기기에서는 불가능!
sqlite3 ~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Library/TCC/TCC.db
SELECT * FROM access WHERE client = 'com.example.fitkle';

# 4. 실제 기기 로그 확인
# Xcode → Window → Devices and Simulators
# → 기기 선택 → Open Console
# 검색: "TCC" 또는 "permission"
```

---

## 베스트 프랙티스

### 1. 권한 요청 타이밍

```dart
// ✅ 좋은 예: 기능 사용 직전
void onEditProfilePicturePressed() {
  showModalBottomSheet(...);  // 사용자가 의도 표현
  // 모달에서 "카메라" 선택 시 → 권한 요청
}

// ❌ 나쁜 예: 앱 시작 시
void initState() {
  _requestAllPermissions();  // 너무 이름
}
```

### 2. 권한 설명 (선택사항)

```dart
// 시스템 권한 요청 전에 앱 자체 설명 표시
void requestCameraWithExplanation() async {
  // 1. 먼저 앱 자체 다이얼로그
  final shouldRequest = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('카메라 접근 권한'),
      content: Text('프로필 사진을 촬영하려면 카메라 접근 권한이 필요합니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('확인'),
        ),
      ],
    ),
  );

  // 2. 사용자 동의 시 실제 권한 요청
  if (shouldRequest == true) {
    final status = await Permission.camera.request();
    // ...
  }
}
```

### 3. 권한 거부 시 대응

```dart
void handlePermissionDenied(String permissionName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$permissionName 권한 필요'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            '이 기능을 사용하려면 $permissionName 권한이 필요합니다.\n\n'
            '설정 > Fitkle > $permissionName에서 권한을 허용해주세요.'
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('나중에'),
        ),
        ElevatedButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: Text('설정으로 이동'),
        ),
      ],
    ),
  );
}
```

### 4. 권한 상태 모니터링

```dart
// 앱이 백그라운드에서 돌아올 때 권한 상태 재확인
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 백그라운드에서 돌아옴
      // 사용자가 설정 앱에서 권한을 변경했을 수 있음
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;

    print('카메라 권한: $cameraStatus');
    print('사진 권한: $photosStatus');

    // 필요 시 UI 업데이트
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(...);
  }
}
```

---

## 요약

### 핵심 포인트

1. **권한은 iOS가 전부 관리**
   - TCC.db에 저장 (앱 접근 불가)
   - 앱은 권한 상태 "읽기"만 가능
   - 사용자만 설정 앱에서 변경 가능

2. **권한 != 앱 설정**
   - 권한: iOS 시스템 리소스 접근 제어
   - 앱 설정: 앱 내부 비즈니스 로직

3. **Info.plist는 필수**
   - Usage Description 없으면 앱 크래시
   - 명확하고 구체적인 설명 작성
   - App Store 심사 시 검토됨

4. **권한 요청은 1회만**
   - 첫 요청 시 다이얼로그 자동 표시
   - 거부 후 재요청 = 자동 거부
   - 설정 앱으로 유도 필요

5. **Flutter Plugin이 자동 처리**
   - image_picker, geolocator 등
   - 수동 제어 필요 시 permission_handler 사용

### 체크리스트

- [ ] Info.plist에 모든 권한 설명 추가
- [ ] 권한 요청 타이밍 최적화 (기능 사용 직전)
- [ ] 권한 거부 시 대응 로직 구현
- [ ] 설정 앱 연결 기능 구현
- [ ] 실제 기기에서 테스트 (시뮬레이터는 제한적)
- [ ] App Store 심사 대비 (명확한 권한 설명)

---

## 참고 자료

### Apple 공식 문서

- [Requesting Access to Protected Resources](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/requesting_access_to_protected_resources)
- [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency)
- [Info.plist Keys](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)

### Flutter 패키지

- [image_picker](https://pub.dev/packages/image_picker)
- [permission_handler](https://pub.dev/packages/permission_handler)
- [geolocator](https://pub.dev/packages/geolocator)
- [firebase_messaging](https://pub.dev/packages/firebase_messaging)

### 유용한 명령어

```bash
# 시뮬레이터 권한 부여
xcrun simctl privacy booted grant photos com.example.fitkle
xcrun simctl privacy booted grant camera com.example.fitkle
xcrun simctl privacy booted grant location com.example.fitkle

# 시뮬레이터 권한 초기화
xcrun simctl privacy booted reset all com.example.fitkle

# 실제 기기 Bundle ID 확인
cd ios && xcodebuild -showBuildSettings | grep PRODUCT_BUNDLE_IDENTIFIER
```

---

**문서 작성일:** 2024-12-02
**Fitkle 프로젝트 버전:** 1.0.0
**iOS 최소 지원 버전:** 15.0

질문이나 추가 설명이 필요하면 언제든 문의하세요!
