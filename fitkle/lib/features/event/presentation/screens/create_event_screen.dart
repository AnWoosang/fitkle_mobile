import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/core/theme/app_text_styles.dart';
import 'package:fitkle/shared/widgets/multi_step_form.dart';
import 'package:fitkle/features/event/presentation/widgets/event_type_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_datetime_section.dart';
import 'package:fitkle/features/event/presentation/widgets/event_location_section.dart';
import 'package:fitkle/features/event/presentation/providers/event_provider.dart';
import 'package:fitkle/shared/widgets/selection_field.dart';
import 'package:fitkle/shared/widgets/modal/single_tag_selection_modal.dart';
import 'package:fitkle/shared/widgets/modal/text_input_modal.dart';
import 'package:fitkle/shared/widgets/text_input_field.dart';
import 'package:fitkle/shared/widgets/dialogs/rich_text_editor_dialog.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  // Step 1: Event Type
  String eventType = 'personal';
  String? selectedGroupId;

  // Step 2: Category, Location, Date, Capacity
  String category = '';
  String locationType = 'offline';
  String location = '';
  String detailedAddress = '';
  String onlineLink = '';
  double? latitude;
  double? longitude;
  String date = '';
  String time = '';
  bool isRecurring = false;
  String maxAttendees = '';

  // Step 3: Title, Description, Image
  String title = '';
  String description = '';

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

  void _handleComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('이벤트 만들기 기능 준비 중입니다')),
    );
  }

  void _handleCancel() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: MultiStepForm(
        headerTitle: '이벤트 만들기',
        completeButtonText: '이벤트 만들기 ✨',
        onComplete: _handleComplete,
        onCancel: _handleCancel,
        steps: [
          // Step 1: Event Type & Category
          FormStepData(
            title: '타입 선택',
            subtitle: '이벤트 종류 및 카테고리',
            content: _buildStep1Content(),
            isValid: () => eventType.isNotEmpty && category.isNotEmpty,
          ),
          // Step 2: Details
          FormStepData(
            title: '세부 정보',
            subtitle: '장소, 날짜',
            content: _buildStep2Content(),
          ),
          // Step 3: Content
          FormStepData(
            title: '내용 작성',
            subtitle: '제목과 설명',
            content: _buildStep3Content(),
            isValid: () => title.isNotEmpty && description.isNotEmpty,
          ),
          // Step 4: Preview
          FormStepData(
            title: '미리보기',
            subtitle: '최종 확인',
            content: _buildStep4Content(),
          ),
        ],
      ),
    );
  }

  // Step 1 Content
  Widget _buildStep1Content() {
    final categoryState = ref.watch(eventCategoryProvider);
    final categories = categoryState.categories
        .map((cat) => {
              'name': cat.name,
              'emoji': cat.emoji ?? '📌',
              'code': cat.code,
            })
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventTypeSection(
          eventType: eventType,
          onEventTypeChanged: _handleEventTypeChanged,
        ),
        if (eventType == 'group') ...[
          const SizedBox(height: 16),
          _buildGroupSelectionSection(),
        ],
        const SizedBox(height: 16),
        _buildCategorySection(categories),
      ],
    );
  }

  // Step 2 Content
  Widget _buildStep2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventLocationSection(
          locationType: locationType,
          initialAddress: location.isNotEmpty ? location : null,
          onLocationTypeChanged: _handleLocationTypeChanged,
          onLocationChanged: (value) {
            print('🔄 [CreateEventScreen] onLocationChanged 콜백 받음: $value');
            setState(() {
              location = value;
            });
            print('✅ [CreateEventScreen] location 상태 업데이트 완료: $location');
          },
          onDetailedAddressChanged: (value) {
            print('🔄 [CreateEventScreen] onDetailedAddressChanged 콜백 받음: $value');
            setState(() {
              detailedAddress = value;
            });
          },
          onOnlineLinkChanged: (value) => setState(() => onlineLink = value),
          onCoordinatesChanged: (lat, lng) {
            print('🔄 [CreateEventScreen] onCoordinatesChanged 콜백 받음: lat=$lat, lng=$lng');
            setState(() {
              latitude = lat;
              longitude = lng;
            });
            print('✅ [CreateEventScreen] 좌표 상태 업데이트 완료: $latitude, $longitude');
          },
        ),
        const SizedBox(height: 16),
        EventDateTimeSection(
          isRecurring: isRecurring,
          onRecurringChanged: (value) => setState(() => isRecurring = value),
          onDateChanged: (selectedDate) {
            setState(() {
              date = selectedDate.toString().split(' ')[0];
            });
          },
          onTimeChanged: (selectedTime) {
            setState(() {
              time = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
            });
          },
        ),
        const SizedBox(height: 16),
        _buildCapacitySection(),
      ],
    );
  }

  // Step 3 Content
  Widget _buildStep3Content() {
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
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('기본 정보', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: '이벤트 제목',
            hint: '예: 강남 브런치 모임 ☕',
            required: true,
            onChanged: (value) => setState(() => title = value),
          ),
          const SizedBox(height: 12),
          _buildDescriptionField(),
          const SizedBox(height: 12),
          _buildImageUpload(),
        ],
      ),
    );
  }

  // Step 4 Content
  Widget _buildStep4Content() {
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
          const Text('이벤트 미리보기', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildPreviewItem('타입', eventType == 'personal' ? '개인 이벤트' : '그룹 이벤트'),
          _buildPreviewItem('카테고리', category.isNotEmpty ? category : '미설정'),
          _buildPreviewItem(
              '장소', locationType == 'offline' ? location : onlineLink),
          _buildPreviewItem('날짜', date.isNotEmpty ? date : '미설정'),
          _buildPreviewItem('시간', time.isNotEmpty ? time : '미설정'),
          _buildPreviewItem(
              '최대 인원', maxAttendees.isNotEmpty ? '$maxAttendees명' : '미설정'),
          _buildPreviewItem('제목', title.isNotEmpty ? title : '미설정'),
          _buildPreviewItem('설명', description.isNotEmpty ? description : '미설정'),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(List<Map<String, String>> categories) {
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
              const Text('🏷️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text('카테고리', style: AppTextStyles.h3),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              return SelectionField(
                selectedItemIds: category.isNotEmpty ? [category] : [],
                getItemName: (id) {
                  final cat = categories.firstWhere(
                    (c) => c['name'] == id,
                    orElse: () => {'name': id},
                  );
                  return cat['name'] ?? id;
                },
                getItemEmoji: (id) {
                  final cat = categories.firstWhere(
                    (c) => c['name'] == id,
                    orElse: () => {'emoji': '📌'},
                  );
                  return cat['emoji'] ?? '📌';
                },
                onTap: () => _showCategoryModal(context, categories),
                emptyMessage: 'Select event category',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCategoryModal(
      BuildContext context, List<Map<String, String>> categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SingleTagSelectionModal(
        title: 'Select event category',
        selectedCategoryId: category.isNotEmpty ? category : null,
        categories: categories
            .map((cat) => {
                  'id': cat['name']!,
                  'name': cat['name']!,
                  'emoji': cat['emoji']!,
                })
            .toList(),
        onSelect: (categoryId) {
          setState(() => category = categoryId);
        },
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
              const Text('그룹 선택', style: AppTextStyles.h3),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
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
                Text('그룹을 선택하세요',
                    style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground)),
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
              const Text('참가 인원', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '최대 참가자 수',
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _showMaxAttendeesModal(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        maxAttendees.isEmpty ? '예: 12' : '$maxAttendees명',
                        style: TextStyle(
                          fontSize: 14,
                          color: maxAttendees.isEmpty
                              ? AppTheme.mutedForeground
                              : AppTheme.foreground,
                        ),
                      ),
                      const Icon(Icons.edit, size: 16, color: AppTheme.mutedForeground),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
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

  void _showMaxAttendeesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TextInputModal(
        title: '최대 참가자 수',
        currentValue: maxAttendees,
        hintText: '예: 12',
        helpText: '적정 인원을 설정하면 더 친밀한 모임이 가능해요',
        validator: (value) {
          if (value.isEmpty) {
            return '참가자 수를 입력해주세요';
          }
          final number = int.tryParse(value);
          if (number == null) {
            return '숫자만 입력 가능합니다';
          }
          if (number <= 0) {
            return '1명 이상 입력해주세요';
          }
          if (number > 1000) {
            return '1000명 이하로 입력해주세요';
          }
          return null;
        },
        onSave: (value) async {
          setState(() => maxAttendees = value);
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool required = false,
    Function(String)? onChanged,
  }) {
    return TextInputField(
      label: '$label${required ? ' *' : ''}',
      hintText: hint,
      onChanged: onChanged,
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '설명',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await showRichTextEditorDialog(
              context: context,
              title: '이벤트 설명',
              initialText: description,
            );
            if (result != null) {
              setState(() => description = result);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              description.isEmpty
                  ? '어떤 이벤트인지 알려주세요...'
                  : description,
              style: TextStyle(
                fontSize: 14,
                color: description.isEmpty
                    ? AppTheme.mutedForeground
                    : AppTheme.foreground,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '이벤트 이미지',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            const Text('📸', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.border.withValues(alpha: 0.6),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primary,
                child: Text('🖼️', style: TextStyle(fontSize: 24)),
              ),
              SizedBox(height: 8),
              Text('이미지 업로드', style: TextStyle(fontSize: 12)),
              SizedBox(height: 4),
              Text(
                '권장: 1200x630px',
                style: TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
