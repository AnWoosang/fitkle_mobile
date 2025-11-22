// ============================================================================
// CORE DEPENDENCY INJECTION
// ============================================================================
//
// This file contains ONLY shared infrastructure providers.
// Feature-specific providers are now located in their respective features:
//
// - Auth: lib/features/auth/presentation/providers/auth_provider.dart
// - Event: lib/features/event/presentation/providers/event_provider.dart
// - Group: lib/features/group/presentation/providers/group_provider.dart
// - Home/News: lib/features/home/presentation/providers/news_provider.dart
// - Member: lib/features/member/presentation/providers/member_provider.dart
// - Profile: lib/features/profile/presentation/providers/ (본인 프로필 관련)
//
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkle/core/config/supabase_client.dart';
import 'package:fitkle/core/network/network_info.dart';

// ============================================================================
// GLOBAL PROVIDER CONTAINER
// ============================================================================

/// Global ProviderContainer for accessing providers outside of widget tree
/// Use sparingly - prefer using ref.read() in widget context when possible
final globalProviderContainer = ProviderContainer();

// ============================================================================
// SHARED INFRASTRUCTURE PROVIDERS
// ============================================================================

/// Supabase Client Provider - Shared across all features
final supabaseClientProvider = Provider((ref) => supabaseClient);

/// Network Info Provider - Shared across all features
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());