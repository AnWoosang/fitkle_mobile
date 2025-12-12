import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/app_icon_button.dart';
import 'package:fitkle/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:fitkle/features/chat/presentation/providers/chat_provider.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _roomId;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.id;

    if (currentUserId == null) return;

    final roomId = await ref
        .read(chatRoomsProvider.notifier)
        .getOrCreateDirectChatRoom(widget.userId);

    if (mounted) {
      setState(() {
        _roomId = roomId;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('a h:mm', 'ko_KR').format(timestamp);
    } else {
      return DateFormat('M/d a h:mm', 'ko_KR').format(timestamp);
    }
  }

  Future<void> _handleSend() async {
    if (_messageController.text.trim().isEmpty || _roomId == null) return;

    final authState = ref.read(authProvider);
    final currentUserName = authState.user?.name ?? 'User';
    final message = _messageController.text.trim();

    _messageController.clear();

    await ref
        .read(chatMessagesProvider(_roomId!).notifier)
        .sendMessage(message, currentUserName);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showLeaveDialog() async {
    if (_roomId == null) return;

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '채팅방을 나가시겠습니까?',
      message: '이 대화방을 나가면 대화 내용이 삭제되며, 메시지 목록에서 사라집니다.',
      confirmText: '나가기',
      cancelText: '취소',
      isDestructiveAction: true,
    );

    if (confirmed == true && mounted) {
      await ref.read(chatRoomsProvider.notifier).leaveChatRoom(_roomId!);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showReportDialog() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '사용자를 신고하시겠습니까?',
      message:
          '${widget.userName}님을 부적절한 행동으로 신고합니다. 신고 내용은 관리자가 검토하며, 필요시 조치가 취해집니다.',
      confirmText: '신고하기',
      cancelText: '취소',
      isDestructiveAction: true,
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('신고가 접수되었습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;

    if (_roomId == null || currentUserId == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final chatMessagesState = ref.watch(chatMessagesProvider(_roomId!));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 16,
              16,
              12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.background,
                  AppTheme.background,
                  AppTheme.background.withOpacity(0),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border.withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    shape: BoxShape.circle,
                  ),
                  child: AppIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),

                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0] : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        '온라인',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Button
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.mutedForeground,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'leave') {
                      _showLeaveDialog();
                    } else if (value == 'report') {
                      _showReportDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'leave',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              size: 16, color: AppTheme.destructive),
                          SizedBox(width: 12),
                          Text(
                            '채팅방 나가기',
                            style: TextStyle(color: AppTheme.destructive),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      enabled: false,
                      height: 8,
                      child: Divider(height: 8),
                    ),
                    const PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.flag,
                              size: 16, color: AppTheme.mutedForeground),
                          SizedBox(width: 12),
                          Text('신고하기'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: chatMessagesState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatMessagesState.error != null
                    ? Center(
                        child: Text(
                          chatMessagesState.error!,
                          style: const TextStyle(
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      )
                    : chatMessagesState.messages.isEmpty
                        ? const Center(
                            child: Text(
                              '메시지가 없습니다\n대화를 시작해보세요',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: chatMessagesState.messages.length,
                            itemBuilder: (context, index) {
                              final message = chatMessagesState.messages[index];
                              final isMe = message.senderId == currentUserId;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppTheme.primary
                                            : AppTheme.muted,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.message,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isMe
                                                  ? Colors.white
                                                  : AppTheme.foreground,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatTimestamp(message.createdAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isMe
                                                  ? Colors.white
                                                      .withOpacity(0.7)
                                                  : AppTheme.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border(
                top: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        hintStyle: TextStyle(color: AppTheme.mutedForeground),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _handleSend(),
                      enabled: !chatMessagesState.isSending,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: chatMessagesState.isSending
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : AppIconButton(
                          icon: Icons.send,
                          size: 20,
                          color: Colors.white,
                          onPressed: _handleSend,
                          padding: EdgeInsets.zero,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
