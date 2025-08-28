import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/users_datasource.dart';
import 'package:test3/features/home/data/model/users_filter.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import '../../domain/repositories/users_repository.dart';


class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers(UsersFilterEntity filter) async {
    try {
      final filterModel = UsersFilterModel(
        name: filter.name,
        email: filter.email,
        role: filter.role,
        isApproved: filter.isApproved,
        sortBy: filter.sortBy,
        sortDesc: filter.sortDesc,
        registerDateFrom: filter.registerDateFrom,
        registerDateTo: filter.registerDateTo,
        page: filter.page,
        pageSize: filter.pageSize,
      );

      final result = await remoteDataSource.getAllUsers(filterModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}