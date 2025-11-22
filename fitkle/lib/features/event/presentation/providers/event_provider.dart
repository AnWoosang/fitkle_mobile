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
  final String? errorMessage;

  EventState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  EventState copyWith({
    List<EventEntity>? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
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

  EventNotifier(this._eventService, this._categoryService) : super(EventState());

  Future<void> loadEvents({
    String? category, // category code (e.g., 'SOCIAL')
    String? searchQuery,
    bool? isGroupEvent,
    bool forceRefresh = false,
  }) async {
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
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Event Detail Provider
class EventDetailNotifier extends StateNotifier<EventDetailState> {
  final EventService _eventService;

  // 캐싱을 위한 필드
  DateTime? _lastFetchTime;
  static const staleDuration = Duration(hours: 1); // 1시간 캐시 유지

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
