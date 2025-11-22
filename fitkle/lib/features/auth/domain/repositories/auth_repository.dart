import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> signInWithEmail(String email, String password);

  Future<Either<Failure, AuthUserEntity>> signUpWithEmail(String email, String password, String name);

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, AuthUserEntity?>> getCurrentAuthUser();

  Future<Either<Failure, void>> resetPassword(String email);
}
