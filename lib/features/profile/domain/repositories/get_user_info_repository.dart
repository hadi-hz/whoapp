import 'dart:io';

import 'package:test3/features/profile/domain/entities/change_password.dart';
import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/domain/entities/update_user.dart';

abstract class UserRepository {
  Future<UserInfo> getUserProfile(String userId);

  Future<UserUpdate> updateUserProfile({
    required String userId,
    required String name,
    required String lastname,
    File? profilePhoto,
  });


   Future<ChangePassword> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });
}
