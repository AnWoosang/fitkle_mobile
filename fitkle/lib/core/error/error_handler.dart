import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/utils/logger.dart';

/// Global error handler for the application
class ErrorHandler {
  /// Handle and log errors
  static void handleError(dynamic error, StackTrace? stackTrace) {
    Logger.divider(title: 'ERROR OCCURRED');
    Logger.error(
      'Error Type: ${error.runtimeType}\nError Message: $error',
      error: error,
      stackTrace: stackTrace,
    );
    Logger.divider();

    // TODO: In production, send to error reporting service (e.g., Sentry, Firebase Crashlytics)
    // if (kReleaseMode) {
    //   ErrorReportingService.reportError(error, stackTrace);
    // }
  }

  /// Convert exceptions to user-friendly failure messages
  static Failure handleException(dynamic exception) {
    Logger.debug('Converting exception to Failure: ${exception.runtimeType}');

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else {
      return ServerFailure('예상치 못한 오류가 발생했습니다: ${exception.toString()}');
    }
  }

  /// Log info messages (deprecated - use Logger.info instead)
  @Deprecated('Use Logger.info instead')
  static void logInfo(String message, {String? tag}) {
    Logger.info(message, tag: tag);
  }

  /// Log warning messages (deprecated - use Logger.warning instead)
  @Deprecated('Use Logger.warning instead')
  static void logWarning(String message, {String? tag}) {
    Logger.warning(message, tag: tag);
  }

  /// Log success messages (deprecated - use Logger.success instead)
  @Deprecated('Use Logger.success instead')
  static void logSuccess(String message, {String? tag}) {
    Logger.success(message, tag: tag);
  }

  /// Log network requests (deprecated - use Logger.request instead)
  @Deprecated('Use Logger.request instead')
  static void logRequest(String method, String url, {Map<String, dynamic>? data}) {
    Logger.request(method, url, data: data);
  }

  /// Log network responses (deprecated - use Logger.response instead)
  @Deprecated('Use Logger.response instead')
  static void logResponse(int statusCode, String url, {dynamic data}) {
    Logger.response(statusCode, url, data: data);
  }
}
