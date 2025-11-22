# Error Handling System

Flutter 앱의 전역 에러 처리 시스템입니다.

## 구성 요소

### 1. ErrorHandler (`error_handler.dart`)
전역 에러 핸들러로 모든 에러를 캐치하고 로깅합니다.

```dart
// 에러 처리
try {
  // 위험한 작업
} catch (e, stackTrace) {
  ErrorHandler.handleError(e, stackTrace);
}

// Exception을 Failure로 변환
final failure = ErrorHandler.handleException(exception);
```

### 2. Logger (`core/utils/logger.dart`)
컬러풀한 콘솔 로깅 유틸리티입니다.

```dart
// 다양한 로그 레벨
Logger.info('정보 메시지', tag: 'MyFeature');
Logger.success('성공 메시지');
Logger.warning('경고 메시지');
Logger.error('에러 메시지', error: e, stackTrace: stack);
Logger.debug('디버그 메시지');

// 네트워크 로깅
Logger.request('POST', '/api/users', data: {'name': 'John'});
Logger.response(200, '/api/users', data: responseData);

// 구분선
Logger.divider(title: '섹션 제목');
```

### 3. Custom Error Widgets (`error_widget.dart`)

#### AppErrorWidget
앱 크래시 시 보여지는 전역 에러 위젯입니다.

#### ErrorPage
앱 내에서 사용할 수 있는 에러 페이지입니다.

```dart
// 사용 예시
if (state.hasError) {
  return ErrorPage(
    message: state.errorMessage,
    onRetry: () => loadData(),
  );
}
```

## 전역 에러 처리 설정

`main.dart`에서 자동으로 설정됩니다:

```dart
void main() async {
  runZonedGuarded(
    () async {
      // Flutter 에러 핸들링
      FlutterError.onError = (details) {
        ErrorHandler.handleError(details.exception, details.stack);
      };

      // 커스텀 에러 위젯
      ErrorWidget.builder = (details) {
        return AppErrorWidget(errorDetails: details);
      };

      runApp(MyApp());
    },
    // Zone 밖 에러 캐치
    (error, stack) {
      ErrorHandler.handleError(error, stack);
    },
  );
}
```

## 에러 타입

### Exceptions (`exceptions.dart`)
- `ServerException`: 서버 에러
- `CacheException`: 캐시 에러
- `NetworkException`: 네트워크 에러
- `AuthException`: 인증 에러

### Failures (`failures.dart`)
- `ServerFailure`: 서버 실패
- `CacheFailure`: 캐시 실패
- `NetworkFailure`: 네트워크 실패
- `AuthFailure`: 인증 실패

## Repository에서 에러 처리 예시

모든 Repository에는 자동으로 상세한 로깅이 포함됩니다:

```dart
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({
    String? category,
    String? searchQuery,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // 요청 시작 로깅
        Logger.info(
          'Fetching events (category: $category, search: $searchQuery)',
          tag: 'EventRepository',
        );

        final events = await remoteDataSource.getEvents(
          category: category,
          searchQuery: searchQuery,
        );

        // 성공 로깅
        Logger.success(
          'Fetched ${events.length} events',
          tag: 'EventRepository',
        );
        return Right(events);
      } on ServerException catch (e) {
        // 서버 에러 로깅
        Logger.error(
          'Server error while fetching events',
          tag: 'EventRepository',
          error: e,
        );
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        // 네트워크 에러 로깅
        Logger.error(
          'Network error while fetching events',
          tag: 'EventRepository',
          error: e,
        );
        return Left(NetworkFailure(e.message));
      }
    } else {
      // 네트워크 연결 없음 경고
      Logger.warning('No internet connection', tag: 'EventRepository');
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
```

## Provider에서 에러 처리 예시

모든 Provider/Notifier에는 자동으로 상세한 로깅이 포함됩니다:

