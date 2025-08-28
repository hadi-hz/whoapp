import 'package:dartz/dartz.dart';
import '../entities/assign_role_entity.dart';

abstract class AssignRoleRepository {
  Future<Either<String, AssignRoleEntity>> assignRole({
    required String userId,
    required String roleName,
  });
}