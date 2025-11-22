import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitkle/features/auth/domain/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  Future<Either<Failure, AuthUserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    return await _repository.signInWithEmail(email, password);
  }

  Future<Either<Failure, AuthUserEntity>> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    return await _repository.signUpWithEmail(email, password, name);
  }

  Future<Either<Failure, void>> signOut() async {
    return await _repository.signOut();
  }

  Future<Either<Failure, AuthUserEntity?>> getCurrentAuthUser() async {
    return await _repository.getCurrentAuthUser();
  }

  Future<Either<Failure, void>> resetPassword(String email) async {
    return await _repository.resetPassword(email);
  }
}
