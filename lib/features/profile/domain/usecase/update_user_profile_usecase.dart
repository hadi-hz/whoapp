import 'dart:io';
import 'package:test3/features/profile/domain/entities/update_user.dart';
import 'package:test3/features/profile/domain/repositories/get_user_info_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<UserUpdate> call({
    required String userId,
    required String name,
    required String lastname,
    File? profilePhoto,
  }) {
    return repository.updateUserProfile(
      userId: userId,
      name: name,
      lastname: lastname,
      profilePhoto: profilePhoto,
    );
  }
}