```dart
class EventNotifier extends StateNotifier<EventState> {
  final GetEvents getEventsUseCase;

  EventNotifier(this.getEventsUseCase) : super(EventState());

  Future<void> loadEvents({String? category, String? searchQuery}) async {
    // 로딩 시작 로깅
    Logger.info('Loading events...', tag: 'EventProvider');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getEventsUseCase(
      GetEventsParams(category: category, searchQuery: searchQuery),
    );

    result.fold(
      (failure) {
        // 에러 발생시 자동 로깅
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
        // 성공시 자동 로깅
        Logger.success(
          'Loaded ${events.length} events',
          tag: 'EventProvider',
        );
        state = state.copyWith(
          events: events,
          isLoading: false,
        );
      },
    );
  }
}
```

## 로그 출력 예시

앱 실행 시 다음과 같은 컬러풀한 로그가 자동으로 출력됩니다:

```
ℹ️  INFO [EventRepository] Fetching events (category: sports, search: null)
✅ SUCCESS [EventRepository] Fetched 15 events
ℹ️  INFO [EventProvider] Loading events...
✅ SUCCESS [EventProvider] Loaded 15 events

ℹ️  INFO [GroupRepository] Fetching group: abc123
✅ SUCCESS [GroupRepository] Fetched group: Soccer Enthusiasts
ℹ️  INFO [GroupDetailProvider] Loading group: abc123
✅ SUCCESS [GroupDetailProvider] Loaded group: Soccer Enthusiasts

⚠️  WARNING [EventRepository] No internet connection
🔴 ERROR [EventProvider] Failed to load events: No internet connection
   Error: NetworkFailure: No internet connection

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ERROR OCCURRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 ERROR Error Type: ServerException
Error Message: Failed to fetch data
   Error: ServerException: Failed to fetch data
   Stack: #0 ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

각 레이어에서의 로깅:
- **Repository**: 데이터 소스와의 통신 (요청, 응답, 에러)
- **Provider**: 상태 관리 레벨 (로딩 시작, 성공, 실패)
- **Global Error Handler**: 캐치되지 않은 모든 에러

## Production 에러 리포팅

Production 환경에서는 Sentry나 Firebase Crashlytics 같은 서비스로 에러를 전송할 수 있습니다:

```dart
// error_handler.dart에서 TODO 부분 구현
if (kReleaseMode) {
  // Sentry 예시
  await Sentry.captureException(
    error,
    stackTrace: stackTrace,
  );

  // Firebase Crashlytics 예시
  await FirebaseCrashlytics.instance.recordError(
    error,
    stackTrace,
    fatal: true,
  );
}
```

## 자동 로깅 시스템

이 프로젝트의 모든 Repository와 Provider는 자동으로 로깅을 수행합니다:

### Repository 레벨
- ✅ 모든 데이터 요청 시작 시 로깅
- ✅ 성공 시 결과 개수/내용 로깅
- ✅ 실패 시 에러 타입과 메시지 로깅
- ✅ 네트워크 연결 상태 로깅

### Provider 레벨
- ✅ 상태 변경 시작 시 로깅
- ✅ 데이터 로드 성공 시 로깅
- ✅ 실패 시 Failure 객체 로깅

### UI 레벨에서의 에러 처리

UI에서는 `errorMessage`만 확인하면 됩니다. 로깅은 자동으로 됩니다:

```dart
// UI에서는 단순히 에러 메시지만 표시
if (state.errorMessage != null) {
  return ErrorPage(
    message: state.errorMessage,
    onRetry: () => loadData(),
  );
}
```

모든 에러는 자동으로 로깅되므로 개발자 콘솔에서 상세 정보를 확인할 수 있습니다.

## 베스트 프랙티스

1. **자동 로깅 활용**: Repository와 Provider는 이미 로깅이 되어 있으므로 별도 추가 불필요
2. **UI에서는 에러만 표시**: `errorMessage`를 사용자에게 보여주기만 하면 됨
3. **태그로 추적**: 콘솔에서 `[EventRepository]`, `[EventProvider]` 등의 태그로 로그 필터링 가능
4. **개발 중에는 콘솔 확인**: 모든 데이터 흐름이 컬러풀하게 로깅됨
5. **Production에서는 Sentry/Crashlytics로 전송**: `error_handler.dart`의 TODO 부분 구현
