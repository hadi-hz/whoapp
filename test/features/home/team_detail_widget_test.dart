import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/team_detail_entity.dart';
import 'package:test3/features/home/domain/usecase/get_team_by_id.dart';
import 'package:test3/features/home/presentation/controller/teams_by_id_controller.dart';
import 'package:test3/features/home/domain/entities/team_by_id_response_entity.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';

class MockController extends GetxController implements GetTeamByIdController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var teamDetail = Rxn<TeamByIdResponseEntity>();

  @override
  Future<void> fetchTeamById(String teamId) async {
    teamDetail.value = TeamByIdResponseEntity(
      team: TeamDetailEntity(
        id: '1',
        name: 'Team A',
        description: 'Description A',
        isHealthcareCleaningAndDisinfection: true,
        isHouseholdCleaningAndDisinfection: false,
        isPatientsReferral: true,
        isSafeAndDignifiedBurial: false,
        isDelete: false,
        createTime: '2025-01-01',
      ),
      members: [

      ],
    );
  }

  @override
  void clearData() {
    teamDetail.value = null;
  }

  @override

  GetTeamByIdUseCase get getTeamByIdUseCase => throw UnimplementedError();
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(MockController());
  });

  testWidgets('TeamDetailsPage shows team info, services, and members', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TeamDetailsPage(teamId: '1')));

    // initial loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // team info
    expect(find.text('Team A'), findsOneWidget);
    expect(find.text('Description A'), findsOneWidget);

    // services
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    expect(find.byIcon(Icons.cancel), findsNWidgets(2));

    // members
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.byIcon(Icons.local_police_rounded), findsOneWidget);
  });
}
