import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:fitkle/core/error/exceptions.dart' as app_exceptions;
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitkle/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitkle/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SupabaseClient supabaseClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.supabaseClient,
  });

  @override
  bool get isLoggedIn => supabaseClient.auth.currentUser != null;

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    debugPrint('========== AUTH REPOSITORY ==========');
    debugPrint('[AuthRepository] signInWithEmail 호출');
    debugPrint('[AuthRepository] email: $email');
    debugPrint('[AuthRepository] password: ${'*' * password.length} (${password.length}자)');

    final isConnected = await networkInfo.isConnected;
    debugPrint('[AuthRepository] 네트워크 연결 상태: $isConnected');

    if (isConnected) {
      try {
        debugPrint('[AuthRepository] DataSource 호출 시작...');
        final userModel = await remoteDataSource.signInWithEmail(email, password);
        debugPrint('[AuthRepository] DataSource 성공!');
        debugPrint('[AuthRepository] user: ${userModel.email}');
        return Right(userModel.toEntity());
      } on app_exceptions.AuthException catch (e) {
        debugPrint('[AuthRepository] AuthException: ${e.message}');
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        debugPrint('[AuthRepository] ServerException: ${e.message}');
        return Left(ServerFailure(e.message));
      } catch (e) {
        debugPrint('[AuthRepository] Unknown Exception: $e');
        debugPrint('[AuthRepository] Exception Type: ${e.runtimeType}');
        return Left(AuthFailure(e.toString()));
      }
    } else {
      debugPrint('[AuthRepository] 네트워크 연결 없음');
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
    String? location,
    String? nationality,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signUpWithEmail(
          email: email,
          password: password,
          nickname: nickname,
          location: location,
          nationality: nationality,
        );
        return Right(userModel.toEntity());
      } on app_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(null);
      } on app_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentAuthUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentAuthUser();
      return Right(userModel?.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on app_exceptions.ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email);
        return const Right(null);
      } on app_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updatePassword(newPassword);
        return const Right(null);
      } on app_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateEmail(newEmail);
        return const Right(null);
      } on app_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on app_exceptions.ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('인터넷 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> refreshSession() async {
    try {
      final userModel = await remoteDataSource.refreshSession();
      return Right(userModel?.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on app_exceptions.ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
