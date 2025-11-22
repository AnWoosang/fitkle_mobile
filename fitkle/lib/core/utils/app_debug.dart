import 'package:flutter/material.dart';

/// 앱 전체의 에러와 경고를 디버깅하는 유틸리티
class AppDebug {
  static final List<DebugLog> _logs = [];
  static const int maxLogs = 100;

  /// 앱 디버깅 시스템 초기화
  static void initialize() {
    _setupFlutterErrorHandler();
    _setupZoneErrorHandler();
    debugPrint('🔧 App Debug System Initialized');
  }

  /// Flutter 에러 핸들러 설정
  static void _setupFlutterErrorHandler() {
    final originalOnError = FlutterError.onError;

    FlutterError.onError = (FlutterErrorDetails details) {
      _logFlutterError(details);

      // 원래 핸들러도 호출
      if (originalOnError != null) {
        originalOnError(details);
      } else {
        FlutterError.presentError(details);
      }
    };
  }

  /// Zone 에러 핸들러는 main.dart의 runZonedGuarded에서 처리
  static void _setupZoneErrorHandler() {
    // Zone errors are handled in main.dart's runZonedGuarded
  }

  /// Flutter 에러 로깅
  static void _logFlutterError(FlutterErrorDetails details) {
    final errorType = _categorizeError(details.exception.toString());

    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('${_getErrorIcon(errorType)} ${errorType.toUpperCase()} ERROR DETECTED');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📋 Summary: ${details.exceptionAsString()}');
    debugPrint('');
    debugPrint('💡 Context:');
    debugPrint('   Library: ${details.library ?? "Unknown"}');
    if (details.context != null) {
      debugPrint('   Context: ${details.context}');
    }
    debugPrint('');
    debugPrint('📍 Stack Trace:');
    debugPrint(details.stack?.toString() ?? 'No stack trace available');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.error,
      category: errorType,
      message: details.exceptionAsString(),
      stackTrace: details.stack?.toString(),
    ));
  }

  /// 일반 에러 로깅 (main.dart의 runZonedGuarded에서 호출)
  static void logError(Object error, StackTrace? stack, {String? context}) {
    final errorType = _categorizeError(error.toString());

    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('${_getErrorIcon(errorType)} ${errorType.toUpperCase()} ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📋 Error: $error');
    if (context != null) {
      debugPrint('');
      debugPrint('💡 Context: $context');
    }
    debugPrint('');
    debugPrint('📍 Stack Trace:');
    debugPrint(stack?.toString() ?? 'No stack trace available');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.error,
      category: errorType,
      message: error.toString(),
      stackTrace: stack?.toString(),
      context: context,
    ));
  }

  /// 경고 로깅
  static void logWarning(String message, {String? context, StackTrace? stack}) {
    debugPrint('');
    debugPrint('⚠️ WARNING: $message');
    if (context != null) {
      debugPrint('   Context: $context');
    }
    if (stack != null) {
      debugPrint('   Stack: ${stack.toString()}');
    }
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.warning,
      category: 'warning',
      message: message,
      context: context,
      stackTrace: stack?.toString(),
    ));
  }

  /// 네트워크 에러 로깅
  static void logNetworkError(
    String endpoint,
    Object error, {
    int? statusCode,
    String? method,
    Map<String, dynamic>? data,
  }) {
    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🌐 NETWORK ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📍 Endpoint: ${method ?? "GET"} $endpoint');
    if (statusCode != null) {
      debugPrint('📊 Status Code: $statusCode');
    }
    debugPrint('');
    debugPrint('❌ Error: $error');
    if (data != null) {
      debugPrint('');
      debugPrint('📦 Request Data: $data');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.error,
      category: 'network',
      message: 'Network error at $endpoint: $error',
      context: 'Status: $statusCode, Method: $method',
    ));
  }

  /// 네비게이션 에러 로깅
  static void logNavigationError(String route, Object error, {StackTrace? stack}) {
    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🧭 NAVIGATION ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📍 Route: $route');
    debugPrint('❌ Error: $error');
    if (stack != null) {
      debugPrint('');
      debugPrint('📍 Stack Trace:');
      debugPrint(stack.toString());
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.error,
      category: 'navigation',
      message: 'Navigation error at $route: $error',
      stackTrace: stack?.toString(),
    ));
  }

  /// State 에러 로깅 (Riverpod 등)
  static void logStateError(String provider, Object error, {StackTrace? stack}) {
    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📦 STATE MANAGEMENT ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📍 Provider: $provider');
    debugPrint('❌ Error: $error');
    if (stack != null) {
      debugPrint('');
      debugPrint('📍 Stack Trace:');
      debugPrint(stack.toString());
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');

    _addLog(DebugLog(
      timestamp: DateTime.now(),
      level: DebugLevel.error,
      category: 'state',
      message: 'State error in $provider: $error',
      stackTrace: stack?.toString(),
    ));
  }

  /// 에러 타입 분류
  static String _categorizeError(String errorString) {
    if (errorString.contains('RenderFlex overflowed') ||
        errorString.contains('BoxConstraints') ||
        errorString.contains('overflow')) {
      return 'overflow';
    } else if (errorString.contains('Null check') ||
        errorString.contains('null') ||
        errorString.contains('Null')) {
      return 'null-safety';
    } else if (errorString.contains('State') ||
        errorString.contains('setState')) {
      return 'state';
    } else if (errorString.contains('http') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return 'network';
    } else if (errorString.contains('route') ||
        errorString.contains('navigation')) {
      return 'navigation';
    } else if (errorString.contains('image') ||
        errorString.contains('asset')) {
      return 'asset';
    } else {
      return 'general';
    }
  }

  /// 에러 타입별 아이콘
  static String _getErrorIcon(String errorType) {
    switch (errorType) {
      case 'overflow':
        return '📏';
      case 'null-safety':
        return '⚠️';
      case 'state':
        return '📦';
      case 'network':
        return '🌐';
      case 'navigation':
        return '🧭';
      case 'asset':
        return '🖼️';
      default:
        return '🔴';
    }
  }

  /// 로그 추가
  static void _addLog(DebugLog log) {
    _logs.add(log);
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }
  }

  /// 모든 로그 가져오기
  static List<DebugLog> getLogs({DebugLevel? level, String? category}) {
    var logs = List<DebugLog>.from(_logs);

    if (level != null) {
      logs = logs.where((log) => log.level == level).toList();
    }

    if (category != null) {
      logs = logs.where((log) => log.category == category).toList();
    }

    return logs;
  }

  /// 로그 초기화
  static void clearLogs() {
    _logs.clear();
    debugPrint('🧹 Debug logs cleared');
  }

  /// 로그 요약 출력
  static void printSummary() {
    final errors = _logs.where((log) => log.level == DebugLevel.error).length;
    final warnings = _logs.where((log) => log.level == DebugLevel.warning).length;

    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📊 DEBUG LOG SUMMARY');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔴 Errors: $errors');
    debugPrint('⚠️ Warnings: $warnings');
    debugPrint('📝 Total Logs: ${_logs.length}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
  }
}

