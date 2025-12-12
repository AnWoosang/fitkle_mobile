import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/user_avatar.dart';
import 'package:fitkle/features/chat/presentation/providers/chat_provider.dart';
import 'package:intl/intl.dart';

class MessageListScreen extends ConsumerStatefulWidget {
  const MessageListScreen({super.key});

  @override
  ConsumerState<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends ConsumerState<MessageListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('a h:mm', 'ko_KR').format(timestamp);
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'ko_KR').format(timestamp);
    } else {
      return DateFormat('M/d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomsState = ref.watch(chatRoomsProvider);

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
              child: chatRoomsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : chatRoomsState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppTheme.mutedForeground,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                chatRoomsState.error!,
                                style: const TextStyle(
                                  color: AppTheme.mutedForeground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : chatRoomsState.rooms.isEmpty
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
                          : RefreshIndicator(
                              onRefresh: () async {
                                await ref.read(chatRoomsProvider.notifier).refresh();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  AppTheme.bottomSafeAreaPadding,
                                ),
                                itemCount: chatRoomsState.rooms.length,
                                itemBuilder: (context, index) {
                                  final roomWithDetails = chatRoomsState.rooms[index];
                                  final room = roomWithDetails.room;
                                  final lastMessage = roomWithDetails.lastMessage;
                                  final unreadCount = roomWithDetails.unreadCount;

                                  // For direct chats, use other member's name
                                  final displayName = room.type == 'direct'
                                      ? (roomWithDetails.otherMemberName ?? 'User')
                                      : (room.name ?? 'Chat Room');

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
                                          '/chat/${roomWithDetails.otherMemberId ?? room.id}?userName=${Uri.encodeComponent(displayName)}',
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            // Avatar
                                            UserAvatar(
                                              avatarUrl: null,
                                              size: 56,
                                            ),
                                            const SizedBox(width: 12),

                                            // Message content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          displayName,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      if (lastMessage != null)
                                                        Text(
                                                          _formatTimestamp(
                                                            lastMessage.createdAt,
                                                          ),
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
                                                          lastMessage?.message ??
                                                              '메시지가 없습니다',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: unreadCount > 0
                                                                ? AppTheme.foreground
                                                                : AppTheme
                                                                    .mutedForeground,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      if (unreadCount > 0) ...[
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: AppTheme.primary,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '$unreadCount',
                                                              style: const TextStyle(
                                                                fontSize: 10,
                                                                color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
