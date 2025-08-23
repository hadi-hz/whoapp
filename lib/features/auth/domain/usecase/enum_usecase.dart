import 'package:dartz/dartz.dart';
import 'package:test3/features/auth/domain/entities/enum.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';


class GetAllEnums {
  final AuthRepository repository;

  GetAllEnums(this.repository);

  Future<Either<String, EnumsResponse>> call() async {
    return await repository.getAllEnums();
  }
}
