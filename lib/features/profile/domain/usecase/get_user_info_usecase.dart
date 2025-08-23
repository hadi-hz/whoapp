

import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/domain/repositories/get_user_info_repository.dart';

class GetUserProfile {
  final UserRepository repository;
  GetUserProfile(this.repository);

  Future<UserInfo> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}
