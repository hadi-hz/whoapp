import 'package:test3/features/auth/data/datasource/change_password_datasource.dart';
import 'package:test3/features/auth/domain/entities/change_password_entity.dart';
import 'package:test3/features/auth/domain/repositories/change_password_repository.dart';


class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordRemoteDataSource _dataSource;

  ChangePasswordRepositoryImpl(this._dataSource);

  @override
  Future<ApiResponse> forgetPassword(String email) => _dataSource.forgetPassword(email);
}
