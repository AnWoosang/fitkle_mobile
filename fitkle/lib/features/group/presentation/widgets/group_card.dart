import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/features/group/domain/entities/group_entity.dart';

enum GroupCardSize { small, large }

/// Common group card widget used throughout the app
/// Supports both small (grid) and large (list) layouts
class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final GroupCardSize size;
  final double? width;
  final VoidCallback? onTap;

  const GroupCard({
    super.key,
    required this.group,
    this.size = GroupCardSize.large,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return size == GroupCardSize.small
        ? _buildSmallCard(context)
        : _buildLargeCard(context);
  }

  // Small card for grid layout (home screen)
  Widget _buildSmallCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/groups/${group.id}'),
      child: Container(
        width: width,
        height: 244,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSmallImage(),
            Expanded(child: _buildSmallInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: group.thumbnailImageUrl,
        width: double.infinity,
        height: 120,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary.withValues(alpha: 0.3),
                AppTheme.primary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary.withValues(alpha: 0.3),
                AppTheme.primary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.image,
              size: 32,
              color: AppTheme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            group.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 12,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${group.totalMembers} members',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${group.eventCount} events',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  group.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Large card for list layout (groups tab)
  Widget _buildLargeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () => context.push('/groups/${group.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLargeImage(),
            _buildLargeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: CachedNetworkImage(
        imageUrl: group.thumbnailImageUrl,
        height: 192,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppTheme.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.image, size: 48),
        ),
      ),
    );
  }

  Widget _buildLargeInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '${group.totalMembers} members',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '•',
                style: TextStyle(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '${group.eventCount} events',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            group.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentSage.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Mock Category',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.foreground,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.person,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  group.hostName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
