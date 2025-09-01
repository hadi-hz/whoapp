import 'package:dartz/dartz.dart';
import 'package:test3/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/data/model/register_google_request_model.dart';
import 'package:test3/features/auth/data/model/register_request.dart';
import 'package:test3/features/auth/domain/entities/approved.dart';
import 'package:test3/features/auth/domain/entities/auth_by_google.dart';
import 'package:test3/features/auth/domain/entities/enum.dart';
import 'package:test3/features/auth/domain/entities/login.dart';
import 'package:test3/features/auth/domain/entities/login_google.dart';
import 'package:test3/features/auth/domain/entities/register_google.dart';
import 'package:test3/features/auth/domain/entities/user.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> register(RegisterRequest request) async {
    final response = await remoteDataSource.register(request);

    final data = response.data;

    return User(
      id: data["id"].toString(),
      message: data["message"],
      email: data["email"],
    );
  }

  @override
  Future<LoginEntity> login(LoginRequest request) async {
    final response = await remoteDataSource.login(request);

    final data = response.data;

    return LoginEntity(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      lastname: data['lastname'] ?? '',
      isUserApproved: data['isUserApproved'] ?? false,
      roles: List<String>.from(data['roles'] ?? []),
      message: data['message'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      preferredLanguage: data['preferredLanguage'] ?? 0,
      unReadMessagesCount: data['unReadMessagesCount'] ?? 0,
    );
  }

  @override
  Future<ApprovedEntity> checkUserIsApproved(ApprovedRequest request) async {
    final response = await remoteDataSource.checkUserIsApproved(request);

    final data = response.data;

    return ApprovedEntity(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      lastname: data['lastname'] ?? '',
      isUserApproved: data['isUserApproved'] ?? false,
      roles: List<String>.from(data['roles'] ?? []),
      message: data['message'] ?? '',
    );
  }

  @override
  Future<LoginGoogleEntity> loginWithGoogle({
    required String idToken,
    required String deviceTokenId,
    required int platform,
  }) async {
    final body = {
      "idToken": idToken,
      "deviceTokenId": deviceTokenId,
      "platform": platform,
    };

    final result = await remoteDataSource.loginWithGoogle(body);
    return result;
  }

  @override
  Future<Either<String, EnumsResponse>> getAllEnums() async {
    try {
      final result = await remoteDataSource.getAllEnums();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<RegisterGoogleEntity> registerWithGoogle(RegisterGoogleRequest request) async {
  return await remoteDataSource.registerWithGoogle(request);
}
}
