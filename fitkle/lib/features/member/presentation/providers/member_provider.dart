import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';
import 'package:fitkle/features/member/domain/repositories/member_repository.dart';
import 'package:fitkle/features/member/domain/services/member_service.dart';
import 'package:fitkle/features/member/data/datasources/member_remote_datasource.dart';
import 'package:fitkle/features/member/data/repositories/member_repository_impl.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';

// ============================================================================
// DEPENDENCY INJECTION - Member Feature
// ============================================================================

// Core Dependencies
final _memberSupabaseClientProvider = Provider((ref) => supabaseClient);
final _memberNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final memberRemoteDataSourceProvider = Provider<MemberRemoteDataSource>((ref) {
  return MemberRemoteDataSourceImpl(ref.watch(_memberSupabaseClientProvider));
});

// Repositories
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(
    remoteDataSource: ref.watch(memberRemoteDataSourceProvider),
    networkInfo: ref.watch(_memberNetworkInfoProvider),
  );
});

// Services
final memberServiceProvider = Provider<MemberService>((ref) {
  return MemberService(ref.watch(memberRepositoryProvider));
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

// State classes
class MemberState {
  final MemberEntity? user;
  final bool isLoading;
  final String? errorMessage;

  MemberState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  MemberState copyWith({
    MemberEntity? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MemberState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Member Profile Notifier (for viewing other users)
class MemberProfileNotifier extends StateNotifier<MemberState> {
  final MemberService _memberService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  MemberProfileNotifier(this._memberService) : super(MemberState());

  Future<void> loadMember(String userId, {bool forceRefresh = false}) async {
    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null && state.user != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration) {
        return; // 캐시된 데이터 사용
      }
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _memberService.getMemberById(userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (user) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

final memberProfileProvider = StateNotifierProvider<MemberProfileNotifier, MemberState>((ref) {
  ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
  return MemberProfileNotifier(ref.watch(memberServiceProvider));
});
