
import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';

import '../repositories/users_repository.dart';

class GetAllUsersUseCase {
  final UsersRepository repository;

  GetAllUsersUseCase({required this.repository});

  Future<Either<String, List<UserEntity>>> call(UsersFilterEntity filter) async {
    return await repository.getAllUsers(filter);
  }
}