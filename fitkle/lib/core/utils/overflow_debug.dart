import 'package:flutter/material.dart';

/// 오버플로우 디버깅을 위한 유틸리티
class OverflowDebug {
  /// 오버플로우 에러를 캐치하고 로깅하는 글로벌 핸들러 설정
  static void setupGlobalHandler() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is FlutterError) {
        final error = details.exception as FlutterError;
        if (error.toString().contains('RenderFlex overflowed') ||
            error.toString().contains('BoxConstraints')) {
          _logOverflowError(details);
        }
      }
      // 기본 에러 핸들러도 호출
      FlutterError.presentError(details);
    };
  }

  /// 오버플로우 에러를 자세히 로깅
  static void _logOverflowError(FlutterErrorDetails details) {
    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔴 OVERFLOW ERROR DETECTED');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('Error: ${details.exception}');
    debugPrint('');
    debugPrint('📍 Stack Trace:');
    debugPrint(details.stack.toString());
    debugPrint('');
    debugPrint('💡 Library:');
    debugPrint(details.library ?? 'Unknown library');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
  }

  /// 위젯을 디버그 컨테이너로 감싸서 크기와 제약 조건을 로깅
  static Widget debugWrapper({
    required Widget child,
    required String widgetName,
    Color borderColor = Colors.red,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('');
        debugPrint('📊 [$widgetName] Layout Debug Info:');
        debugPrint('   Max Width: ${constraints.maxWidth}');
        debugPrint('   Max Height: ${constraints.maxHeight}');
        debugPrint('   Min Width: ${constraints.minWidth}');
        debugPrint('   Min Height: ${constraints.minHeight}');
        debugPrint('   Has Bounded Width: ${constraints.hasBoundedWidth}');
        debugPrint('   Has Bounded Height: ${constraints.hasBoundedHeight}');

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
          ),
          child: child,
        );
      },
    );
  }

  /// GridView의 각 아이템 크기를 측정하고 로깅
  static Widget measureGridItem({
    required Widget child,
    required int index,
    required String listName,
  }) {
    return MeasureSize(
      onChange: (Size size) {
        debugPrint('📏 [$listName] Item $index size: ${size.width} x ${size.height}');
      },
      child: child,
    );
  }
}

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
        // 카드의 제약 조건 로깅
        if (constraints.maxHeight.isInfinite) {
          debugPrint('⚠️ [$cardId] Card has INFINITE height constraint!');
        }
        if (constraints.maxWidth.isInfinite) {
          debugPrint('⚠️ [$cardId] Card has INFINITE width constraint!');
        }

        return MeasureSize(
          onChange: (Size size) {
            if (size.height > constraints.maxHeight && !constraints.maxHeight.isInfinite) {
              debugPrint('');
              debugPrint('🔴 OVERFLOW DETECTED in [$cardId]');
              debugPrint('   Content Height: ${size.height}');
              debugPrint('   Available Height: ${constraints.maxHeight}');
              debugPrint('   Overflow: ${size.height - constraints.maxHeight}px');
              debugPrint('');
            }
            if (size.width > constraints.maxWidth && !constraints.maxWidth.isInfinite) {
              debugPrint('');
              debugPrint('🔴 OVERFLOW DETECTED in [$cardId]');
              debugPrint('   Content Width: ${size.width}');
              debugPrint('   Available Width: ${constraints.maxWidth}');
              debugPrint('   Overflow: ${size.width - constraints.maxWidth}px');
              debugPrint('');
            }
          },
          child: child,
        );
      },
    );
  }
}
