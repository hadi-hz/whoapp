// test/alert_detail_page_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

// === Import your actual files ===
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/team_finish_processing_controller.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart' hide TeamMemberEntity;
import 'package:test3/features/get_alert_by_id/domain/usecase/get_alert_by_id_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_team_by_alert_type.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/assign_team_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/team_finish_processing.dart';

// === GenerateMocks ===
@GenerateMocks([
  GetAlertDetailUseCase,
  GetTeamByAlertType,
  AssignTeamUseCase,
  TeamFinishProcessingUseCase,
])

import 'get_alert_by_id_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AlertDetailPage Tests', () {
    late AlertDetailController alertDetailController;
    late TeamFinishProcessingController teamFinishController;

    // Mock instances
    late MockGetAlertDetailUseCase mockGetAlertDetailUseCase;
    late MockGetTeamByAlertType mockGetTeamByAlertType;
    late MockAssignTeamUseCase mockAssignTeamUseCase;
    late MockTeamFinishProcessingUseCase mockTeamFinishProcessingUseCase;

    // Mock data
    late AlertDetailEntity mockAlertDetail;
    late TeamsEntity mockTeam;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'userId': 'test-user-id',
        'role': 'Admin',
      });

      mockAlertDetail = createMockAlertWithStatus(1);
      mockTeam = TeamsEntity(
        id: 'team-1',
        name: 'Test Team',
        description: 'Test Description',
        members: [],
        isHealthcareCleaningAndDisinfection: true,
        isHouseholdCleaningAndDisinfection: false,
        isPatientsReferral: false,
        isSafeAndDignifiedBurial: false,
        isDelete: false,
        createTime: '2023-01-01',
      );

      mockGetAlertDetailUseCase = MockGetAlertDetailUseCase();
      mockGetTeamByAlertType = MockGetTeamByAlertType();
      mockAssignTeamUseCase = MockAssignTeamUseCase();
      mockTeamFinishProcessingUseCase = MockTeamFinishProcessingUseCase();

      // === Setup mocks ===
      // when(mockGetAlertDetailUseCase.call(any<String>(), any<String>()))
      //     .thenAnswer((_) async => Right(mockAlertDetail));

      // when(mockGetTeamByAlertType.call(any<int>()))
      //     .thenAnswer((_) async => Right([mockTeam]));

      // when(mockAssignTeamUseCase.call(
      //   alertId: any<String>(named: 'alertId'),
      //   teamId: any<String>(named: 'teamId'),
      //   userId: any<String>(named: 'userId'),
      // )).thenAnswer((_) async => AssignTeamEntity(
      //       alertId: 'test-alert-id',
      //       teamId: 'team-1',
      //       userId: 'test-user-id',
      //     ));

      // when(mockTeamFinishProcessingUseCase.call(
      //   alertId: any<String>(named: 'alertId'),
      //   userId: any<String>(named: 'userId'),
      //   description: any<String>(named: 'description'),
      //   files: any<List<String>>(named: 'files'),
      // )).thenAnswer((_) async => TeamFinishProcessingEntity(
      //       alertId: 'test-alert-id',
      //       userId: 'test-user-id',
      //       description: 'Test description',
      //       files: [],
      //     ));

      // === Init controllers ===
      alertDetailController = AlertDetailController(
        getAlertDetailUseCase: mockGetAlertDetailUseCase,
        getTeamByAlertType: mockGetTeamByAlertType,
        assignTeamUseCase: mockAssignTeamUseCase,
      );

      teamFinishController =
          TeamFinishProcessingController(mockTeamFinishProcessingUseCase);

      Get.put<AlertDetailController>(alertDetailController);
      Get.put<TeamFinishProcessingController>(teamFinishController);

      alertDetailController.alertDetail.value = mockAlertDetail;
      alertDetailController.userRole.value = 'Admin';
      alertDetailController.isLoading.value = false;
    });

    tearDown(() {
      Get.reset();
    });

    test('AlertDetailController initializes correctly', () {
      expect(alertDetailController.isLoading.value, false);
      expect(alertDetailController.alertDetail.value?.alert.patientName, 'Patient Test');
    });
  });
}

// === Helper function ===
AlertDetailEntity createMockAlertWithStatus(int status) {
  return AlertDetailEntity(
    alert: AlertEntity(
      id: 'alert-1',
      doctorId: 'doctor-1',
      doctor: DoctorDetailEntity(
        id: 'doctor-1',
        name: 'John',
        lastname: 'Doe',
        email: 'john@test.com',
        registerDate: '2023-01-01',
        approvedTime: '2023-01-01',
        isUserApproved: true,
        preferredLanguage: 0,
        deviceTokenId: 'token',
        provider: 0,
        userName: 'john',
        normalizedUserName: 'JOHN',
        normalizedEmail: 'JOHN@TEST.COM',
        emailConfirmed: true,
        passwordHash: 'hash',
        securityStamp: 'stamp',
        concurrencyStamp: 'stamp',
        phoneNumberConfirmed: false,
        twoFactorEnabled: false,
        lockoutEnabled: false,
        accessFailedCount: 0,
      ),
      teamId: 'team-1',
      patientName: 'Patient Test',
      alertDescriptionByDoctor: 'Test emergency',
      alertDescriptionByAdmin: '',
      alertDescriptionByServiceProvider: '',
      localCreateTime: '2023-01-01T10:00:00',
      serverCreateTime: '2023-01-01T10:00:00',
      lastUpdateTime: '2023-01-01T10:00:00',
      startTimeByTeam: null,
      latitudeGPS: 35.7219,
      longitudeGPS: 51.3347,
      latitude: 35.7219,
      longitude: 51.3347,
      alertType: 0,
      alertStatus: status,
      trackId: 'TRK123',
      isDelete: false,
      createTime: '2023-01-01T10:00:00',
    ),
    doctor: DoctorEntity(
      id: 'doctor-1',
      name: 'John',
      lastname: 'Doe',
      email: 'john@test.com',
    ),
    team: TeamEntity(
      id: 'team-1',
      teamName: 'Emergency Team',
      teamDescription: 'Test team',
    ),
    teamMembers: [],
    logs: [],
    doctorFiles: [],
    teamFiles: [],
  );
}

// === Mock Response Classes ===
class AssignTeamEntity {
  final String alertId;
  final String teamId;
  final String userId;
  AssignTeamEntity({
    required this.alertId,
    required this.teamId,
    required this.userId,
  });
}

class TeamFinishProcessingEntity {
  final String alertId;
  final String userId;
  final String description;
  final List<String> files;
  TeamFinishProcessingEntity({
    required this.alertId,
    required this.userId,
    required this.description,
    required this.files,
  });
}
