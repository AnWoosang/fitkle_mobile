import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/sticky_header_bar.dart';
import 'package:fitkle/features/event/presentation/widgets/event_type_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_basic_info_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_datetime_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_location_section.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String eventType = 'personal'; // personal or group
  String? selectedGroupId;
  String title = '';
  String description = '';
  String category = '';
  String date = '';
  String time = '';
  bool isRecurring = false;
  String locationType = 'offline'; // offline or online
  String location = '';
  String detailedAddress = '';
  String onlineLink = '';
  String maxAttendees = '';

  final List<Map<String, String>> categories = [
    {'name': 'Social', 'emoji': '☕'},
    {'name': 'Outdoor', 'emoji': '🏞️'},
    {'name': 'Workshop', 'emoji': '🎨'},
    {'name': 'Fitness', 'emoji': '💪'},
    {'name': 'Arts', 'emoji': '🎭'},
    {'name': 'Language', 'emoji': '📚'},
  ];

  void _handleEventTypeChanged(String type) {
    setState(() {
      eventType = type;
      if (type == 'personal') {
        selectedGroupId = null;
      }
    });
  }

  void _handleLocationTypeChanged(String type) {
    setState(() {
      locationType = type;
      if (type == 'offline') {
        onlineLink = '';
      } else {
        location = '';
        detailedAddress = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          StickyHeaderBar(
            title: '이벤트 만들기',
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  EventTypeSection(
                    eventType: eventType,
                    onEventTypeChanged: _handleEventTypeChanged,
                  ),
                  const SizedBox(height: 16),
                  if (eventType == 'group') ...[
                    _buildGroupSelectionSection(),
                    const SizedBox(height: 16),
                  ],
                  EventBasicInfoSection(
                    title: title,
                    description: description,
                    category: category,
                    categories: categories,
                    onTitleChanged: (value) => title = value,
                    onDescriptionChanged: (value) => description = value,
                    onCategoryChanged: (value) => setState(() => category = value),
                  ),
                  const SizedBox(height: 16),
                  EventDateTimeSection(
                    isRecurring: isRecurring,
                    onRecurringChanged: (value) => setState(() => isRecurring = value),
                  ),
                  const SizedBox(height: 16),
                  EventLocationSection(
                    locationType: locationType,
                    onLocationTypeChanged: _handleLocationTypeChanged,
                    onLocationChanged: (value) => location = value,
                    onDetailedAddressChanged: (value) => detailedAddress = value,
                    onOnlineLinkChanged: (value) => onlineLink = value,
                  ),
                  const SizedBox(height: 16),
                  _buildCapacitySection(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('👥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                '그룹 선택',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '그룹을 선택하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppTheme.mutedForeground),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('👥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                '참가 인원',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: '최대 참가자 수',
            hint: '12',
            required: true,
            onChanged: (value) => maxAttendees = value,
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Text('👫', style: TextStyle(fontSize: 12)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '적정 인원을 설정하면 더 친밀한 모임이 가능해요',
                  style: TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool required = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
            filled: true,
            fillColor: AppTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Handle create event
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('이벤트 만들기 기능 준비 중입니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '이벤트 만들기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Text('✨', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.foreground),
            ),
          ),
        ),
      ],
    );
  }
}
