import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitkle/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitkle/features/auth/domain/services/auth_service.dart';
import 'package:fitkle/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fitkle/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';

// ============================================================================
// DEPENDENCY INJECTION - Auth Feature
// ============================================================================

// Core Dependencies
final _authSupabaseClientProvider = Provider((ref) => supabaseClient);
final _authNetworkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(_authSupabaseClientProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    networkInfo: ref.watch(_authNetworkInfoProvider),
  );
});

// Services
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(authRepositoryProvider));
});

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

// Auth User State
class AuthUserState {
  final AuthUserEntity? user;
  final bool isLoading;
  final String? errorMessage;

  AuthUserState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthUserState copyWith({
    AuthUserEntity? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthUserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Current User Notifier
class CurrentUserNotifier extends StateNotifier<AuthUserState> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(AuthUserState());

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.getCurrentAuthUser();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AuthUserState>((ref) {
  return CurrentUserNotifier(ref.watch(authServiceProvider));
});
