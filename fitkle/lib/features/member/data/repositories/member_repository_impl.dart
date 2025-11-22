import 'package:dartz/dartz.dart';
import 'package:fitkle/core/error/exceptions.dart';
import 'package:fitkle/core/error/failures.dart';
import 'package:fitkle/core/network/network_info.dart';
import 'package:fitkle/features/member/domain/entities/member_entity.dart';
import 'package:fitkle/features/member/domain/repositories/member_repository.dart';
import 'package:fitkle/features/member/data/datasources/member_remote_datasource.dart';
import 'package:fitkle/features/member/data/models/member_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MemberRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getMemberById(userId);
        return Right(user);
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> updateMember(MemberEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = MemberModel.fromEntity(user);
        final updatedUser = await remoteDataSource.updateMember(userModel);
        return Right(updatedUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAvatar(String userId, String avatarUrl) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateAvatar(userId, avatarUrl);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<MemberEntity>>> searchMembers(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.searchMembers(query);
        return Right(users);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkNicknameAvailability(String nickname) async {
    if (await networkInfo.isConnected) {
      try {
        final isAvailable = await remoteDataSource.checkNicknameAvailability(nickname);
        return Right(isAvailable);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailAvailability(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final isAvailable = await remoteDataSource.checkEmailAvailability(email);
        return Right(isAvailable);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
