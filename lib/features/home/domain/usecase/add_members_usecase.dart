import 'package:test3/features/home/domain/entities/add_members.dart';
import 'package:test3/features/home/domain/repositories/create_team_repository.dart';

class AddMembersUseCase {
  final CreateTeamRepository repository;

  AddMembersUseCase(this.repository);

  Future<void> call(AddMembersRequest request) async {
    return await repository.addMembers(request);
  }
}