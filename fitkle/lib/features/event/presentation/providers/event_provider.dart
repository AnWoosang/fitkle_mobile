import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/event/domain/entities/event_entity.dart';
import 'package:fitkle/features/event/domain/repositories/event_repository.dart';
import 'package:fitkle/features/event/domain/repositories/event_category_repository.dart';
import 'package:fitkle/features/event/domain/services/event_service.dart';
import 'package:fitkle/features/event/domain/services/event_category_service.dart';
import 'package:fitkle/features/event/data/datasources/event_remote_datasource.dart';
import 'package:fitkle/features/event/data/datasources/event_category_remote_datasource.dart';
import 'package:fitkle/features/event/data/repositories/event_repository_impl.dart';
import 'package:fitkle/features/event/data/repositories/event_category_repository_impl.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/core/utils/logger.dart';

// ============================================================================
// DEPENDENCY INJECTION - Event Feature
// ============================================================================

// Core Dependencies
final _eventSupabaseClientProvider = Provider((ref) => supabaseClient);
final _eventNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final eventRemoteDataSourceProvider = Provider<EventRemoteDataSource>((ref) {
  return EventRemoteDataSourceImpl(ref.watch(_eventSupabaseClientProvider));
});

final eventCategoryRemoteDataSourceProvider = Provider<EventCategoryRemoteDataSource>((ref) {
  return EventCategoryRemoteDataSourceImpl(ref.watch(_eventSupabaseClientProvider));
});

// Repositories
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(
    remoteDataSource: ref.watch(eventRemoteDataSourceProvider),
    networkInfo: ref.watch(_eventNetworkInfoProvider),
  );
});

final eventCategoryRepositoryProvider = Provider<EventCategoryRepository>((ref) {
  return EventCategoryRepositoryImpl(
    remoteDataSource: ref.watch(eventCategoryRemoteDataSourceProvider),
    networkInfo: ref.watch(_eventNetworkInfoProvider),
  );
});

// Services
final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(ref.watch(eventRepositoryProvider));
});

