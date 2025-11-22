import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import 'package:fitkle/features/group/domain/repositories/group_repository.dart';
import 'package:fitkle/features/group/domain/repositories/group_category_repository.dart';
import 'package:fitkle/features/group/domain/services/group_service.dart';
import 'package:fitkle/features/group/domain/services/group_category_service.dart';
import 'package:fitkle/features/group/data/datasources/group_remote_datasource.dart';
import 'package:fitkle/features/group/data/datasources/group_category_remote_datasource.dart';
import 'package:fitkle/features/group/data/repositories/group_repository_impl.dart';
import 'package:fitkle/features/group/data/repositories/group_category_repository_impl.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/core/utils/logger.dart';

// ============================================================================
// DEPENDENCY INJECTION - Group Feature
// ============================================================================

// Core Dependencies
final _groupSupabaseClientProvider = Provider((ref) => supabaseClient);
final _groupNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  return GroupRemoteDataSourceImpl(ref.watch(_groupSupabaseClientProvider));
});

final groupCategoryRemoteDataSourceProvider = Provider<GroupCategoryRemoteDataSource>((ref) {
  return GroupCategoryRemoteDataSourceImpl(ref.watch(_groupSupabaseClientProvider));
});

// Repositories
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepositoryImpl(
    remoteDataSource: ref.watch(groupRemoteDataSourceProvider),
    networkInfo: ref.watch(_groupNetworkInfoProvider),
  );
});

final groupCategoryRepositoryProvider = Provider<GroupCategoryRepository>((ref) {
  return GroupCategoryRepositoryImpl(
    remoteDataSource: ref.watch(groupCategoryRemoteDataSourceProvider),
    networkInfo: ref.watch(_groupNetworkInfoProvider),
  );
});

// Services
final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService(ref.watch(groupRepositoryProvider));
});

final groupCategoryServiceProvider = Provider<GroupCategoryService>((ref) {
  return GroupCategoryService(ref.watch(groupCategoryRepositoryProvider));
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

// State classes
class GroupState {
  final List<GroupEntity> groups;
  final bool isLoading;
  final String? errorMessage;

  GroupState({
    this.groups = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GroupState copyWith({
    List<GroupEntity>? groups,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class GroupDetailState {
  final GroupEntity? group;
  final bool isLoading;
  final String? errorMessage;

  GroupDetailState({
    this.group,
    this.isLoading = false,
    this.errorMessage,
  });

  GroupDetailState copyWith({
    GroupEntity? group,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupDetailState(
      group: group ?? this.group,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Group List Provider
class GroupNotifier extends StateNotifier<GroupState> {
  final GroupService _groupService;
  final GroupCategoryService _categoryService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  GroupNotifier(this._groupService, this._categoryService) : super(GroupState());

  Future<void> loadGroups({
    String? category, // category code (e.g., 'SOCIAL')
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration && state.groups.isNotEmpty) {
        Logger.info(
          'Using cached groups (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'GroupProvider',
        );
        return; // 캐시된 데이터 사용
      }
    }

    Logger.info('Loading groups from API...', tag: 'GroupProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Convert category code to UUID
    String? categoryId;
    if (category != null) {
      final categoryResult = await _categoryService.getCategoryByCode(category);
      categoryResult.fold(
        (failure) => Logger.warning('Failed to get category: ${failure.message}', tag: 'GroupProvider'),
        (categoryEntity) => categoryId = categoryEntity?.id,
      );
    }

    final result = await _groupService.getGroups(
      category: categoryId,
      searchQuery: searchQuery,
    );

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load groups: ${failure.message}',
          tag: 'GroupProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (groups) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        Logger.success(
          'Loaded ${groups.length} groups from API',
          tag: 'GroupProvider',
        );
        state = state.copyWith(
          groups: groups,
          isLoading: false,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Group Detail Provider
class GroupDetailNotifier extends StateNotifier<GroupDetailState> {
  final GroupService _groupService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  GroupDetailNotifier(this._groupService) : super(GroupDetailState());

  Future<void> loadGroup(String groupId, {bool forceRefresh = false}) async {
    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null && state.group != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration) {
        Logger.info(
          'Using cached group (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'GroupDetailProvider',
        );
        return; // 캐시된 데이터 사용
      }
    }

    Logger.info('Loading group from API: $groupId', tag: 'GroupDetailProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _groupService.getGroupById(groupId);

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load group $groupId: ${failure.message}',
          tag: 'GroupDetailProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (group) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        Logger.success(
          'Loaded group from API: ${group.name}',
          tag: 'GroupDetailProvider',
        );
        state = state.copyWith(
          group: group,
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

final groupProvider = StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
  return GroupNotifier(
    ref.watch(groupServiceProvider),
    ref.watch(groupCategoryServiceProvider),
  );
});

final groupDetailProvider =
    StateNotifierProvider.family<GroupDetailNotifier, GroupDetailState, String>(
  (ref, groupId) {
    ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
    final notifier = GroupDetailNotifier(ref.watch(groupServiceProvider));
    notifier.loadGroup(groupId);
    return notifier;
  },
);
