import 'package:dartz/dartz.dart';
import '../entities/assign_role_entity.dart';
import '../repositories/assign_role_repository.dart';

class AssignRoleUseCase {
  final AssignRoleRepository repository;

  AssignRoleUseCase({required this.repository});

  Future<Either<String, AssignRoleEntity>> call({
    required String userId,
    required String roleName,
  }) async {
    return await repository.assignRole(
      userId: userId,
      roleName: roleName,
    );
  }
}