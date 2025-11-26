import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/features/group/presentation/widgets/group_search_bar.dart';
import 'package:fitkle/features/group/presentation/widgets/group_category_tabs.dart';
import 'package:fitkle/features/group/presentation/widgets/group_list_view.dart';
import 'package:fitkle/features/group/presentation/widgets/group_filter_bottom_sheet.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> with SingleTickerProviderStateMixin {
  String selectedCategoryCode = 'all';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterVisible = true;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Filter states
  String? selectedLocation = 'all';
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
    Future.microtask(() {
      _onSearchChanged(forceRefresh: false); // 초기 로드는 캐시 사용 가능
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
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

  void _onSearchChanged({bool forceRefresh = true}) {
    final query = searchQuery.isEmpty ? null : searchQuery;
    final category = selectedCategoryCode == 'all' ? null : selectedCategoryCode;
    ref.read(groupProvider.notifier).loadGroups(
          category: category,
          searchQuery: query,
          forceRefresh: forceRefresh,
        );
  }

  void _onCategoryChanged(String categoryCode) {
    setState(() {
      selectedCategoryCode = categoryCode;
    });
    _onSearchChanged();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GroupFilterBottomSheet(
        selectedLocation: selectedLocation,
        selectedMemberSize: selectedMemberSize,
        selectedActivityLevel: selectedActivityLevel,
        onLocationChanged: (value) {
          setState(() => selectedLocation = value);
        },
        onMemberSizeChanged: (value) {
          setState(() => selectedMemberSize = value);
        },
        onActivityLevelChanged: (value) {
          setState(() => selectedActivityLevel = value);
        },
        onApply: _onSearchChanged,
        onReset: () {
          setState(() {
            selectedLocation = 'all';
            selectedMemberSize = 'all';
            selectedActivityLevel = 'all';
          });
          _onSearchChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupProvider);
    final groups = groupState.groups;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            GroupSearchBar(
              controller: _searchController,
              searchQuery: searchQuery,
              onSearchSubmitted: _onSearchChanged,
              onClearPressed: () {
                _searchController.clear();
                setState(() {
                  searchQuery = '';
                });
                _onSearchChanged();
              },
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onFilterPressed: _showFilterBottomSheet,
            ),
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    GroupCategoryTabs(
                      selectedCategoryCode: selectedCategoryCode,
                      onCategoryChanged: _onCategoryChanged,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GroupListView(
                scrollController: _scrollController,
                groupState: groupState,
                groups: groups,
                onRetry: _onSearchChanged,
                onGroupTap: (group) => context.push('/groups/${group.id}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
