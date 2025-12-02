import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

/// Supabase Storage 서비스
class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 프로필 사진 업로드
  ///
  /// 1. Storage에 이미지 업로드
  /// 2. 성공하면 공개 URL 반환
  /// 3. 실패하면 예외 발생
  ///
  /// Storage 경로: member/[member_uuid]/avatar/[uuid].확장자
  Future<String> uploadProfileImage(String filePath, String userId) async {
    try {
      print('💾 [Storage] Starting upload...');
      print('💾 [Storage] File path: $filePath');
      print('💾 [Storage] User ID: $userId');

      final file = File(filePath);

      // 파일 존재 확인
      final exists = await file.exists();
      print('💾 [Storage] File exists: $exists');

      if (!exists) {
        throw Exception('File does not exist at path: $filePath');
      }

      // 파일 크기 확인
      final fileSize = await file.length();
      print('💾 [Storage] File size: ${fileSize ~/ 1024}KB');

      // 파일 확장자 가져오기
      final fileExtension = path.extension(filePath).toLowerCase();
      print('💾 [Storage] File extension: $fileExtension');

      // UUID로 고유한 파일명 생성
      final imageUuid = DateTime.now().millisecondsSinceEpoch.toString();

      // Storage 경로: member/[member_uuid]/avatar/[uuid].확장자
      final storagePath = 'member/$userId/avatar/$imageUuid$fileExtension';
      print('💾 [Storage] Storage path: $storagePath');

      // Storage에 업로드 (fitkle 버킷에 저장)
      print('💾 [Storage] Uploading to Supabase Storage...');
      await _supabase.storage
          .from('fitkle')
          .upload(storagePath, file);

      print('✅ [Storage] Upload completed!');

      // 공개 URL 가져오기
      final publicUrl = _supabase.storage
          .from('fitkle')
          .getPublicUrl(storagePath);

      print('✅ [Storage] Public URL: $publicUrl');

      return publicUrl;
    } catch (e, stackTrace) {
      print('❌ [Storage] Upload failed: $e');
      print('❌ [Storage] Stack trace: $stackTrace');
      throw Exception('Failed to upload image: $e');
    }
  }

  /// 프로필 사진 삭제
  ///
  /// Storage에서 이미지 파일 삭제
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      print('🗑️ [Storage] Deleting image...');
      print('🗑️ [Storage] Image URL: $imageUrl');

      // URL에서 파일 경로 추출
      // 예: https://xxx.supabase.co/storage/v1/object/public/fitkle/member/uuid/avatar/123456.jpg
      // -> member/uuid/avatar/123456.jpg
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      print('🗑️ [Storage] Path segments: $pathSegments');

      // 'storage', 'v1', 'object', 'public', 'fitkle', 'member', 'uuid', 'avatar', 'filename.jpg'
      // 에서 'fitkle' 이후의 경로를 추출
      final bucketIndex = pathSegments.indexOf('fitkle');
      print('🗑️ [Storage] Bucket index: $bucketIndex');

      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        // 버킷 이름 이후의 경로를 모두 합침
        final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
        print('🗑️ [Storage] Storage path to delete: $storagePath');

        await _supabase.storage
            .from('fitkle')
            .remove([storagePath]);

        print('✅ [Storage] Image deleted successfully');
      } else {
        print('⚠️ [Storage] Could not find bucket index in URL');
      }
    } catch (e, stackTrace) {
      // 삭제 실패는 에러를 던지지 않음 (이미 삭제되었을 수 있음)
      print('⚠️ [Storage] Delete failed (non-critical): $e');
      print('⚠️ [Storage] Stack trace: $stackTrace');
    }
  }

  /// 이전 프로필 사진 교체
  ///
  /// 1. 새 이미지 업로드
  /// 2. 성공하면 이전 이미지 삭제
  Future<String> replaceProfileImage(
    String filePath,
    String userId,
    String? oldImageUrl,
  ) async {
    print('🔄 [Storage] Replace image process starting...');
    print('🔄 [Storage] Old image URL: $oldImageUrl');

    // 1. 새 이미지 업로드
    final newImageUrl = await uploadProfileImage(filePath, userId);

    // 2. 이전 이미지 삭제 (있는 경우)
    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      print('🔄 [Storage] Deleting old image...');
      await deleteProfileImage(oldImageUrl);
    } else {
      print('🔄 [Storage] No old image to delete');
    }

    print('✅ [Storage] Replace completed! New URL: $newImageUrl');
    return newImageUrl;
  }
}
