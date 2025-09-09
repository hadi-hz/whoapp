
import 'package:test3/features/auth/domain/entities/change_password_entity.dart';

abstract class ChangePasswordRepository {
  Future<ApiResponse> forgetPassword(String email);
}