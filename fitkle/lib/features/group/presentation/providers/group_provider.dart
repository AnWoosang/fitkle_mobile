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
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentOffset;
  final String? errorMessage;

  static const int pageSize = 30;

  GroupState({
    this.groups = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentOffset = 0,
    this.errorMessage,
  });

  GroupState copyWith({
    List<GroupEntity>? groups,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentOffset,
    String? errorMessage,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentOffset: currentOffset ?? this.currentOffset,
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

  // 현재 필터 상태 저장
  String? _currentCategory;
  String? _currentSearchQuery;

  GroupNotifier(this._groupService, this._categoryService) : super(GroupState());

  Future<void> loadGroups({
    String? category, // category code (e.g., 'SOCIAL')
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    // 필터가 변경되면 강제 새로고침
    final filterChanged = category != _currentCategory ||
        searchQuery != _currentSearchQuery;

    if (filterChanged) {
      _currentCategory = category;
      _currentSearchQuery = searchQuery;
      forceRefresh = true;
    }

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
      limit: GroupState.pageSize,
      offset: 0,
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
          currentOffset: groups.length,
          hasMoreData: groups.length >= GroupState.pageSize,
        );
      },
    );
  }

  /// 무한 스크롤을 위한 추가 데이터 로드
  Future<void> loadMoreGroups() async {
    // 이미 로딩 중이거나 더 이상 데이터가 없으면 스킵
    if (state.isLoading || state.isLoadingMore || !state.hasMoreData) {
      return;
    }

    Logger.info('Loading more groups from offset: ${state.currentOffset}', tag: 'GroupProvider');
    state = state.copyWith(isLoadingMore: true);

    // Convert category code to UUID
    String? categoryId;
    if (_currentCategory != null) {
      final categoryResult = await _categoryService.getCategoryByCode(_currentCategory!);
      categoryResult.fold(
        (failure) => Logger.warning('Failed to get category: ${failure.message}', tag: 'GroupProvider'),
        (categoryEntity) => categoryId = categoryEntity?.id,
      );
    }

    final result = await _groupService.getGroups(
      category: categoryId,
      searchQuery: _currentSearchQuery,
      limit: GroupState.pageSize,
      offset: state.currentOffset,
    );

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load more groups: ${failure.message}',
          tag: 'GroupProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (newGroups) {
        Logger.success(
          'Loaded ${newGroups.length} more groups',
          tag: 'GroupProvider',
        );
        state = state.copyWith(
          groups: [...state.groups, ...newGroups],
          isLoadingMore: false,
          currentOffset: state.currentOffset + newGroups.length,
          hasMoreData: newGroups.length >= GroupState.pageSize,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 초기화 (필터 변경 시 사용)
  void resetState() {
    _lastFetchTime = null;
    _currentCategory = null;
    _currentSearchQuery = null;
    state = GroupState();
  }
}

// Group Detail Provider
class GroupDetailNotifier extends StateNotifier<GroupDetailState> {
  final GroupService _groupService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  // 세션 기반 조회수 추적 - 앱 세션 동안 이미 조회한 그룹 ID 저장
  static final Set<String> _viewedGroupIds = {};

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

  /// 조회수 증가 - 세션당 한 번만 증가
  Future<void> incrementViewCount(String groupId) async {
    if (_viewedGroupIds.contains(groupId)) {
      Logger.info(
        'Group $groupId already viewed in this session, skipping view count increment',
        tag: 'GroupDetailProvider',
      );
      return;
    }

    _viewedGroupIds.add(groupId);
    await _groupService.incrementViewCount(groupId);
  }
}

// My Groups State - 현재 로그인된 멤버가 속한 그룹
class MyGroupsState {
  final List<GroupEntity> groups;
  final bool isLoading;
  final String? errorMessage;

  MyGroupsState({
    this.groups = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MyGroupsState copyWith({
    List<GroupEntity>? groups,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyGroupsState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// My Groups Notifier - 현재 로그인된 멤버가 속한 그룹
class MyGroupsNotifier extends StateNotifier<MyGroupsState> {
  final GroupService _groupService;

  DateTime? _lastFetchTime;
  static const staleDuration = Duration(minutes: 5); // 5분 캐시

  MyGroupsNotifier(this._groupService) : super(MyGroupsState());

  Future<void> loadMyGroups(String memberId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _lastFetchTime != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration && state.groups.isNotEmpty) {
        Logger.info(
          'Using cached my groups (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'MyGroupsProvider',
        );
        return;
      }
    }

    Logger.info('Loading my groups for member: $memberId', tag: 'MyGroupsProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _groupService.getGroupsByMember(memberId);

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load my groups: ${failure.message}',
          tag: 'MyGroupsProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (groups) {
        _lastFetchTime = DateTime.now();
        Logger.success(
          'Loaded ${groups.length} my groups',
          tag: 'MyGroupsProvider',
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

// My Groups Provider - 현재 로그인된 멤버가 속한 그룹
final myGroupsProvider = StateNotifierProvider<MyGroupsNotifier, MyGroupsState>((ref) {
  ref.keepAlive();
  return MyGroupsNotifier(ref.watch(groupServiceProvider));
});
