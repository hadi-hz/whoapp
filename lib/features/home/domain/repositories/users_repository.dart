import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';

abstract class UsersRepository {
  Future<Either<String, List<UserEntity>>> getAllUsers(UsersFilterEntity filter);
}

