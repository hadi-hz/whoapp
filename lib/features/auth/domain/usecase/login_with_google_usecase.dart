
import 'package:test3/features/auth/domain/entities/auth_by_google.dart';
import 'package:test3/features/auth/domain/entities/login_google.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<LoginGoogleEntity> call({
    required String idToken,
    required String deviceTokenId,
    required int platform,
  }) {
    return repository.loginWithGoogle(
      idToken: idToken,
      deviceTokenId: deviceTokenId,
      platform: platform,
    );
  }
}
