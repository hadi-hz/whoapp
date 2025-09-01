import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/presentation/controller/teams_by_id_controller.dart';

class TeamDetailsPage extends StatefulWidget {
  final String teamId;

  const TeamDetailsPage({Key? key, required this.teamId}) : super(key: key);

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  GetTeamByIdController? controller;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      controller = Get.find<GetTeamByIdController>();
      controller!.clearData();
      controller!.fetchTeamById(widget.teamId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (controller!.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller!.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller!.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller!.fetchTeamById(widget.teamId),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        final teamDetail = controller!.teamDetail.value;
        if (teamDetail == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(teamDetail.team),
              const SizedBox(height: 16),
              _buildServicesCard(teamDetail.team),
              const SizedBox(height: 16),
              _buildMembersCard(teamDetail.members),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(team) {
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

  Widget _buildServicesCard(team) {
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

  Widget _buildMembersCard(members) {
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
              ],
            ),
            const SizedBox(height: 12),
            if (members.isEmpty)
              Text(
                'no_members'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Column(
                children: members.map<Widget>((member) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('${member.name} ${member.lastname}'),
                        ),
                      
                        if (member.isRepresentative) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.local_police_rounded , color: AppColors.connecting,)
                      
                        ],
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
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateStr;
    }
  }
}
