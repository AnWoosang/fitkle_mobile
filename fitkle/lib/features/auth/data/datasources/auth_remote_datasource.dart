import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitkle/core/error/exceptions.dart' as app_exceptions;
import 'package:fitkle/features/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signInWithEmail(String email, String password);
  Future<AuthUserModel> signUpWithEmail(String email, String password, String name);
  Future<void> signOut();
  Future<AuthUserModel?> getCurrentAuthUser();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AuthUserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw app_exceptions.AuthException('Sign in failed');
      }

      return AuthUserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      throw app_exceptions.AuthException('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw app_exceptions.AuthException('Sign up failed');
      }

      // Create user profile in the user table
      await supabaseClient.from('user').insert({
        'id': response.user!.id,
        'email': email,
        'name': name,
      });

      return AuthUserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      throw app_exceptions.AuthException('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel?> getCurrentAuthUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }
      return AuthUserModel.fromSupabaseUser(user);
    } catch (e) {
      throw app_exceptions.AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw app_exceptions.AuthException('Password reset failed: ${e.toString()}');
    }
  }
}
