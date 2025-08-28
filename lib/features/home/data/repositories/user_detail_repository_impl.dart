import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/user_detail_datasource.dart';
import 'package:test3/features/home/data/model/user_detail_request_model.dart';
import '../../domain/entities/user_detail_entity.dart';
import '../../domain/repositories/user_detail_repository.dart';


class UserDetailRepositoryImpl implements UserDetailRepository {
  final UserDetailRemoteDataSource remoteDataSource;

  UserDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, UserDetailEntity>> getUserInfo({
    required String userId,
    required String currentUserId,
  }) async {
    try {
      final request = UserDetailRequest(
        userId: userId,
        currentUserId: currentUserId,
      );

      final result = await remoteDataSource.getUserInfo(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}