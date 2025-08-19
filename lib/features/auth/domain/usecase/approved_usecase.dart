

import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/domain/entities/approved.dart';
import 'package:test3/features/auth/domain/repositories/auth_repository.dart';

class ApprovedUseCase {
  final AuthRepository repository;

  ApprovedUseCase(this.repository);

  Future<ApprovedEntity> call(ApprovedRequest request) async {
    return await repository.checkUserIsApproved(request);
  }
  
}
