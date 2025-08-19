

import 'package:test3/features/auth/data/model/register_request.dart';
import 'package:test3/features/auth/domain/entities/user.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call(RegisterRequest request) async {
    return await repository.register(request);
  }
  
}
