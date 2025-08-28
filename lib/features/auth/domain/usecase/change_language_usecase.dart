import 'package:test3/features/auth/domain/entities/change_language.dart';
import 'package:test3/features/auth/domain/repositories/change_language_repository.dart';

class ChangeLanguageUseCase {
  final ChangeLanguageRepository repository;

  ChangeLanguageUseCase(this.repository);

  Future<ChangeLanguageResponse> call(ChangeLanguageRequest request) async {
    return await repository.changeLanguage(request);
  }
}