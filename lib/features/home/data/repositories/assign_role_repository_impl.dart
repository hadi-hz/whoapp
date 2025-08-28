import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/assign_role_datasource.dart';
import 'package:test3/features/home/data/model/assign_role_request_model.dart';
import '../../domain/entities/assign_role_entity.dart';
import '../../domain/repositories/assign_role_repository.dart';

class AssignRoleRepositoryImpl implements AssignRoleRepository {
  final AssignRoleRemoteDataSource remoteDataSource;

  AssignRoleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, AssignRoleEntity>> assignRole({
    required String userId,
    required String roleName,
  }) async {
    try {
      final request = AssignRoleRequest(
        userId: userId,
        roleName: roleName,
      );

      final result = await remoteDataSource.assignRole(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
