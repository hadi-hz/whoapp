import 'package:dartz/dartz.dart';
import '../entities/user_detail_entity.dart';
import '../repositories/user_detail_repository.dart';

class GetUserDetailUseCase {
  final UserDetailRepository repository;

  GetUserDetailUseCase({required this.repository});

  Future<Either<String, UserDetailEntity>> call({
    required String userId,
    required String currentUserId,
  }) async {
    return await repository.getUserInfo(
      userId: userId,
      currentUserId: currentUserId,
    );
  }
}