import 'package:dartz/dartz.dart';
import '../entities/user_detail_entity.dart';

abstract class UserDetailRepository {
  Future<Either<String, UserDetailEntity>> getUserInfo({
    required String userId,
    required String currentUserId,
  });
}