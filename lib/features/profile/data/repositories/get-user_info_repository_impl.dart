import 'dart:io';

import 'package:test3/features/profile/data/datasource/get_user_info_remote_datasource.dart';
import 'package:test3/features/profile/data/model/chnage_password.dart';
import 'package:test3/features/profile/domain/entities/change_password.dart';
import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/domain/entities/update_user.dart';
import 'package:test3/features/profile/domain/repositories/get_user_info_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserInfo> getUserProfile(String userId) async {
    return await remoteDataSource.getUserProfile(userId);
  }

  Future<UserUpdate> updateUserProfile({
    required String userId,
    required String name,
    required String lastname,
    File? profilePhoto,
  }) {
    return remoteDataSource.updateUserProfile(
      userId: userId,
      name: name,
      lastname: lastname,
      profilePhoto: profilePhoto,
    );
  }


   @override
  Future<ChangePassword> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final ChangePasswordModel result = await remoteDataSource.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result;
  }
}
