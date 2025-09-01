import 'package:test3/features/auth/data/model/register_google_request_model.dart';
import 'package:test3/features/auth/domain/entities/register_google.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class RegisterGoogleUseCase {
  final AuthRepository repository;

  RegisterGoogleUseCase(this.repository);

  Future<RegisterGoogleEntity> call({
    required String idToken,
    required String deviceTokenId,
    required int platform,
  }) async {
    final request = RegisterGoogleRequest(
      idToken: idToken,
      deviceTokenId: deviceTokenId,
      platform: platform,
    );
    return await repository.registerWithGoogle(request);
  }
}