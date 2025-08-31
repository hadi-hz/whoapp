import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/usecase/get_teams_by_member_id_usecase.dart';

class GetTeamsByUserController extends GetxController {
  final GetTeamsByUserUseCase _getTeamsByUserUseCase;

  GetTeamsByUserController(this._getTeamsByUserUseCase);

  final RxList<TeamEntity> userTeams = <TeamEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  List<TeamEntity> get filteredTeams {
    if (searchQuery.value.isEmpty) {
      return userTeams;
    }
    return userTeams.where((team) =>
        team.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  Future<void> getTeamsByUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final teams = await _getTeamsByUserUseCase.call(savedUserId ?? "");
      userTeams.value = teams;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearTeams() {
    userTeams.clear();
    errorMessage.value = '';
  }
}