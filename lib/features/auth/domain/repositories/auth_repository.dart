import 'package:dartz/dartz.dart';
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

abstract class AuthRepository {
  Future<User> register(RegisterRequest request);
  Future<LoginEntity> login(LoginRequest request);
  Future<ApprovedEntity> checkUserIsApproved(ApprovedRequest request);
  Future<LoginGoogleEntity> loginWithGoogle({
    required String idToken,
    required String deviceTokenId,
    required int platform,
  });
  Future<RegisterGoogleEntity> registerWithGoogle(
    RegisterGoogleRequest request,
  );

  Future<Either<String, EnumsResponse>> getAllEnums();
}
