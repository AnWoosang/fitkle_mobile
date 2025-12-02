# iOS 버전 관리 완벽 가이드

> Fitkle 프로젝트의 iOS 배포를 위한 버전 관리 종합 문서

## 목차
1. [핵심 개념 이해](#핵심-개념-이해)
2. [현재 프로젝트 설정](#현재-프로젝트-설정)
3. [iOS 플랫폼 아키텍처](#ios-플랫폼-아키텍처)
4. [버전 선택 전략](#버전-선택-전략)
5. [의존성 관리](#의존성-관리)
6. [배포 체크리스트](#배포-체크리스트)
7. [문제 해결 가이드](#문제-해결-가이드)

---

## 핵심 개념 이해

### 1. iOS 버전의 3가지 의미

```
┌─────────────────────────────────────────────────────────────┐
│ Deployment Target (배포 타겟) - 가장 중요!                   │
│ ✓ 앱이 실행 가능한 최소 iOS 버전                             │
│ ✓ 이 버전 이하에서는 설치 자체가 불가능                      │
│ ✓ App Store에서도 보이지 않음                                │
│ ✓ 현재 설정: iOS 15.0                                        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ App Version (앱 버전)                                        │
│ ✓ 사용자에게 보이는 버전 번호 (1.0.0)                        │
│ ✓ Build Number: 내부 빌드 번호 (+1)                          │
│ ✓ 업데이트 시마다 증가                                        │
│ ✓ 현재 설정: 1.0.0+1                                         │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ SDK Version (개발 환경 SDK)                                  │
│ ✓ Xcode가 제공하는 iOS SDK 버전                              │
│ ✓ 최신 기능 개발 시 필요                                      │
│ ✓ 빌드 시점의 최신 iOS 기능 사용 가능                         │
└─────────────────────────────────────────────────────────────┘
```

### 2. 버전 작동 방식

**예시: iOS 15.0으로 설정한 경우**

| iOS 버전 | 설치 가능? | 실행 가능? | 비고 |
|----------|-----------|-----------|------|
| iOS 14.x | ❌ 불가능 | ❌ 불가능 | App Store에서 아예 안 보임 |
| iOS 15.0 | ✅ 가능 | ✅ 가능 | 최소 지원 버전 |
| iOS 15.5 | ✅ 가능 | ✅ 가능 | |
| iOS 16.0 | ✅ 가능 | ✅ 가능 | |
| iOS 17.0 | ✅ 가능 | ✅ 가능 | |
| iOS 18.0 | ✅ 가능 | ✅ 가능 | 최신 버전 |

**핵심:** iOS 18 SDK로 개발해도 iOS 15에서 실행 가능!

---

## 현재 프로젝트 설정

### pubspec.yaml
```yaml
version: 1.0.0+1
# ├─ 1.0.0: 사용자용 버전 (CFBundleShortVersionString)
# └─ +1: 빌드 번호 (CFBundleVersion)
```

**위치:** `fitkle/pubspec.yaml:19`

### Podfile
```ruby
# 최소 지원 버전 선언
platform :ios, '15.0'

# CocoaPods 의존성도 iOS 15.0 이상 강제
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
```

**위치:** `fitkle/ios/Podfile:2, 43-48`

### Info.plist
```xml
<!-- 앱 버전 (pubspec.yaml에서 자동 생성) -->
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>

<!-- 빌드 번호 (pubspec.yaml에서 자동 생성) -->
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
```

**위치:** `fitkle/ios/Runner/Info.plist:19-24`

---

## iOS 플랫폼 아키텍처

### iOS 생태계 구조

```
┌─────────────────────────────────────────────────────────────┐
│                      Apple (iOS 플랫폼)                      │
│  ✓ iOS SDK 제공                                              │
│  ✓ UIKit, Foundation, CoreLocation 등 프레임워크             │
│  ✓ 모든 앱의 기반 (플랫폼 = 메인 라이브러리)                  │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              Third-Party SDKs (외부 라이브러리)              │
│  ✓ Google Maps SDK                                           │
│  ✓ Firebase SDK                                              │
│  ✓ Supabase SDK                                              │
│                                                              │
│  이들은 모두 iOS SDK 위에서 작동:                             │
│  ├─ iOS의 UIView를 사용해서 지도 표시                         │
│  ├─ iOS의 Network API로 데이터 통신                           │
│  └─ iOS의 보안 정책 준수                                      │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              Flutter/Dart (크로스 플랫폼 레이어)              │
│  ✓ Flutter Engine (Dart → Native 변환)                      │
│  ✓ Platform Channels (Dart ↔ iOS 통신)                      │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Plugins                           │
│  ✓ google_maps_flutter (Dart → Google Maps SDK)             │
│  ✓ image_picker (Dart → iOS UIImagePickerController)        │
│  ✓ supabase_flutter (Dart → Supabase SDK)                   │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Your Flutter App                          │
│  ✓ Fitkle 앱 코드 (Dart)                                     │
└─────────────────────────────────────────────────────────────┘
```

### 왜 외부 API도 iOS 버전에 종속되는가?

**예시: Google Maps Flutter**

```
1. iOS 14에서 Apple이 새로운 API 추가
   └─ CLLocationManager의 정확도 권한 시스템 변경

2. Google Maps SDK 업데이트 (v7.0)
   ├─ "우리도 새 권한 시스템 지원할게!"
   └─ BUT, iOS 14+ 기능 사용 → 최소 버전 iOS 14 요구

3. google_maps_flutter 업데이트 (v2.10)
   ├─ Google Maps SDK v7.0 사용
   └─ 따라서 iOS 14+ 필수!

4. 당신의 앱
   ├─ google_maps_flutter 사용
   └─ 어쩔 수 없이 iOS 14+ 필수!
```

**핵심 원리:**
```
iOS (플랫폼) = 집의 기초 공사
   ↓
외부 SDK = 집 위에 지은 가구
   ↓
Flutter Plugin = 가구를 사용하는 도구
   ↓
당신의 앱 = 최종 거주자

→ 기초 공사(iOS)가 낡으면 새 가구(외부 SDK)를 들일 수 없음!
```

### iOS SDK의 역할

```swift
// iOS SDK가 제공하는 것들 (예시)

// 1. UI 컴포넌트
import UIKit
- UIView, UIButton, UILabel 등
- 모든 화면 요소의 기본

// 2. 위치 서비스
import CoreLocation
- GPS, 위치 권한 관리
- Google Maps도 이걸 사용함!

// 3. 네트워크
import Foundation
- URLSession (HTTP 통신)
- Supabase도 이걸 사용함!

// 4. 카메라/사진
import Photos
import AVFoundation
- 사진 선택, 카메라 촬영
- image_picker가 이걸 사용함!
```

**외부 SDK는 iOS SDK의 기능을 조합해서 만든 것:**
```
Google Maps SDK = CoreLocation + MapKit + UIView + Network
Firebase SDK = Foundation + UserNotifications + Security
Supabase SDK = Foundation + URLSession + Keychain
```

---

## 버전 선택 전략

### iOS 버전별 시장 점유율 (2024년 기준)

| iOS 버전 | 출시 | 점유율 | 누적 | 주요 기기 | 권장 |
|----------|------|--------|------|----------|------|
| iOS 18 | 2024.09 | ~25% | 25% | iPhone 15, 16 | ⚠️ 너무 높음 |
| iOS 17 | 2023.09 | ~35% | 60% | iPhone 12-15 | ✅ 최신 기능 |
| iOS 16 | 2022.09 | ~20% | 80% | iPhone 8-14 | ✅ 안정적 |
| **iOS 15** | **2021.09** | **~15%** | **95%** | **iPhone 6s-13** | **🎯 최적** |
| iOS 14 | 2020.09 | ~3% | 98% | iPhone 6s-12 | ⚠️ 레거시 |
| iOS 13 | 2019.09 | ~1% | 99% | iPhone 6s-11 | ❌ 구형 |
| iOS 12 이하 | ~2019 | ~1% | 100% | iPhone 6 이하 | ❌ 지원 중단 |

### 의사결정 프레임워크

```
┌─────────────────────────────────────────────────────────────┐
│ 1단계: 기술적 제약 확인                                       │
│ Q: 사용하는 라이브러리의 최소 버전은?                         │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 2단계: 타겟 사용자 분석                                       │
│ Q: 주 타겟이 최신 기기인가, 구형 기기도 많은가?               │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 3단계: 개발 리소스 고려                                       │
│ Q: 구버전 테스트할 여유가 있는가?                             │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 4단계: 최종 결정                                              │
│ → 기술 제약 + 비즈니스 목표 균형점 찾기                       │
└─────────────────────────────────────────────────────────────┘
```

### Fitkle 프로젝트 분석

**현재 의존성 제약:**
```
google_maps_flutter  → iOS 14+ 필수
image_picker         → iOS 12+ 필수
supabase_flutter     → iOS 13+ 필수 (추정)
cached_network_image → iOS 11+ 필수 (추정)
───────────────────────────────────────
최소 가능 버전: iOS 14
현재 설정: iOS 15 ✅
```

**iOS 15 선택 근거:**
1. ✅ 기술 제약: google_maps_flutter가 iOS 14+ 요구
2. ✅ 시장 커버리지: 95% 사용자 지원
3. ✅ 개발 효율: iOS 15+ 기능 자유롭게 사용
4. ✅ Apple 권장: iOS 15는 안정적인 기준선
5. ✅ 유지보수: 구버전 대응 코드 최소화

---

## 의존성 관리

### 주요 패키지 iOS 버전 요구사항

| 패키지 | 최소 iOS | 이유 | 대안 |
|--------|----------|------|------|
| google_maps_flutter | 14.0 | Google Maps SDK v7.0+ | ❌ 없음 (필수) |
| image_picker | 12.0 | PHPickerViewController | ⚠️ 구형 API 사용 가능 |
| supabase_flutter | 13.0+ | 최신 네트워크 API | ⚠️ 직접 REST API 구현 |
| cached_network_image | 11.0+ | 이미지 캐싱 | ✅ 다른 패키지 사용 가능 |
| flutter_riverpod | 11.0+ | Dart 상태관리 | ✅ Provider 사용 |
| go_router | 12.0+ | 네비게이션 | ✅ Navigator 1.0 사용 |

### 의존성 체인 시각화

```
Fitkle App (iOS 15.0)
├─ google_maps_flutter (iOS 14.0) ← 병목!
│  └─ GoogleMaps SDK (iOS 14.0)
│     └─ iOS SDK (UIKit, CoreLocation)
├─ image_picker (iOS 12.0)
│  └─ Photos Framework (iOS 12.0)
│     └─ iOS SDK (AVFoundation, Photos)
├─ supabase_flutter (iOS 13.0)
│  └─ URLSession (iOS 13.0)
│     └─ iOS SDK (Foundation)
└─ cached_network_image (iOS 11.0)
   └─ Image I/O (iOS 11.0)
      └─ iOS SDK (Foundation)

결론: 가장 높은 요구사항 = iOS 14.0
→ 이보다 낮게는 물리적으로 불가능!
```

### CocoaPods 의존성 관리

**Podfile의 역할:**
```ruby
# 1. 프로젝트 전체 최소 버전 선언
platform :ios, '15.0'

# 2. 각 Pod(라이브러리)의 버전 강제
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 모든 Pod가 최소 15.0 사용하도록 강제
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
```

**왜 필요한가?**
```
문제 상황:
- 앱: iOS 15.0
- 일부 Pod: iOS 12.0 설정
→ 빌드 에러! (버전 불일치)

해결:
post_install 훅으로 모든 Pod를 15.0으로 통일
```

### 패키지 업데이트 시 주의사항

```bash
# 1. 업데이트 전 최소 버전 확인
flutter pub outdated

# 2. pub.dev에서 CHANGELOG 확인
# → "BREAKING: iOS 15+ required" 같은 문구 찾기

# 3. 업데이트 후 iOS 빌드 테스트
flutter pub upgrade
cd ios && pod update
flutter build ios --release
```

**실제 예시:**
```yaml
# Before
google_maps_flutter: ^2.9.0  # iOS 13+

# After (업데이트 후)
google_maps_flutter: ^2.10.0 # iOS 14+ 필수!
→ Podfile도 수정 필요!
```

---

## 배포 체크리스트

### Phase 1: 버전 설정

- [ ] **pubspec.yaml 버전 확인**
  ```yaml
  version: 1.0.0+1
  # 첫 배포: 1.0.0+1
  # 버그 수정: 1.0.1+2
  # 새 기능: 1.1.0+3
  # 큰 변경: 2.0.0+4
  ```

- [ ] **Podfile 최소 버전 확인**
  ```ruby
  platform :ios, '15.0'
  ```

- [ ] **Xcode 프로젝트 설정 확인**
  ```
  Xcode → Runner → General
  → Minimum Deployments: iOS 15.0
  ```

### Phase 2: 빌드 전 준비

- [ ] **의존성 정리**
  ```bash
  flutter clean
  flutter pub get
  cd ios && pod install --repo-update
  ```

- [ ] **Info.plist 권한 설명 확인**
  - [ ] NSCameraUsageDescription ✅
  - [ ] NSPhotoLibraryUsageDescription ✅
  - [ ] NSLocationWhenInUseUsageDescription (필요 시)

- [ ] **앱 아이콘 생성**
  ```bash
  flutter pub run flutter_launcher_icons
  ```

- [ ] **스플래시 스크린 생성**
  ```bash
  flutter pub run flutter_native_splash:create
  ```

### Phase 3: 로컬 테스트

- [ ] **시뮬레이터 테스트**
  ```bash
  # iOS 15 시뮬레이터
  open -a Simulator
  flutter run --release
  ```

- [ ] **실제 디바이스 테스트**
  ```bash
  # 개발자 계정 필요
  flutter run --release -d [device-id]
  ```

- [ ] **빌드 검증**
  ```bash
  flutter build ios --release
  # 에러 없이 성공하는지 확인
  ```

### Phase 4: Archive & Upload

- [ ] **Xcode에서 Archive 생성**
  ```
  1. Xcode 열기: open ios/Runner.xcworkspace
  2. Product → Destination → Any iOS Device
  3. Product → Archive
  4. 5-10분 대기
  ```

- [ ] **App Store Connect 업로드**
  ```
  1. Organizer → Distribute App
  2. App Store Connect 선택
  3. Upload 클릭
  4. 10-20분 대기
  ```

- [ ] **TestFlight 배포**
  ```
  App Store Connect → TestFlight
  → 빌드 선택 → 테스터 추가
  ```

### Phase 5: App Store 제출

- [ ] **앱 정보 입력**
  - [ ] 앱 이름
  - [ ] 부제
  - [ ] 키워드
  - [ ] 설명
  - [ ] 스크린샷 (필수 크기별)

- [ ] **버전 정보 입력**
  - [ ] 버전 번호 (1.0.0)
  - [ ] 변경 사항 (What's New)

- [ ] **심사 정보 입력**
  - [ ] 연락처 정보
  - [ ] 데모 계정 (필요 시)
  - [ ] 심사 노트

- [ ] **제출**
  - [ ] "Submit for Review" 클릭
  - [ ] 1-3일 대기

### Phase 6: 배포 후

- [ ] **사용자 피드백 모니터링**
- [ ] **크래시 리포트 확인**
- [ ] **버전별 채택률 추적**

---

## 문제 해결 가이드

### 자주 발생하는 에러

#### 1. CocoaPods 버전 에러

```bash
[!] CocoaPods could not find compatible versions for pod "GoogleMaps"
```

**원인:** 의존성 충돌

**해결:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install --repo-update
```

#### 2. Deployment Target 불일치

```
warning: The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 12.0,
but the range of supported deployment target versions is 15.0 to 18.0.
```

**원인:** 일부 Pod가 낮은 버전 설정

**해결:** Podfile의 `post_install` 훅 확인
```ruby
if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
end
```

#### 3. Archive 실패

```
error: Sandbox: rsync.samba(xxx) deny(1) file-write-create ...
```

**원인:** Xcode 빌드 시스템 이슈

**해결:**
```
Xcode → File → Workspace Settings
→ Build System: Legacy Build System
```

#### 4. M1/M2 Mac 아키텍처 에러

```
building for iOS Simulator, but linking in object file built for iOS
```

**원인:** arm64 시뮬레이터 아키텍처

**해결:** Podfile에 추가
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

### 버전 다운그레이드 필요 시

**시나리오:** iOS 15 → 14로 변경

```bash
# 1. Podfile 수정
platform :ios, '14.0'

# post_install의 15.0도 14.0으로 변경
if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 14.0
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
end

# 2. Clean & Reinstall
cd ios
rm -rf Pods Podfile.lock
pod install

# 3. Flutter Clean
cd ..
flutter clean
flutter pub get

# 4. Xcode 설정 확인
open ios/Runner.xcworkspace
# General → Minimum Deployments → iOS 14.0

# 5. 빌드 테스트
flutter build ios --release
```

### 디버깅 팁

```bash
# 1. 자세한 빌드 로그
flutter build ios --release --verbose

# 2. CocoaPods 디버깅
cd ios
pod install --verbose

# 3. Xcode 로그 확인
# Xcode → Report Navigator (⌘9) → Build 선택

# 4. 시뮬레이터 로그
# 시뮬레이터 실행 중:
xcrun simctl spawn booted log stream --level debug
```

---

## 추가 학습 자료

### Apple 공식 문서

- [iOS Deployment Target](https://developer.apple.com/documentation/xcode/build-settings-reference#Deployment)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Version Numbers and Build Numbers](https://developer.apple.com/library/archive/technotes/tn2420/_index.html)

### Flutter 공식 문서

- [Build and release an iOS app](https://docs.flutter.dev/deployment/ios)
- [iOS setup](https://docs.flutter.dev/get-started/install/macos/mobile-ios)

### 유용한 명령어 모음

```bash
# Flutter 버전 확인
flutter --version

# iOS 디바이스 목록
flutter devices

# 시뮬레이터 목록
xcrun simctl list devices available

# 특정 시뮬레이터 부팅
xcrun simctl boot "iPhone 15"

# 앱 빌드 크기 분석
flutter build ios --analyze-size

# 릴리즈 빌드 프로파일링
flutter run --release --profile
```

---

## 버전 관리 베스트 프랙티스

### 1. Git 태그와 동기화

```bash
# pubspec.yaml에서 버전 변경 후
git add .
git commit -m "Bump version to 1.1.0"
git tag v1.1.0
git push origin main --tags
```

### 2. CHANGELOG 관리

```markdown
# CHANGELOG.md

## [1.1.0] - 2024-12-02
### Added
- 새로운 프로필 설정 화면
- Google Maps 통합

### Fixed
- 로그인 오류 수정

### Changed
- iOS 최소 버전 15.0으로 변경

## [1.0.0] - 2024-11-01
### Added
- 초기 릴리즈
```

### 3. 버전 관리 전략

```
Main Branch (main)
├─ 1.0.0+1   ← 첫 배포
├─ 1.0.1+2   ← 핫픽스
├─ 1.1.0+3   ← 새 기능
└─ 2.0.0+4   ← 메이저 업데이트

Development Branch (develop)
└─ feature/* ← 개발 중인 기능

Release Branch (release/*)
└─ release/1.1.0 ← 배포 준비
```

### 4. CI/CD 자동화

```yaml
# .github/workflows/ios-release.yml (예시)
name: iOS Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2

      - name: Install dependencies
        run: flutter pub get

      - name: Build iOS
        run: flutter build ios --release --no-codesign

      - name: Run tests
        run: flutter test
```

---

## 요약

### 핵심 포인트

1. **iOS는 플랫폼 (= 메인 라이브러리)**
   - 모든 앱과 SDK의 기반
   - 외부 SDK는 iOS API를 사용해서 구현됨

2. **버전 의존성 체인**
   - 당신의 앱 → Flutter Plugin → Native SDK → iOS SDK
   - 체인 중 가장 높은 버전이 최소 요구사항

3. **현재 프로젝트 설정 (iOS 15.0)**
   - ✅ 95% 사용자 커버
   - ✅ 모든 의존성 만족
   - ✅ Apple 권장 사항 준수
   - ✅ 개발/유지보수 효율

4. **배포 프로세스**
   - 버전 설정 → 빌드 → Archive → Upload → 심사 → 배포

5. **지속적 관리**
   - 정기적인 의존성 업데이트
   - iOS 버전별 채택률 모니터링
   - 필요 시 최소 버전 상향 조정

---

## 문서 업데이트 이력

- 2024-12-02: 초기 작성
- 향후 iOS 버전 정책 변경 시 업데이트 예정

---

**질문이나 이슈 발생 시:**
1. 이 문서의 "문제 해결 가이드" 섹션 확인
2. Flutter 공식 문서 검색
3. Stack Overflow 검색
4. Apple Developer Forums 확인
