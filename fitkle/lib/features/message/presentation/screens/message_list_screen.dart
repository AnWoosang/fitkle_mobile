import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data
  final List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'userName': 'Sarah Kim',
      'userInitials': 'SK',
      'lastMessage': '내일 브런치 모임 참석하시나요?',
      'timestamp': '오후 3:30',
      'unread': 2,
      'online': true,
    },
    {
      'id': '2',
      'userName': 'Mike Johnson',
      'userInitials': 'MJ',
      'lastMessage': '사진 공유해주셔서 감사합니다!',
      'timestamp': '오후 2:15',
      'unread': 0,
      'online': false,
    },
    {
      'id': '3',
      'userName': 'Yuki Tanaka',
      'userInitials': 'YT',
      'lastMessage': '다음 주 일정 어떠세요?',
      'timestamp': '오전 11:20',
      'unread': 1,
      'online': true,
    },
    {
      'id': '4',
      'userName': 'Emma Wilson',
      'userInitials': 'EW',
      'lastMessage': '좋은 정보 감사해요',
      'timestamp': '어제',
      'unread': 0,
      'online': false,
    },
    {
      'id': '5',
      'userName': 'Li Wei',
      'userInitials': 'LW',
      'lastMessage': '한국어 공부 도와주실 수 있나요?',
      'timestamp': '어제',
      'unread': 3,
      'online': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border.withOpacity(0.3),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border.withOpacity(0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '메시지 검색',
                  hintStyle: const TextStyle(
                    color: AppTheme.mutedForeground,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.mutedForeground,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.muted,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.message,
                            size: 40,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '메시지가 없습니다',
                          style: TextStyle(
                            color: AppTheme.mutedForeground,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '대화를 시작해보세요',
                          style: TextStyle(
                            color: AppTheme.mutedForeground,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.border.withOpacity(0.5),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            context.push(
                              '/chat/${message['id']}?userName=${Uri.encodeComponent(message['userName'])}',
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Avatar with online indicator
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: AppTheme.primary,
                                      child: Text(
                                        message['userInitials'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    if (message['online'])
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppTheme.background,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // Message content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              message['userName'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            message['timestamp'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              message['lastMessage'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: message['unread'] > 0
                                                    ? AppTheme.foreground
                                                    : AppTheme.mutedForeground,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (message['unread'] > 0) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                color: AppTheme.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${message['unread']}',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Chevron
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: AppTheme.mutedForeground,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
