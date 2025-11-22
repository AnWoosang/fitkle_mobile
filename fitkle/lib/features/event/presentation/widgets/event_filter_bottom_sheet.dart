import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class EventFilterBottomSheet extends StatefulWidget {
  final String selectedTab;
  final String? selectedLocation;
  final String? selectedDate;
  final String? selectedMemberSize;
  final String? selectedActivityLevel;
  final Function(String?) onLocationChanged;
  final Function(String?) onDateChanged;
  final Function(String?) onMemberSizeChanged;
  final Function(String?) onActivityLevelChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const EventFilterBottomSheet({
    super.key,
    required this.selectedTab,
    this.selectedLocation,
    this.selectedDate,
    this.selectedMemberSize,
    this.selectedActivityLevel,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onMemberSizeChanged,
    required this.onActivityLevelChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<EventFilterBottomSheet> createState() => _EventFilterBottomSheetState();
}

class _EventFilterBottomSheetState extends State<EventFilterBottomSheet> {
  late String? tempLocation;
  late String? tempDate;
  late String? tempMemberSize;
  late String? tempActivityLevel;

  @override
  void initState() {
    super.initState();
    tempLocation = widget.selectedLocation;
    tempDate = widget.selectedDate;
    tempMemberSize = widget.selectedMemberSize;
    tempActivityLevel = widget.selectedActivityLevel;
  }

  int get activeFilterCount {
    int count = 0;
    if (tempLocation != null && tempLocation != 'all') count++;
    if (tempDate != null && tempDate != 'all') count++;
    if (tempMemberSize != null && tempMemberSize != 'all') count++;
    if (tempActivityLevel != null && tempActivityLevel != 'all') count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      tempLocation = 'all';
      tempDate = 'all';
      tempMemberSize = 'all';
      tempActivityLevel = 'all';
    });
    widget.onReset();
  }

  void _applyFilters() {
    widget.onLocationChanged(tempLocation);
    widget.onDateChanged(tempDate);
    widget.onMemberSizeChanged(tempMemberSize);
    widget.onActivityLevelChanged(tempActivityLevel);
    widget.onApply();
  }

  int get resultCount {
    // TODO: Calculate actual filtered results count
    return 42; // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    final isGroupsTab = widget.selectedTab == 'groups';

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '필터',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isGroupsTab ? '원하는 그룹을 찾아보세요' : '원하는 이벤트를 찾아보세요',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Filter
                  _buildFilterSection(
                    icon: Icons.location_on,
                    title: '위치',
                    child: _buildLocationFilter(),
                  ),
                  const SizedBox(height: 24),

                  // Date Filter - Only for Events
                  if (!isGroupsTab) ...[
                    _buildFilterSection(
                      icon: Icons.calendar_today,
                      title: '날짜',
                      child: _buildDateFilter(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Member Size Filter - Only for Groups
                  if (isGroupsTab) ...[
                    _buildFilterSection(
                      icon: Icons.people,
                      title: '멤버 수',
                      child: _buildMemberSizeFilter(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Activity Level Filter - Only for Groups
                  if (isGroupsTab) ...[
                    _buildFilterSection(
                      icon: Icons.trending_up,
                      title: '활동 수준',
                      child: _buildActivityLevelFilter(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action Buttons - Fixed at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border(
                top: BorderSide(
                  color: AppTheme.border.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeFilterCount > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '적용된 필터: $activeFilterCount',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text(
                          '전체 초기화',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _resetFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: AppTheme.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Text('초기화'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text('결과 보기 ($resultCount)'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildLocationFilter() {
    final locations = [
      {'value': 'all', 'label': '전체'},
      {'value': 'seoul', 'label': '서울'},
      {'value': 'gangnam', 'label': '강남'},
      {'value': 'hongdae', 'label': '홍대'},
      {'value': 'itaewon', 'label': '이태원'},
      {'value': 'gangbuk', 'label': '강북'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        final isSelected = tempLocation == location['value'];

        return _buildFilterButton(
          label: location['label']!,
          isSelected: isSelected,
          onTap: () => setState(() => tempLocation = location['value']),
        );
      },
    );
  }

  Widget _buildDateFilter() {
    final dates = [
      {'value': 'all', 'label': '모든 날짜'},
      {'value': 'today', 'label': '오늘'},
      {'value': 'thisWeek', 'label': '이번 주'},
      {'value': 'thisMonth', 'label': '이번 달'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final isSelected = tempDate == date['value'];

        return _buildFilterButton(
          label: date['label']!,
          isSelected: isSelected,
          onTap: () => setState(() => tempDate = date['value']),
        );
      },
    );
  }

  Widget _buildMemberSizeFilter() {
    final sizes = [
      {'value': 'all', 'label': '전체'},
      {'value': 'small', 'label': '소규모 (<50)'},
      {'value': 'medium', 'label': '중규모 (50-150)'},
      {'value': 'large', 'label': '대규모 (150+)'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final size = sizes[index];
        final isSelected = tempMemberSize == size['value'];

        return _buildFilterButton(
          label: size['label']!,
          isSelected: isSelected,
          onTap: () => setState(() => tempMemberSize = size['value']),
        );
      },
    );
  }

  Widget _buildActivityLevelFilter() {
    final levels = [
      {'value': 'all', 'label': '전체'},
      {'value': 'active', 'label': '매우 활발 (10+)'},
      {'value': 'moderate', 'label': '보통 (5-10)'},
      {'value': 'new', 'label': '신규 (<5)'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        final isSelected = tempActivityLevel == level['value'];

        return _buildFilterButton(
          label: level['label']!,
          isSelected: isSelected,
          onTap: () => setState(() => tempActivityLevel = level['value']),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : AppTheme.muted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
