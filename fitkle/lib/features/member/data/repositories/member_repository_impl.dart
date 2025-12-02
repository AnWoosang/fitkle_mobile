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
  Future<Either<Failure, MemberEntity>> getMemberById(String memberId) async {
    if (await networkInfo.isConnected) {
      try {
        final memberModel = await remoteDataSource.getMemberById(memberId);
        return Right(memberModel.toEntity());
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
  Future<Either<Failure, MemberEntity>> getMemberByEmail(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final memberModel = await remoteDataSource.getMemberByEmail(email);
        return Right(memberModel.toEntity());
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
  Future<Either<Failure, MemberEntity>> createMember(MemberEntity member) async {
    if (await networkInfo.isConnected) {
      try {
        final memberModel = MemberModel.fromEntity(member);
        final createdMember = await remoteDataSource.createMember(memberModel);
        return Right(createdMember.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> updateMember(MemberEntity member) async {
    if (await networkInfo.isConnected) {
      try {
        final memberModel = MemberModel.fromEntity(member);
        final updatedMember = await remoteDataSource.updateMember(memberModel);
        return Right(updatedMember.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAvatar(String memberId, String avatarUrl) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateAvatar(memberId, avatarUrl);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteMember(String memberId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.softDeleteMember(memberId);
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
        final memberModels = await remoteDataSource.searchMembers(query);
        return Right(memberModels.map((model) => model.toEntity()).toList());
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

  @override
  Future<Either<Failure, List<MemberEntity>>> getAllMembers({int limit = 50, int offset = 0}) async {
    if (await networkInfo.isConnected) {
      try {
        final memberModels = await remoteDataSource.getAllMembers(limit: limit, offset: offset);
        return Right(memberModels.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> patchMemberField(String memberId, Map<String, dynamic> updates) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedMember = await remoteDataSource.patchMemberField(memberId, updates);
        return Right(updatedMember.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
