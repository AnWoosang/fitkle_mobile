import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitkle/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:fitkle/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:fitkle/features/chat/domain/repositories/chat_repository.dart';
import 'package:fitkle/features/chat/domain/entities/chat_message_entity.dart';
import 'package:fitkle/features/chat/data/models/chat_room_with_details_model.dart';

// ============================================================================
// DEPENDENCY INJECTION - Chat Feature
// ============================================================================

// Provider for ChatRemoteDataSource
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(supabaseClient);
});

// Provider for ChatRepository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource);
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

// State for chat rooms list
class ChatRoomsState {
  final List<ChatRoomWithDetailsModel> rooms;
  final bool isLoading;
  final String? error;

  const ChatRoomsState({
    this.rooms = const [],
    this.isLoading = false,
    this.error,
  });

  ChatRoomsState copyWith({
    List<ChatRoomWithDetailsModel>? rooms,
    bool? isLoading,
    String? error,
  }) {
    return ChatRoomsState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Chat Rooms Notifier
class ChatRoomsNotifier extends Notifier<ChatRoomsState> {
  @override
  ChatRoomsState build() {
    _loadChatRooms();
    return const ChatRoomsState();
  }

  ChatRepository get _repository => ref.watch(chatRepositoryProvider);

  String get _userId {
    final authState = ref.watch(authProvider);
    return authState.user?.id ?? '';
  }

  Future<void> _loadChatRooms() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getChatRooms(_userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (rooms) => state = state.copyWith(
        rooms: rooms,
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> refresh() async {
    await _loadChatRooms();
  }

  Future<String?> getOrCreateDirectChatRoom(String otherUserId) async {
    final result = await _repository.getOrCreateDirectChatRoom(
      _userId,
      otherUserId,
    );

    return result.fold(
      (failure) => null,
      (room) => room.id,
    );
  }

  Future<void> leaveChatRoom(String roomId) async {
    await _repository.leaveChatRoom(roomId, _userId);
    await refresh();
  }
}

// State for individual chat messages
class ChatMessagesState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  const ChatMessagesState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ChatMessagesState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }
}

// Chat Messages Notifier (Family)
class ChatMessagesNotifier extends Notifier<ChatMessagesState> {
  ChatMessagesNotifier(this.roomId);
  final String roomId;

  @override
  ChatMessagesState build() {
    _loadMessages();
    return const ChatMessagesState();
  }

  ChatRepository get _repository => ref.watch(chatRepositoryProvider);

  String get _roomId => roomId;

  String get _userId {
    final authState = ref.watch(authProvider);
    return authState.user?.id ?? '';
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getMessages(_roomId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (messages) {
        state = state.copyWith(
          messages: messages,
          isLoading: false,
          error: null,
        );
        // Mark as read
        _repository.updateLastRead(_roomId, _userId);
      },
    );
  }

  Future<void> sendMessage(String message, String senderName) async {
    if (message.trim().isEmpty) return;

    state = state.copyWith(isSending: true, error: null);

    final result = await _repository.sendMessage(
      roomId: _roomId,
      senderId: _userId,
      senderName: senderName,
      message: message,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isSending: false,
        error: failure.message,
      ),
      (sentMessage) {
        // Add the new message to the list
        final updatedMessages = [...state.messages, sentMessage];
        state = state.copyWith(
          messages: updatedMessages,
          isSending: false,
          error: null,
        );
      },
    );
  }

  Future<void> refresh() async {
    await _loadMessages();
  }

  void markAsRead() {
    _repository.updateLastRead(_roomId, _userId);
  }
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// Chat rooms list provider
final chatRoomsProvider = NotifierProvider<ChatRoomsNotifier, ChatRoomsState>(
  ChatRoomsNotifier.new,
);

/// Chat messages provider (by room ID)
final chatMessagesProvider = NotifierProvider.family<ChatMessagesNotifier, ChatMessagesState, String>(
  ChatMessagesNotifier.new,
);

/// Stream provider for real-time messages
final chatMessagesStreamProvider =
    StreamProvider.family<ChatMessageEntity, String>((ref, roomId) {
  final repository = ref.watch(chatRepositoryProvider);

  return repository.subscribeToMessages(roomId).map((either) {
    return either.fold(
      (failure) => throw Exception(failure.message),
      (message) => message,
    );
  });
});

/// Stream provider for real-time chat rooms
final chatRoomsStreamProvider = StreamProvider<List<ChatRoomWithDetailsModel>>(
  (ref) {
    final repository = ref.watch(chatRepositoryProvider);
    final authState = ref.watch(authProvider);
    final userId = authState.user?.id ?? '';

    return repository.subscribeToChatRooms(userId).map((either) {
      return either.fold(
        (failure) => throw Exception(failure.message),
        (rooms) => rooms,
      );
    });
  },
);
