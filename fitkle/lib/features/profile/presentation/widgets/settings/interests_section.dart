import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/selectable_badge.dart';
import 'package:fitkle/shared/widgets/searchable_selection_box.dart';

class InterestsSection extends StatelessWidget {
  final List<String> selectedInterests;
  final String interestSearchQuery;
  final List<Map<String, String>> filteredInterests;
  final Function(String) onToggleInterest;
  final Function(String) onSearchQueryChanged;
  final VoidCallback onClearAllInterests;
  final VoidCallback onSaveInterests;
  final String Function(String) getInterestEmoji;
  final bool Function(String) isNewInterest;
  final bool hasChanges;

  const InterestsSection({
    super.key,
    required this.selectedInterests,
    required this.interestSearchQuery,
    required this.filteredInterests,
    required this.onToggleInterest,
    required this.onSearchQueryChanged,
    required this.onClearAllInterests,
    required this.onSaveInterests,
    required this.getInterestEmoji,
    required this.isNewInterest,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 768),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Interests',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your interests to personalize your experience',
            style: TextStyle(
              color: AppTheme.mutedForeground,
              fontSize: 12
            ),
          ),

          if (selectedInterests.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildSelectedInterests(),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Available Interests with Search
          _buildAvailableInterests(),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSelectedInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Your Interests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${selectedInterests.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onClearAllInterests,
              icon: const Icon(Icons.close, size: 16, color: Colors.red),
              label: const Text(
                'Clear all',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: selectedInterests.map((interest) {
            return SelectableBadge(
              emoji: getInterestEmoji(interest),
              label: interest,
              isSelected: true,
              onTap: () => onToggleInterest(interest),
              trailingIcon: Icons.close,
              isNew: isNewInterest(interest),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailableInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.add, color: AppTheme.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Add More Interests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${filteredInterests.length} available',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Searchable selection box
        SearchableSelectionBox(
          searchHint: 'Search interests...',
          onSearchChanged: onSearchQueryChanged,
          items: filteredInterests,
          onItemTap: onToggleInterest,
          emptyTitle: 'No interests found',
          emptyMessage: 'Try a different search term or browse by category',
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: hasChanges ? onSaveInterests : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: const Text('Save Changes'),
      ),
    );
  }
}
