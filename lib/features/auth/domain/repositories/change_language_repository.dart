import 'package:test3/features/auth/domain/entities/change_language.dart';

abstract class ChangeLanguageRepository {
  Future<ChangeLanguageResponse> changeLanguage(ChangeLanguageRequest request);
}