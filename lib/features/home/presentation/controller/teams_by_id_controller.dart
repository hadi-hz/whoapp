import 'package:get/get.dart';
import 'package:test3/features/home/domain/usecase/get_team_by_id.dart';
import '../../domain/entities/team_by_id_response_entity.dart';

class GetTeamByIdController extends GetxController {
  final GetTeamByIdUseCase getTeamByIdUseCase;

  GetTeamByIdController({required this.getTeamByIdUseCase});

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<TeamByIdResponseEntity> teamDetail = Rxn<TeamByIdResponseEntity>();

  Future<void> fetchTeamById(String teamId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getTeamByIdUseCase.call(teamId);

      result.fold(
        (error) {
          errorMessage.value = error;
          teamDetail.value = null;
        },
        (response) {
          teamDetail.value = response;
          errorMessage.value = '';
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    teamDetail.value = null;
    errorMessage.value = '';
    isLoading.value = false;
  }
}