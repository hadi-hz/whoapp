import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/presentation/controller/get_teams_by_member_id_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';

class UserTeamsScreen extends StatelessWidget {
  final GetTeamsByUserController controller =
      Get.find<GetTeamsByUserController>();

  UserTeamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getTeamsByUserId();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.getTeamsByUserId(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.userTeams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('no_teams_found'.tr),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsetsDirectional.only(
            top: 70,
            end: 16,
            start: 16,
          ),
          itemCount: controller.userTeams.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final team = controller.userTeams[index];
            return _buildTeamCard(team);
          },
        );
      }),
    );
  }

  Widget _buildTeamCard(TeamEntity team) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TeamDetailsPage(teamId: team.id));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: AppColors.borderColor),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.groups,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team.formattedCreateTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              team.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (team.isHealthcareCleaningAndDisinfection)
                  _buildServiceChip(
                    'healthcare_cleaning'.tr,
                    Icons.local_hospital,
                    Colors.blue,
                  ),
                if (team.isHouseholdCleaningAndDisinfection)
                  _buildServiceChip(
                    'household_cleaning'.tr,
                    Icons.home,
                    Colors.green,
                  ),
                if (team.isPatientsReferral)
                  _buildServiceChip(
                    'patient_referral'.tr,
                    Icons.person_search,
                    Colors.orange,
                  ),
                if (team.isSafeAndDignifiedBurial)
                  _buildServiceChip(
                    'safe_burial'.tr,
                    Icons.psychology,
                    Colors.purple,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
