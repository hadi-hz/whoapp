import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/profile/data/model/chnage_password.dart';
import 'package:test3/features/profile/data/model/get_user_info_request.dart';
import 'package:test3/features/profile/data/model/update_user_profile.dart';


abstract class UserRemoteDataSource {
  Future<UserInfoModel> getUserProfile(String userId);
   Future<UserUpdateModel> updateUserProfile({
    required String userId,
    required String name,
    required String lastname,
    File? profilePhoto,
  });


   Future<ChangePasswordModel> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
 final Dio _dio = DioBase().dio;
  

  @override
  Future<UserInfoModel> getUserProfile(String userId) async {
    final response = await _dio.post(
      ApiEndpoints.getUserInfo, 
      data: {"userId": userId},
    );

    return UserInfoModel.fromJson(response.data);
  }











   Future<UserUpdateModel> updateUserProfile({
    required String userId,
    required String name,
    required String lastname,
    File? profilePhoto,
  }) async {
    final formData = FormData.fromMap({
      "userId": userId,
      "name": name,
      "lastname": lastname,
      if (profilePhoto != null)
        "profilePhoto": await MultipartFile.fromFile(profilePhoto.path),
    });

    final response = await _dio.post(ApiEndpoints.updateProfile, data: formData);
    return UserUpdateModel.fromJson(response.data);
  }





   @override
  Future<ChangePasswordModel> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.changepassword,
      data: {
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChangePasswordModel.fromJson(response.data);
    } else {
      throw Exception('Failed to change password');
    }
  }
}