/// 디버그 로그 모델
class DebugLog {
  final DateTime timestamp;
  final DebugLevel level;
  final String category;
  final String message;
  final String? context;
  final String? stackTrace;

  DebugLog({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.context,
    this.stackTrace,
  });

  @override
  String toString() {
    return '[${timestamp.toIso8601String()}] ${level.name.toUpperCase()} [$category] $message';
  }
}

/// 디버그 레벨
enum DebugLevel {
  error,
  warning,
  info,
}

// ==========================================
// 오버플로우 디버깅 유틸리티 (기존 기능 유지)
// ==========================================

/// 위젯의 실제 렌더링된 크기를 측정하는 위젯
class MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const MeasureSize({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSize());
    return widget.child;
  }

  void _getSize() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final newSize = renderBox.size;
      if (oldSize != newSize) {
        oldSize = newSize;
        widget.onChange(newSize);
      }
    }
  }
}

/// 카드 내부 컨텐츠의 오버플로우를 체크하는 래퍼
class CardOverflowDebugger extends StatelessWidget {
  final Widget child;
  final String cardId;

  const CardOverflowDebugger({
    super.key,
    required this.child,
    required this.cardId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight.isInfinite) {
          AppDebug.logWarning(
            'Card has INFINITE height constraint',
            context: 'Card ID: $cardId',
          );
        }
        if (constraints.maxWidth.isInfinite) {
          AppDebug.logWarning(
            'Card has INFINITE width constraint',
            context: 'Card ID: $cardId',
          );
        }

        return MeasureSize(
          onChange: (Size size) {
            if (size.height > constraints.maxHeight && !constraints.maxHeight.isInfinite) {
              AppDebug.logWarning(
                'Height overflow detected',
                context: 'Card: $cardId, Content: ${size.height}px, Available: ${constraints.maxHeight}px, Overflow: ${size.height - constraints.maxHeight}px',
              );
            }
            if (size.width > constraints.maxWidth && !constraints.maxWidth.isInfinite) {
              AppDebug.logWarning(
                'Width overflow detected',
                context: 'Card: $cardId, Content: ${size.width}px, Available: ${constraints.maxWidth}px, Overflow: ${size.width - constraints.maxWidth}px',
              );
            }
          },
          child: child,
        );
      },
    );
  }
}

/// 오버플로우가 발생할 수 있는 영역을 감지하고 표시하는 위젯
class OverflowDetector extends StatelessWidget {
  final Widget child;
  final String label;
  final bool showBorder;

  const OverflowDetector({
    super.key,
    required this.child,
    required this.label,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: showBorder
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.5),
                    width: 1,
                  ),
                )
              : null,
          child: Stack(
            children: [
              child,
              if (showBorder)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.orange.withValues(alpha: 0.8),
                    child: Text(
                      '$label (${constraints.maxWidth.toStringAsFixed(1)}w x ${constraints.maxHeight.toStringAsFixed(1)}h)',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