final eventCategoryServiceProvider = Provider<EventCategoryService>((ref) {
  return EventCategoryService(ref.watch(eventCategoryRepositoryProvider));
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

// State classes
class EventState {
  final List<EventEntity> events;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentOffset;
  final String? errorMessage;

  static const int pageSize = 30;

  EventState({
    this.events = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentOffset = 0,
    this.errorMessage,
  });

  EventState copyWith({
    List<EventEntity>? events,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentOffset,
    String? errorMessage,
  }) {
    return EventState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentOffset: currentOffset ?? this.currentOffset,
      errorMessage: errorMessage,
    );
  }
}

class EventDetailState {
  final EventEntity? event;
  final bool isLoading;
  final String? errorMessage;

  EventDetailState({
    this.event,
    this.isLoading = false,
    this.errorMessage,
  });

  EventDetailState copyWith({
    EventEntity? event,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventDetailState(
      event: event ?? this.event,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Event List Provider
class EventNotifier extends StateNotifier<EventState> {
  final EventService _eventService;
  final EventCategoryService _categoryService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  // 현재 필터 상태 저장
  String? _currentCategory;
  String? _currentSearchQuery;
  bool? _currentIsGroupEvent;

  EventNotifier(this._eventService, this._categoryService) : super(EventState());

  Future<void> loadEvents({
    String? category, // category code (e.g., 'SOCIAL')
    String? searchQuery,
    bool? isGroupEvent,
    bool forceRefresh = false,
  }) async {
    // 필터가 변경되면 강제 새로고침
    final filterChanged = category != _currentCategory ||
        searchQuery != _currentSearchQuery ||
        isGroupEvent != _currentIsGroupEvent;

    if (filterChanged) {
      _currentCategory = category;
      _currentSearchQuery = searchQuery;
      _currentIsGroupEvent = isGroupEvent;
      forceRefresh = true;
    }

    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration && state.events.isNotEmpty) {
        Logger.info(
          'Using cached events (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'EventProvider',
        );
        return; // 캐시된 데이터 사용
      }
    }

    Logger.info('Loading events from API...', tag: 'EventProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Convert category code to UUID
    String? categoryId;
    if (category != null) {
      final categoryResult = await _categoryService.getCategoryByCode(category);
      categoryResult.fold(
        (failure) => Logger.warning('Failed to get category: ${failure.message}', tag: 'EventProvider'),
        (categoryEntity) => categoryId = categoryEntity?.id,
      );
    }

    final result = await _eventService.getEvents(
      category: categoryId,
      searchQuery: searchQuery,
      isGroupEvent: isGroupEvent,
      limit: EventState.pageSize,
      offset: 0,
    );

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load events: ${failure.message}',
          tag: 'EventProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (events) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        Logger.success(
          'Loaded ${events.length} events from API',
          tag: 'EventProvider',
        );
        state = state.copyWith(
          events: events,
          isLoading: false,
          currentOffset: events.length,
          hasMoreData: events.length >= EventState.pageSize,
        );
      },
    );
  }

  /// 무한 스크롤을 위한 추가 데이터 로드
  Future<void> loadMoreEvents() async {
    // 이미 로딩 중이거나 더 이상 데이터가 없으면 스킵
    if (state.isLoading || state.isLoadingMore || !state.hasMoreData) {
      return;
    }

    Logger.info('Loading more events from offset: ${state.currentOffset}', tag: 'EventProvider');
    state = state.copyWith(isLoadingMore: true);

    // Convert category code to UUID
    String? categoryId;
    if (_currentCategory != null) {
      final categoryResult = await _categoryService.getCategoryByCode(_currentCategory!);
      categoryResult.fold(
        (failure) => Logger.warning('Failed to get category: ${failure.message}', tag: 'EventProvider'),
        (categoryEntity) => categoryId = categoryEntity?.id,
      );
    }

    final result = await _eventService.getEvents(
      category: categoryId,
      searchQuery: _currentSearchQuery,
      isGroupEvent: _currentIsGroupEvent,
      limit: EventState.pageSize,
      offset: state.currentOffset,
    );

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load more events: ${failure.message}',
          tag: 'EventProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (newEvents) {
        Logger.success(
          'Loaded ${newEvents.length} more events',
          tag: 'EventProvider',
        );
        state = state.copyWith(
          events: [...state.events, ...newEvents],
          isLoadingMore: false,
          currentOffset: state.currentOffset + newEvents.length,
          hasMoreData: newEvents.length >= EventState.pageSize,
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
    _currentIsGroupEvent = null;
    state = EventState();
  }
}

// Event Detail Provider
class EventDetailNotifier extends StateNotifier<EventDetailState> {
  final EventService _eventService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

  // 세션 기반 조회수 추적 - 앱 세션 동안 이미 조회한 이벤트 ID 저장
  static final Set<String> _viewedEventIds = {};

  EventDetailNotifier(this._eventService) : super(EventDetailState());

  Future<void> loadEvent(String eventId, {bool forceRefresh = false}) async {
    // Stale time 체크 - 캐시가 유효하면 API 호출 스킵
    if (!forceRefresh && _lastFetchTime != null && state.event != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration) {
        Logger.info(
          'Using cached event (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'EventDetailProvider',
        );
        return; // 캐시된 데이터 사용
      }
    }

    Logger.info('Loading event from API: $eventId', tag: 'EventDetailProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _eventService.getEventById(eventId);

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load event $eventId: ${failure.message}',
          tag: 'EventDetailProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (event) {
        _lastFetchTime = DateTime.now(); // 캐시 시간 업데이트
        Logger.success(
          'Loaded event from API: ${event.title}',
          tag: 'EventDetailProvider',
        );
        state = state.copyWith(
          event: event,
          isLoading: false,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 조회수 증가 - 세션당 한 번만 증가
  Future<void> incrementViewCount(String eventId) async {
    if (_viewedEventIds.contains(eventId)) {
      Logger.info(
        'Event $eventId already viewed in this session, skipping view count increment',
        tag: 'EventDetailProvider',
      );
      return;
    }

    _viewedEventIds.add(eventId);
    await _eventService.incrementViewCount(eventId);
  }
}

// Upcoming Events State
class UpcomingEventsState {
  final List<EventEntity> events;
  final bool isLoading;
  final String? errorMessage;

  UpcomingEventsState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UpcomingEventsState copyWith({
    List<EventEntity>? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UpcomingEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Upcoming Events Notifier - 현재 로그인된 멤버의 참여 예정 이벤트
class UpcomingEventsNotifier extends StateNotifier<UpcomingEventsState> {
  final EventService _eventService;

  DateTime? _lastFetchTime;
  static const staleDuration = Duration(minutes: 5); // 5분 캐시

  UpcomingEventsNotifier(this._eventService) : super(UpcomingEventsState());

  Future<void> loadUpcomingEvents(String memberId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _lastFetchTime != null) {
      final now = DateTime.now();
      final timeSinceLastFetch = now.difference(_lastFetchTime!);

      if (timeSinceLastFetch < staleDuration && state.events.isNotEmpty) {
        Logger.info(
          'Using cached upcoming events (${timeSinceLastFetch.inMinutes} minutes old)',
          tag: 'UpcomingEventsProvider',
        );
        return;
      }
    }

    Logger.info('Loading upcoming events for member: $memberId', tag: 'UpcomingEventsProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _eventService.getUpcomingEventsByMember(memberId);

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load upcoming events: ${failure.message}',
          tag: 'UpcomingEventsProvider',
          error: failure,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (events) {
        _lastFetchTime = DateTime.now();
        Logger.success(
          'Loaded ${events.length} upcoming events',
          tag: 'UpcomingEventsProvider',
        );
        state = state.copyWith(
          events: events,
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

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
  return EventNotifier(
    ref.watch(eventServiceProvider),
    ref.watch(eventCategoryServiceProvider),
  );
});

final eventDetailProvider =
    StateNotifierProvider.family<EventDetailNotifier, EventDetailState, String>(
  (ref, eventId) {
    ref.keepAlive(); // Provider가 dispose되지 않도록 유지 (메모리 캐싱)
    final notifier = EventDetailNotifier(ref.watch(eventServiceProvider));
    notifier.loadEvent(eventId);
    return notifier;
  },
);

// Upcoming Events Provider - 현재 로그인된 멤버의 참여 예정 이벤트
final upcomingEventsProvider = StateNotifierProvider<UpcomingEventsNotifier, UpcomingEventsState>((ref) {
  ref.keepAlive();
  return UpcomingEventsNotifier(ref.watch(eventServiceProvider));
});
