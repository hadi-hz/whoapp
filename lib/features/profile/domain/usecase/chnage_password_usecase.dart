import 'package:test3/features/profile/domain/repositories/get_user_info_repository.dart';

import '../entities/change_password.dart';

class ChangePasswordUseCase {
  final UserRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<ChangePassword> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
