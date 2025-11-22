import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/sticky_header_bar.dart';
import 'package:fitkle/features/group/presentation/widgets/group_basic_info_section.dart';
import 'package:fitkle/features/group/presentation/widgets/group_location_section.dart';
import 'package:fitkle/features/group/presentation/widgets/group_category_section.dart';
import 'package:fitkle/features/group/presentation/widgets/group_privacy_section.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String location = '';
  String category = 'Social Activities';
  String privacy = 'public'; // 'public' or 'private'

  bool isLocationDialogOpen = false;
  String locationSearchQuery = '';

  final List<Map<String, String>> categories = [
    {'name': 'Social Activities', 'emoji': '🎉'},
    {'name': 'Food & Dining', 'emoji': '🍜'},
    {'name': 'Sports & Fitness', 'emoji': '⚽'},
    {'name': 'Arts & Culture', 'emoji': '🎭'},
    {'name': 'Language Exchange', 'emoji': '💬'},
    {'name': 'Professional Networking', 'emoji': '💼'},
    {'name': 'Outdoor Adventures', 'emoji': '🏔️'},
    {'name': 'Tech & Innovation', 'emoji': '💻'},
  ];

  final List<Map<String, String>> allLocations = [
    {'display': '서울시 강남구', 'city': '서울', 'district': '강남구'},
    {'display': '서울시 서초구', 'city': '서울', 'district': '서초구'},
    {'display': '서울시 송파구', 'city': '서울', 'district': '송파구'},
    {'display': '서울시 강동구', 'city': '서울', 'district': '강동구'},
    {'display': '서울시 마포구', 'city': '서울', 'district': '마포구'},
    {'display': '서울시 용산구', 'city': '서울', 'district': '용산구'},
    {'display': '서울시 성동구', 'city': '서울', 'district': '성동구'},
    {'display': '서울시 광진구', 'city': '서울', 'district': '광진구'},
    {'display': '부산시 해운대구', 'city': '부산', 'district': '해운대구'},
    {'display': '부산시 남구', 'city': '부산', 'district': '남구'},
    {'display': '부산시 동래구', 'city': '부산', 'district': '동래구'},
    {'display': '인천시 남동구', 'city': '인천', 'district': '남동구'},
    {'display': '인천시 연수구', 'city': '인천', 'district': '연수구'},
    {'display': '대구시 수성구', 'city': '대구', 'district': '수성구'},
    {'display': '대구시 중구', 'city': '대구', 'district': '중구'},
    {'display': '대전시 유성구', 'city': '대전', 'district': '유성구'},
    {'display': '광주시 북구', 'city': '광주', 'district': '북구'},
    {'display': '울산시 남구', 'city': '울산', 'district': '남구'},
  ];

  List<Map<String, String>> get filteredLocations {
    if (locationSearchQuery.isEmpty) {
      return allLocations;
    }
    return allLocations.where((loc) {
      return loc['display']!.contains(locationSearchQuery) ||
          loc['city']!.contains(locationSearchQuery) ||
          loc['district']!.contains(locationSearchQuery);
    }).toList();
  }

  void _handleLocationSelect(String locationDisplay) {
    setState(() {
      location = locationDisplay;
      isLocationDialogOpen = false;
      locationSearchQuery = '';
    });
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.card,
          title: Row(
            children: [
              const Text('🔍', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                '위치 검색',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '시, 구 단위로 지역을 검색하세요',
                  style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: '예: 강남구, 서울, 부산',
                    prefixIcon: const Icon(Icons.search, size: 20),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setDialogState(() {
                      locationSearchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: filteredLocations.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredLocations.length,
                          itemBuilder: (context, index) {
                            final loc = filteredLocations[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () {
                                  _handleLocationSelect(loc['display']!);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('📍', style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Text(
                                        loc['display']!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🔍', style: TextStyle(fontSize: 32)),
                              SizedBox(height: 8),
                              Text(
                                '검색어를 입력하세요',
                                style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (location.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치를 선택해주세요')),
        );
        return;
      }

      // TODO: Implement group creation logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('그룹이 생성되었습니다!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          StickyHeaderBar(
            title: '그룹 만들기',
            onBackPressed: () => context.pop(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GroupBasicInfoSection(
                      name: name,
                      description: description,
                      onNameChanged: (value) => name = value,
                      onDescriptionChanged: (value) => description = value,
                    ),
                    const SizedBox(height: 16),
                    GroupLocationSection(
                      location: location,
                      onShowLocationDialog: _showLocationDialog,
                    ),
                    const SizedBox(height: 16),
                    GroupCategorySection(
                      category: category,
                      categories: categories,
                      onCategoryChanged: (value) => setState(() => category = value),
                    ),
                    const SizedBox(height: 16),
                    GroupPrivacySection(
                      privacy: privacy,
                      onPrivacyChanged: (value) => setState(() => privacy = value),
                    ),
                    const SizedBox(height: 16),
                    _buildGuidelinesSection(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary.withValues(alpha: 0.2),
                  AppTheme.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('📋', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      '커뮤니티 가이드라인',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 8),
                    Text('✨', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGuidelineItem('💚', '모든 멤버를 존중하고 포용하세요'),
                const SizedBox(height: 8),
                _buildGuidelineItem('🎯', '그룹 목적에 맞는 콘텐츠를 공유하세요'),
                const SizedBox(height: 8),
                _buildGuidelineItem('🚫', '스팸, 괴롭힘, 부적절한 콘텐츠는 금지됩니다'),
                const SizedBox(height: 8),
                _buildGuidelineItem('📅', '정기적인 모임과 활동을 조직하세요'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: AppTheme.mutedForeground),
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
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '그룹 만들기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Text('✨', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.border.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(fontSize: 16, color: AppTheme.foreground),
            ),
          ),
        ),
      ],
    );
  }
}
