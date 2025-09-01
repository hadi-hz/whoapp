import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/presentation/controller/get_teams_by_member_id_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';

class UserTeamsScreen extends StatelessWidget {
  final GetTeamsByUserController controller =
      Get.find<GetTeamsByUserController>();
  final TextEditingController searchController = TextEditingController();

  UserTeamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getTeamsByUserId();

    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.4),
              AppColors.primaryColor.withOpacity(0.35),
              AppColors.primaryColor.withOpacity(0.3),
              AppColors.primaryColor.withOpacity(0.25),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            end: 16,
            start: 16,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.getTeamsByUserId();
            },
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: context.height * 0.88,
                child: Column(
                  children: [
                    ConstantSpace.largeVerticalSpacer,
                    ConstantSpace.largeVerticalSpacer,
                    profileHeader(),
                    ConstantSpace.mediumVerticalSpacer,
                    searching(context, searchController),
                    ConstantSpace.mediumVerticalSpacer,
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
                                  onPressed: () =>
                                      controller.getTeamsByUserId(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('retry'.tr),
                                ),
                              ],
                            ),
                          );
                        }

                        final filteredTeams = controller.filteredTeams;

                        if (filteredTeams.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.searchQuery.value.isNotEmpty
                                      ? Icons.search_off
                                      : Icons.groups_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.searchQuery.value.isNotEmpty
                                      ? 'no_results_for'.tr +
                                            ' "${controller.searchQuery.value}"'
                                      : 'no_teams_found'.tr,
                                ),
                                if (controller
                                    .searchQuery
                                    .value
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      searchController.clear();
                                      controller.clearSearch();
                                    },
                                    child: Text('clear_filters'.tr),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: filteredTeams.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final team = filteredTeams[index];
                            return _buildTeamCard(team);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'my_teams'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${controller.userTeams.length} ${'teams_available'.tr}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(54),
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.notifications_none_rounded),
                ConstantSpace.mediumHorizontalSpacer,
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 24,
                  child: Icon(Icons.person, color: AppColors.backgroundColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searching(BuildContext context, TextEditingController searchCtrl) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: searchCtrl,
        onChanged: (value) {
          controller.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'search_teams'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                onPressed: () {
                  searchCtrl.clear();
                  controller.clearSearch();
                },
              );
            }
            return const Icon(Icons.search, color: Colors.grey);
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
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
