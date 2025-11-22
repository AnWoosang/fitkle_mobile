import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/shared/widgets/empty_state.dart';
import 'package:fitkle/shared/widgets/error_state.dart';
import 'package:fitkle/features/event/presentation/widgets/event_search_bar.dart';
import 'package:fitkle/features/event/presentation/widgets/event_tab_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_card.dart';
import 'package:fitkle/features/group/presentation/widgets/group_card.dart';
import 'package:fitkle/features/event/presentation/widgets/event_filter_bottom_sheet.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> with SingleTickerProviderStateMixin {
  String selectedTab = 'group-events'; // 'group-events', 'personal-events', 'groups'
  String selectedCategory = 'ALL';
  String searchQuery = '';
  bool _isFilterVisible = true;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Filter states
  String? selectedLocation = 'all';
  String? selectedDate = 'all';
  String? selectedMemberSize = 'all';
  String? selectedActivityLevel = 'all';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.value = 1.0; // Start visible
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final currentOffset = _scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;

    // 스크롤 방향에 따라 필터 가시성 토글
    if (delta > 5 && _isFilterVisible) {
      // 아래로 스크롤 (위로 드래그) - 필터 숨기기
      setState(() => _isFilterVisible = false);
      _animationController.reverse();
    } else if (delta < -5 && !_isFilterVisible) {
      // 위로 스크롤 (아래로 드래그) - 필터 보이기
      setState(() => _isFilterVisible = true);
      _animationController.forward();
    }

    _lastScrollOffset = currentOffset;
  }

  void _loadData() {
    final category = selectedCategory == 'ALL' ? null : selectedCategory;
    final query = searchQuery.isEmpty ? null : searchQuery;

    if (selectedTab == 'groups') {
      ref.read(groupProvider.notifier).loadGroups(
        category: category,
        searchQuery: query,
      );
    } else {
      // Determine if we should filter by group events or personal events
      final bool? isGroupEvent = selectedTab == 'group-events'
          ? true
          : selectedTab == 'personal-events'
              ? false
              : null;

      ref.read(eventProvider.notifier).loadEvents(
        category: category,
        searchQuery: query,
        isGroupEvent: isGroupEvent,
      );
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventFilterBottomSheet(
        selectedTab: selectedTab,
        selectedLocation: selectedLocation,
        selectedDate: selectedDate,
        selectedMemberSize: selectedMemberSize,
        selectedActivityLevel: selectedActivityLevel,
        onLocationChanged: (value) {
          setState(() => selectedLocation = value);
        },
        onDateChanged: (value) {
          setState(() => selectedDate = value);
        },
        onMemberSizeChanged: (value) {
          setState(() => selectedMemberSize = value);
        },
        onActivityLevelChanged: (value) {
          setState(() => selectedActivityLevel = value);
        },
        onApply: _loadData,
        onReset: () {
          setState(() {
            selectedLocation = 'all';
            selectedDate = 'all';
            selectedMemberSize = 'all';
            selectedActivityLevel = 'all';
          });
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            EventSearchBar(
              searchQuery: searchQuery,
              selectedTab: selectedTab,
              onSearchChanged: (value) {
                setState(() => searchQuery = value);
                _loadData();
              },
              onFilterPressed: _showFilterBottomSheet,
            ),
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: _animation,
                child: EventTabSection(
                  selectedTab: selectedTab,
                  selectedCategory: selectedCategory,
                  onTabChanged: (tab) {
                    setState(() => selectedTab = tab);
                    _loadData();
                  },
                  onCategoryChanged: (category) {
                    setState(() => selectedCategory = category);
                    _loadData();
                  },
                ),
              ),
            ),
            Expanded(
              child: selectedTab == 'groups'
                  ? _buildGroupsList()
                  : _buildEventsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    final eventState = ref.watch(eventProvider);

    if (eventState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventState.errorMessage != null) {
      return ErrorState(
        message: eventState.errorMessage!,
        onRetry: _loadData,
      );
    }

    final events = eventState.events;

    if (events.isEmpty) {
      return const EmptyState(
        icon: Icons.event_busy,
        message: '이벤트가 없습니다',
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => EventCard(
                event: events[index],
                type: EventCardType.list,
              ),
              childCount: events.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  Widget _buildGroupsList() {
    final groupState = ref.watch(groupProvider);

    if (groupState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groupState.errorMessage != null) {
      return ErrorState(
        message: groupState.errorMessage!,
        onRetry: _loadData,
      );
    }

    final groups = groupState.groups;

    if (groups.isEmpty) {
      return const EmptyState(
        icon: Icons.groups,
        message: '그룹이 없습니다',
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GroupCard(group: groups[index]),
              childCount: groups.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}
