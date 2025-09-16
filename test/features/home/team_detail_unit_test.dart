import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test3/features/home/domain/entities/team_detail_entity.dart';
import 'package:test3/features/home/presentation/controller/teams_by_id_controller.dart';
import 'package:test3/features/home/domain/usecase/get_team_by_id.dart';
import 'package:test3/features/home/domain/entities/team_by_id_response_entity.dart';

class MockGetTeamByIdUseCase extends Mock implements GetTeamByIdUseCase {}

void main() {
  late GetTeamByIdController controller;
  late MockGetTeamByIdUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTeamByIdUseCase();
    controller = GetTeamByIdController(getTeamByIdUseCase: mockUseCase);
  });

  final teamEntity = TeamByIdResponseEntity(
    team: TeamDetailEntity(
      id: '1',
      name: 'Team A',
      description: 'Test Team',
      isHealthcareCleaningAndDisinfection: true,
      isHouseholdCleaningAndDisinfection: false,
      isPatientsReferral: true,
      isSafeAndDignifiedBurial: false,
      isDelete: false,
      createTime: '2025-01-01',
    ),
    members: [],
  );

  test('fetchTeamById sets teamDetail on success', () async {
    when(mockUseCase.call('1')).thenAnswer((_) async => Right(teamEntity));

    await controller.fetchTeamById('1');

    expect(controller.isLoading.value, false);
    expect(controller.errorMessage.value, '');
    expect(controller.teamDetail.value, teamEntity);
  });

  test('fetchTeamById sets errorMessage on failure', () async {
    when(mockUseCase.call('1')).thenAnswer((_) async => Left('Error'));

    await controller.fetchTeamById('1');

    expect(controller.isLoading.value, false);
    expect(controller.errorMessage.value, 'Error');
    expect(controller.teamDetail.value, null);
  });

  test('clearData resets controller state', () {
    controller.clearData();

    expect(controller.isLoading.value, false);
    expect(controller.errorMessage.value, '');
    expect(controller.teamDetail.value, null);
  });
}
