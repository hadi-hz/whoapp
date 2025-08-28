import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

class TeamDetailsPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final String teamId;

  TeamDetailsPage({Key? key, required this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeController.getTeamById(teamId);

    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (homeController.isLoadingGetTeamById.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (homeController.errorMessageGetTeamById.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(homeController.errorMessageGetTeamById.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => homeController.getTeamById(teamId),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        final team = homeController.currentTeam.value;
        if (team == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(team),
              const SizedBox(height: 16),
              _buildServicesCard(team),
              const SizedBox(height: 16),
              _buildMembersCard(team),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(TeamEntity team) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.group, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'team_info'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('name'.tr, team.name),
            const SizedBox(height: 8),
            _buildInfoRow('description'.tr, team.description),
            const SizedBox(height: 8),
            _buildInfoRow('created_at'.tr, _formatDate(team.createTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard(TeamEntity team) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'services'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildServiceItem(
              'healthcare_cleaning'.tr,
              team.isHealthcareCleaningAndDisinfection,
            ),
            _buildServiceItem(
              'household_cleaning'.tr,
              team.isHouseholdCleaningAndDisinfection,
            ),
            _buildServiceItem('patients_referral'.tr, team.isPatientsReferral),
            _buildServiceItem('safe_burial'.tr, team.isSafeAndDignifiedBurial),
          ],
        ),
      ),
    );
  }

Widget _buildMembersCard(TeamEntity team) {
  // اگه members خالی باشه، هیچی برنگردون
  if (team.members.isEmpty) {
    return const SizedBox.shrink();
  }

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'members'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
            ),
          
          const SizedBox(height: 12),
          Column(
            children: team.members.map<Widget>((member) {
              String memberName;
              if (member is String) {
                memberName = member;
              } else if (member is Map<String, dynamic>) {
                memberName = member['name'] ?? 
                            member['email'] ?? 
                            'Unknown Member';
              } else {
                memberName = member.toString();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(memberName),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildServiceItem(String service, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(service),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day}/${date.month}/${date.year}";
  }
}
