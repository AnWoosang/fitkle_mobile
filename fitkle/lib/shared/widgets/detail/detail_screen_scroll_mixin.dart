import 'package:flutter/material.dart';

/// Mixin providing scroll synchronization between tabs and content sections
/// for detail screens with sticky tab bars.
///
/// This mixin must be used with a State class that also mixes in
/// SingleTickerProviderStateMixin or TickerProviderStateMixin.
mixin DetailScreenScrollMixin<T extends StatefulWidget> on State<T> {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();
  late List<GlobalKey> sectionKeys;
  bool isScrollingProgrammatically = false;
  bool isAppBarCollapsed = false;

  /// Number of tabs/sections in the screen
  int get tabCount;

  /// Height of the expanded AppBar
  double get appBarExpandedHeight => 272.0;

  /// Threshold for scroll detection
  double get scrollThreshold => 150.0;

  /// Initialize scroll management (call in initState)
  void initializeScrolling() {
    sectionKeys = List.generate(tabCount, (_) => GlobalKey());
    tabController = TabController(length: tabCount, vsync: this as TickerProvider);
    scrollController.addListener(onScroll);
  }

  /// Dispose scroll management (call in dispose)
  void disposeScrolling() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    tabController.dispose();
  }

  /// Handle scroll events to sync tab selection and detect AppBar collapse
  void onScroll() {
    if (isScrollingProgrammatically) return;

    // Check if AppBar is collapsed
    final isCollapsed =
        scrollController.offset > appBarExpandedHeight - kToolbarHeight;
    if (isAppBarCollapsed != isCollapsed) {
      setState(() {
        isAppBarCollapsed = isCollapsed;
      });
    }

    // Find which section is currently visible at the top
    for (int i = sectionKeys.length - 1; i >= 0; i--) {
      final context = sectionKeys[i].currentContext;
      if (context != null) {
        final renderObject = context.findRenderObject();
        if (renderObject is RenderBox) {
          final position = renderObject.localToGlobal(Offset.zero);
          final height = renderObject.size.height;

          if (position.dy <= scrollThreshold && position.dy > -height) {
            if (tabController.index != i) {
              tabController.animateTo(i);
            }
            break;
          }
        }
      }
    }
  }

  /// Programmatically scroll to a specific section
  void scrollToSection(int tabIndex) {
    final context = sectionKeys[tabIndex].currentContext;
    if (context != null) {
      isScrollingProgrammatically = true;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 350), () {
          isScrollingProgrammatically = false;
        });
      });
    }
  }
}
