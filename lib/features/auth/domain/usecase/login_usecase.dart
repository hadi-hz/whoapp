

import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginEntity> call(LoginRequest request) async {
    return await repository.login(request);
  }
  
}
