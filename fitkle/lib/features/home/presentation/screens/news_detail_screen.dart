import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/detail_action_button.dart';
import 'package:fitkle/shared/widgets/sticky_header_bar.dart';
import 'package:fitkle/features/home/presentation/providers/news_provider.dart';
import 'package:fitkle/features/home/domain/entities/news.dart';
import 'package:fitkle/features/home/presentation/widgets/news_detail_header.dart';
import 'package:fitkle/features/home/presentation/widgets/news_category_breadcrumb.dart';
import 'package:fitkle/features/home/presentation/widgets/news_meta_info.dart';
import 'package:fitkle/features/home/presentation/widgets/news_content_markdown.dart';
import 'package:fitkle/features/home/presentation/widgets/news_like_button.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final String newsId;

  const NewsDetailScreen({
    super.key,
    required this.newsId,
  });

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  bool isLiked = false;

  void _handleLike(News news) {
    setState(() {
      isLiked = !isLiked;
    });
    ref.read(newsProvider.notifier).toggleLike(widget.newsId, !isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsDetailProvider(widget.newsId));

    return newsAsync.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stack) => _buildErrorScreen(error),
      data: (news) => _buildNewsDetail(news),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: DetailBackButton(
          onPressed: () => Navigator.pop(context),
          showBackground: false,
        ),
        title: const Text(
          '뉴스',
          style: TextStyle(
            color: AppTheme.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(Object error) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: DetailBackButton(
          onPressed: () => Navigator.pop(context),
          showBackground: false,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load news',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: AppTheme.mutedForeground),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsDetail(News news) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          StickyHeaderBar(
            title: '뉴스',
            actions: [
              DetailActionButton(
                icon: Icons.share,
                onPressed: () {
                  // TODO: Share functionality
                },
                showBackground: false,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsDetailHeader(news: news),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewsCategoryBreadcrumb(category: news.category),
                      const SizedBox(height: 8),
                      _buildTitle(news),
                      const SizedBox(height: 16),
                      NewsMetaInfo(news: news),
                      NewsContentMarkdown(content: news.content),
                      const SizedBox(height: 24),
                      NewsLikeButton(
                        news: news,
                        isLiked: isLiked,
                        onTap: () => _handleLike(news),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(News news) {
    return Text(
      news.title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }
}
