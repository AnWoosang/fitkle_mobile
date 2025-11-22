import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class InterestsSection extends StatelessWidget {
  final List<String> selectedInterests;
  final String notificationRadius;
  final String interestSearchQuery;
  final List<Map<String, String>> filteredInterests;
  final Function(String) onToggleInterest;
  final Function(String) onNotificationRadiusChanged;
  final Function(String) onSearchQueryChanged;
  final VoidCallback onClearAllInterests;
  final VoidCallback onSaveInterests;
  final String Function(String) getInterestEmoji;

  const InterestsSection({
    super.key,
    required this.selectedInterests,
    required this.notificationRadius,
    required this.interestSearchQuery,
    required this.filteredInterests,
    required this.onToggleInterest,
    required this.onNotificationRadiusChanged,
    required this.onSearchQueryChanged,
    required this.onClearAllInterests,
    required this.onSaveInterests,
    required this.getInterestEmoji,
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
          // Header with notification radius
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border, size: 20, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Get notified about groups that match your interests',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNotificationRadiusSelector(),

          if (selectedInterests.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildSelectedInterests(),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Search & Browse
          _buildSearchSection(),

          if (interestSearchQuery.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSearchResults(),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Available Interests
          _buildAvailableInterests(),

          if (selectedInterests.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationRadiusSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Notify me about new groups within:',
              style: TextStyle(fontSize: 14),
            ),
          ),
          DropdownButton<String>(
            value: notificationRadius,
            items: const [
              DropdownMenuItem(value: '10 mi', child: Text('10 mi')),
              DropdownMenuItem(value: '25 mi', child: Text('25 mi')),
              DropdownMenuItem(value: '50 mi', child: Text('50 mi')),
              DropdownMenuItem(value: '100 mi', child: Text('100 mi')),
            ],
            onChanged: (value) => onNotificationRadiusChanged(value!),
            underline: Container(),
          ),
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withValues(alpha: 0.05),
                AppTheme.primary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedInterests.map((interest) {
              return GestureDetector(
                onTap: () => onToggleInterest(interest),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getInterestEmoji(interest),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.close, size: 14),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.search, color: AppTheme.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Discover More',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: onSearchQueryChanged,
          decoration: InputDecoration(
            hintText: 'Type to search...',
            suffixIcon: const Icon(Icons.search, size: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Found ${filteredInterests.length} interests matching "$interestSearchQuery"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[900],
            ),
          ),
          TextButton(
            onPressed: () => onSearchQueryChanged(''),
            child: const Row(
              children: [
                Icon(Icons.close, size: 16),
                SizedBox(width: 4),
                Text('Clear'),
              ],
            ),
          ),
        ],
      ),
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
        if (filteredInterests.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: filteredInterests.take(40).map((interest) {
              final label = interest['label'] as String;
              final emoji = interest['emoji'] as String;
              return GestureDetector(
                onTap: () => onToggleInterest(label),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.add, size: 14),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(Icons.search, size: 64, color: AppTheme.mutedForeground),
                  SizedBox(height: 16),
                  Text(
                    'No interests found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try a different search term or browse by category',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: onSaveInterests,
        icon: const Icon(Icons.favorite, size: 16),
        label: const Text('Save Interests'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        ),
      ),
    );
  }
}
