import 'package:test3/features/auth/data/datasource/change_language_datasource.dart';
import 'package:test3/features/auth/data/model/change_language_model.dart';
import 'package:test3/features/auth/domain/entities/change_language.dart';
import 'package:test3/features/auth/domain/repositories/change_language_repository.dart';

class ChangeLanguageRepositoryImpl implements ChangeLanguageRepository {
  final ChangeLanguageRemoteDataSource remoteDataSource;

  ChangeLanguageRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChangeLanguageResponse> changeLanguage(ChangeLanguageRequest request) async {
    final model = ChangeLanguageModel.fromRequest(request);
    final responseModel = await remoteDataSource.changeLanguage(model);
    return responseModel.toEntity();
  }
}