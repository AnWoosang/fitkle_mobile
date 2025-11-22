import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/presentation/providers/group_provider.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_scroll_mixin.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_tab_bar_delegate.dart';
import 'package:fitkle/shared/widgets/detail/detail_screen_app_bar.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';
import '../widgets/detail/group_header_image.dart';
import '../widgets/detail/group_title_info.dart';
import '../widgets/detail/group_join_button.dart';
import '../widgets/detail/group_about_tab.dart';
import '../widgets/detail/group_events_tab.dart';
import '../widgets/detail/group_photos_tab.dart';
import '../widgets/detail/group_reviews_tab.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin, DetailScreenScrollMixin {
  bool isJoined = false;
  bool isBookmarked = false;

  @override
  int get tabCount => 4;

  @override
  void initState() {
    super.initState();
    initializeScrolling();
    Future.microtask(() {
      ref
          .read(groupDetailProvider(widget.groupId).notifier)
          .loadGroup(widget.groupId);
    });
  }

  @override
  void dispose() {
    disposeScrolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupDetailProvider(widget.groupId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: groupState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupState.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${groupState.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(groupDetailProvider(widget.groupId).notifier)
                            .loadGroup(widget.groupId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : groupState.group != null
                  ? _buildContent(groupState.group!)
                  : const Center(child: Text('Group not found')),
    );
  }

  Widget _buildContent(GroupEntity group) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        DetailScreenAppBar(
          headerContent: GroupHeaderImage(group: group),
          isCollapsed: isAppBarCollapsed,
          onBackPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/groups');
            }
          },
          actions: [
            DetailAppBarAction(
              icon: Icons.share,
              onPressed: () {},
            ),
            DetailAppBarAction(
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              onPressed: () {
                setState(() => isBookmarked = !isBookmarked);
              },
              isActive: isBookmarked,
              activeColor: AppTheme.primary,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: GroupTitleInfo(
            group: group,
            isAppBarCollapsed: isAppBarCollapsed,
          ),
        ),
        SliverToBoxAdapter(
          child: GroupJoinButton(
            isJoined: isJoined,
            isAppBarCollapsed: isAppBarCollapsed,
            onPressed: () {
              setState(() {
                isJoined = !isJoined;
              });
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: DetailScreenTabBarDelegate(
            tabController: tabController,
            onTap: scrollToSection,
            tabLabels: const ['About', 'Events', 'Photos', 'Reviews'],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            key: sectionKeys[0],
            child: GroupAboutTab(group: group),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            key: sectionKeys[1],
            child: const GroupEventsTab(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            key: sectionKeys[2],
            child: const GroupPhotosTab(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            key: sectionKeys[3],
            child: const GroupReviewsTab(),
          ),
        ),
      ],
    );
  }
}
