import 'package:test3/features/auth/domain/entities/change_password_entity.dart';
import 'package:test3/features/auth/domain/repositories/change_password_repository.dart';


class ForgetPasswordUseCase {
  final ChangePasswordRepository _repository;

  ForgetPasswordUseCase(this._repository);

  Future<ApiResponse> execute(String email) {
    if (email.isEmpty || !_isValidEmail(email)) {
      return Future.value(ApiResponse(success: false, message: 'Invalid email'));
    }
    return _repository.forgetPassword(email);
  }

  bool _isValidEmail(String email) => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
}
