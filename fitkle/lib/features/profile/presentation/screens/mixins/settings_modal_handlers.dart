import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitkle/shared/widgets/selection_modal.dart';
import 'package:fitkle/shared/widgets/dialogs/text_input_modal.dart';
import 'package:fitkle/shared/widgets/dialogs/profile_picture_modal.dart';
import 'package:fitkle/features/member/presentation/providers/member_provider.dart';
import 'package:fitkle/features/member/domain/models/interest.dart';
import 'package:fitkle/features/member/domain/models/preference.dart';
import 'package:fitkle/features/member/domain/services/interest_service.dart';
import 'package:fitkle/features/member/domain/services/preference_service.dart';
import 'package:fitkle/features/member/domain/services/storage_service.dart';
import 'package:fitkle/shared/providers/toast_provider.dart';

/// 설정 화면의 모달 핸들러를 제공하는 Mixin
mixin SettingsModalHandlers<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // 이 메서드들은 SettingsScreen에서 구현되어야 합니다
  String get name;
  set name(String value);
  String get email;
  set email(String value);
  String get facebook;
  set facebook(String value);
  String get instagram;
  set instagram(String value);
  String get twitter;
  set twitter(String value);
  String get linkedin;
  set linkedin(String value);
  bool get isNicknameEditable;
  DateTime? get nicknameUpdatedAt;
  List<Interest> get memberInterests;
  set memberInterests(List<Interest> value);
  List<Interest> get allInterests;
  List<Preference> get memberPreferences;
  set memberPreferences(List<Preference> value);
  List<Preference> get allPreferences;
  String? get avatarUrl;

  /// Profile Picture 모달 열기
  void openProfilePictureModal(BuildContext context) {
    print('🖼️ [Modal] Opening profile picture modal...');
    print('🖼️ [Modal] Current avatar URL: $avatarUrl');
    print('🖼️ [Modal] Has current photo: ${avatarUrl != null && avatarUrl!.isNotEmpty}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfilePictureModal(
        hasCurrentPhoto: avatarUrl != null && avatarUrl!.isNotEmpty,
        onTakePhoto: () {
          print('🖼️ [Modal] Take Photo button pressed');
          _pickImageFromCamera();
        },
        onChooseFromGallery: () {
          print('🖼️ [Modal] Choose from Gallery button pressed');
          _pickImageFromGallery();
        },
        onRemovePhoto: () {
          print('🖼️ [Modal] Remove Photo button pressed');
          _removeProfilePhoto();
        },
      ),
    );
  }

  /// 카메라로 사진 촬영
  Future<void> _pickImageFromCamera() async {
    try {
      print('🎥 [Camera] Starting camera picker...');

      // macOS와 웹에서는 카메라가 지원되지 않음
      if (!kIsWeb && Platform.isMacOS) {
        print('⚠️ [Camera] Camera not supported on macOS');
        ref.read(toastProvider.notifier).showError('Camera is not supported on macOS. Please use "Choose from Gallery" instead.');
        return;
      }

      final ImagePicker picker = ImagePicker();

      print('🎥 [Camera] Calling pickImage...');
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      print('🎥 [Camera] Image picked: ${image != null ? image.path : 'null'}');

      if (image != null) {
        print('🎥 [Camera] Starting upload process...');
        await _uploadAndUpdateAvatar(image.path);
      } else {
        print('🎥 [Camera] User cancelled camera');
      }
    } catch (e, stackTrace) {
      print('❌ [Camera] Error: $e');
      print('❌ [Camera] Stack trace: $stackTrace');
      ref.read(toastProvider.notifier).showError('Failed to take photo: $e');
    }
  }

  /// 갤러리에서 사진 선택
  Future<void> _pickImageFromGallery() async {
    try {
      print('📷 [Gallery] Starting gallery picker...');
      final ImagePicker picker = ImagePicker();

      print('📷 [Gallery] Calling pickImage...');
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      print('📷 [Gallery] Image picked: ${image != null ? image.path : 'null'}');

      if (image != null) {
        print('📷 [Gallery] Starting upload process...');
        await _uploadAndUpdateAvatar(image.path);
      } else {
        print('📷 [Gallery] User cancelled gallery');
      }
    } catch (e, stackTrace) {
      print('❌ [Gallery] Error: $e');
      print('❌ [Gallery] Stack trace: $stackTrace');
      ref.read(toastProvider.notifier).showError('Failed to select photo: $e');
    }
  }

  /// 이미지 업로드 및 프로필 업데이트
  Future<void> _uploadAndUpdateAvatar(String filePath) async {
    try {
      print('📤 [Upload] Starting upload process...');
      print('📤 [Upload] File path: $filePath');

      // 로딩 표시
      ref.read(toastProvider.notifier).show('Uploading photo...');

      // 현재 멤버 정보 가져오기
      print('📤 [Upload] Getting current member...');
      final memberAsync = ref.read(currentMemberProvider);
      final member = memberAsync.valueOrNull;

      if (member == null) {
        print('❌ [Upload] Member is null!');
        ref.read(toastProvider.notifier).showError('Failed to load user information');
        return;
      }

      print('📤 [Upload] Member ID: ${member.id}');
      print('📤 [Upload] Current avatar URL: $avatarUrl');

      // Storage 서비스 생성
      final storageService = StorageService();

      // 1. Storage에 이미지 업로드 (이전 이미지가 있으면 교체)
      print('📤 [Upload] Uploading to Storage...');
      final imageUrl = await storageService.replaceProfileImage(
        filePath,
        member.id,
        avatarUrl,
      );
      print('✅ [Upload] Upload successful! URL: $imageUrl');

      // 2. 업로드 성공 후 DB 업데이트
      print('📤 [Upload] Updating DB...');
      final memberService = ref.read(memberServiceProvider);
      final result = await memberService.updateAvatar(member.id, imageUrl);

      result.fold(
        (failure) {
          print('❌ [Upload] DB update failed: $failure');
          ref.read(toastProvider.notifier).showError('Failed to update profile picture');
        },
        (_) {
          print('✅ [Upload] DB update successful!');
          // 3. Provider 새로고침
          ref.invalidate(currentMemberProvider);
          ref.read(toastProvider.notifier).showSuccess('Profile picture updated successfully');
        },
      );
    } catch (e, stackTrace) {
      print('❌ [Upload] Error: $e');
      print('❌ [Upload] Stack trace: $stackTrace');
      ref.read(toastProvider.notifier).showError('Failed to upload photo: $e');
    }
  }

  /// 프로필 사진 삭제
  Future<void> _removeProfilePhoto() async {
    try {
      // 현재 멤버 정보 가져오기
      final memberAsync = ref.read(currentMemberProvider);
      final member = memberAsync.valueOrNull;
      if (member == null) {
        ref.read(toastProvider.notifier).showError('Failed to load user information');
        return;
      }

      // 현재 프로필 사진이 없으면 리턴
      if (avatarUrl == null || avatarUrl!.isEmpty) {
        ref.read(toastProvider.notifier).show('No profile picture to remove');
        return;
      }

      // 로딩 표시
      ref.read(toastProvider.notifier).show('Removing photo...');

      // Storage 서비스 생성
      final storageService = StorageService();

      // 1. Storage에서 이미지 삭제
      await storageService.deleteProfileImage(avatarUrl!);

      // 2. DB에서 avatar_url을 null로 업데이트
      final memberService = ref.read(memberServiceProvider);
      final result = await memberService.updateAvatar(member.id, '');

      result.fold(
        (failure) {
          ref.read(toastProvider.notifier).showError('Failed to remove profile picture');
        },
        (_) {
          // 3. Provider 새로고침
          ref.invalidate(currentMemberProvider);
          ref.read(toastProvider.notifier).showSuccess('Profile picture removed successfully');
        },
      );
    } catch (e) {
      ref.read(toastProvider.notifier).showError('Failed to remove photo: $e');
    }
  }

  /// Preferences 모달 열기
  void openPreferencesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectionModal(
        title: 'Select your preferred event types',
        selectedItems: memberPreferences.map((p) => p.name).toList(),
        allItems: allPreferences
            .map((p) => {'id': p.id, 'label': p.name, 'emoji': p.emoji})
            .toList(),
        onSave: (selectedNames) async {
          // Get current member
          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          // Get selected preference IDs
          final selectedPreferences = allPreferences
              .where((p) => selectedNames.contains(p.name))
              .toList();
          final preferenceIds = selectedPreferences.map((p) => p.id).toList();

          // Call RPC API to update preferences
          try {
            final preferenceService = PreferenceService();
            await preferenceService.updateMemberPreferences(member.id, preferenceIds);

            // Update local state
            setState(() {
              memberPreferences = selectedPreferences;
            });

            // Refresh provider data
            ref.invalidate(currentMemberProvider);

            // Show success toast
            ref.read(toastProvider.notifier).showSuccess('Preferences updated successfully');
          } catch (e) {
            // Show error toast
            ref.read(toastProvider.notifier).showError('Failed to update preferences');
          }
        },
        getItemEmoji: (name) {
          try {
            final pref = allPreferences.firstWhere((p) => p.name == name);
            return pref.emoji;
          } catch (e) {
            return '⭐';
          }
        },
        maxSelection: 10,
      ),
    );
  }

  /// Interests 모달 열기
  void openInterestsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectionModal(
        title: 'Select your interests',
        selectedItems: memberInterests.map((i) => i.name).toList(),
        allItems: allInterests
            .map((i) => {
                  'id': i.id,
                  'label': i.name,
                  'emoji': i.emoji ?? '⭐',
                  'category': i.categoryCode,
                })
            .toList(),
        onSave: (selectedNames) async {
          // Get current member
          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          // Get selected interest IDs
          final selectedInterests = allInterests
              .where((i) => selectedNames.contains(i.name))
              .toList();
          final interestIds = selectedInterests.map((i) => i.id).toList();

          // Call RPC API to update interests
          try {
            final interestService = InterestService();
            await interestService.updateMemberInterests(member.id, interestIds);

            // Update local state
            setState(() {
              memberInterests = selectedInterests;
            });

            // Refresh provider data
            ref.invalidate(currentMemberProvider);

            // Show success toast
            ref.read(toastProvider.notifier).showSuccess('Interests updated successfully');
          } catch (e) {
            // Show error toast
            ref.read(toastProvider.notifier).showError('Failed to update interests');
          }
        },
        getItemEmoji: (name) {
          try {
            final interest = allInterests.firstWhere((i) => i.name == name);
            return interest.emoji ?? '⭐';
          } catch (e) {
            return '⭐';
          }
        },
        maxSelection: 10,
        categoryKey: 'category',
      ),
    );
  }

  /// Nickname 모달 열기
  void openNicknameModal(BuildContext context) {
    // 30일 이내에 변경한 경우 모달을 열지 않음
    if (!isNicknameEditable) {
      final daysSinceUpdate = DateTime.now().difference(nicknameUpdatedAt!).inDays;
      final daysRemaining = 30 - daysSinceUpdate;
      ref.read(toastProvider.notifier).showError(
        'You can change your nickname again in $daysRemaining day${daysRemaining > 1 ? 's' : ''}'
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit Nickname',
        currentValue: name,
        hintText: 'Enter your nickname',
        helpText: 'Can only be changed once every 30 days',
        maxLength: 30,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == name) {
            return;
          }

          // Get current member
          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          // Call PATCH API
          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateNickname(member.id, value);

          result.fold(
            (failure) {
              // Show error toast
              ref.read(toastProvider.notifier).showError('Failed to update nickname');
            },
            (updatedMember) {
              // Update local state
              setState(() => name = value);
              // Refresh provider data
              ref.invalidate(currentMemberProvider);
              // Show success toast
              ref.read(toastProvider.notifier).showSuccess('Nickname updated successfully');
            },
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Nickname cannot be empty';
          }
          if (value.length < 2) {
            return 'Nickname must be at least 2 characters';
          }
          return null;
        },
      ),
    );
  }

  /// Email 모달 열기
  void openEmailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit Email',
        currentValue: email,
        hintText: 'contact@example.com',
        helpText: 'Your contact email (can be same as login email or a different one)',
        showDeleteButton: email.isNotEmpty,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == email) {
            return;
          }

          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateEmailHandle(member.id, value);

          result.fold(
            (failure) {
              ref.read(toastProvider.notifier).showError('Failed to update email');
            },
            (updatedMember) {
              setState(() => email = value);
              ref.invalidate(currentMemberProvider);
              if (value.isEmpty) {
                ref.read(toastProvider.notifier).showSuccess('Email deleted successfully');
              } else {
                ref.read(toastProvider.notifier).showSuccess('Email updated successfully');
              }
            },
          );
        },
      ),
    );
  }

  /// Facebook 모달 열기
  void openFacebookModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit Facebook',
        currentValue: facebook,
        hintText: 'your_facebook_name',
        helpText: 'https://facebook.com/your_facebook_name',
        showDeleteButton: facebook.isNotEmpty,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == facebook) {
            return;
          }

          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateFacebookHandle(member.id, value);

          result.fold(
            (failure) {
              ref.read(toastProvider.notifier).showError('Failed to update Facebook');
            },
            (updatedMember) {
              setState(() => facebook = value);
              ref.invalidate(currentMemberProvider);
              if (value.isEmpty) {
                ref.read(toastProvider.notifier).showSuccess('Facebook deleted successfully');
              } else {
                ref.read(toastProvider.notifier).showSuccess('Facebook updated successfully');
              }
            },
          );
        },
      ),
    );
  }

  /// Instagram 모달 열기
  void openInstagramModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit Instagram',
        currentValue: instagram,
        hintText: '@your_instagram_name',
        helpText: 'https://instagram.com/your_instagram_name or @username',
        showDeleteButton: instagram.isNotEmpty,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == instagram) {
            return;
          }

          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateInstagramHandle(member.id, value);

          result.fold(
            (failure) {
              ref.read(toastProvider.notifier).showError('Failed to update Instagram');
            },
            (updatedMember) {
              setState(() => instagram = value);
              ref.invalidate(currentMemberProvider);
              if (value.isEmpty) {
                ref.read(toastProvider.notifier).showSuccess('Instagram deleted successfully');
              } else {
                ref.read(toastProvider.notifier).showSuccess('Instagram updated successfully');
              }
            },
          );
        },
      ),
    );
  }

  /// Twitter 모달 열기
  void openTwitterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit Twitter',
        currentValue: twitter,
        hintText: '@Your_Twitter_Name',
        helpText: 'https://twitter.com/Your_Twitter_Name or @username',
        showDeleteButton: twitter.isNotEmpty,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == twitter) {
            return;
          }

          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateTwitterHandle(member.id, value);

          result.fold(
            (failure) {
              ref.read(toastProvider.notifier).showError('Failed to update Twitter');
            },
            (updatedMember) {
              setState(() => twitter = value);
              ref.invalidate(currentMemberProvider);
              if (value.isEmpty) {
                ref.read(toastProvider.notifier).showSuccess('Twitter deleted successfully');
              } else {
                ref.read(toastProvider.notifier).showSuccess('Twitter updated successfully');
              }
            },
          );
        },
      ),
    );
  }

  /// LinkedIn 모달 열기
  void openLinkedinModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        title: 'Edit LinkedIn',
        currentValue: linkedin,
        hintText: 'yourlinkedinname',
        helpText: 'https://linkedin.com/in/yourlinkedinname',
        showDeleteButton: linkedin.isNotEmpty,
        onSave: (value) async {
          // 변경사항이 없으면 아무것도 하지 않음
          if (value.trim() == linkedin) {
            return;
          }

          final memberAsync = ref.read(currentMemberProvider);
          final member = memberAsync.valueOrNull;
          if (member == null) {
            ref.read(toastProvider.notifier).showError('Failed to load user information');
            return;
          }

          final memberService = ref.read(memberServiceProvider);
          final result = await memberService.updateLinkedinHandle(member.id, value);

          result.fold(
            (failure) {
              ref.read(toastProvider.notifier).showError('Failed to update LinkedIn');
            },
            (updatedMember) {
              setState(() => linkedin = value);
              ref.invalidate(currentMemberProvider);
              if (value.isEmpty) {
                ref.read(toastProvider.notifier).showSuccess('LinkedIn deleted successfully');
              } else {
                ref.read(toastProvider.notifier).showSuccess('LinkedIn updated successfully');
              }
            },
          );
        },
      ),
    );
  }
}
