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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    controller.getTeamsByUserId();

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryColor.withOpacity(0.3),
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.primaryColor.withOpacity(0.1),
                    Colors.black,
                    Colors.black,
                  ]
                : [
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
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: context.height * 0.88,
                child: Column(
                  children: [
                    ConstantSpace.largeVerticalSpacer,
                    ConstantSpace.largeVerticalSpacer,
                    profileHeader(isDark),
                    ConstantSpace.mediumVerticalSpacer,
                    searching(context, searchController, isDark),
                    ConstantSpace.mediumVerticalSpacer,
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }

                        if (controller.errorMessage.value.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error, 
                                  size: 64, 
                                  color: isDark ? Colors.red[300] : Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
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
                                  color: isDark ? Colors.grey[400] : Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.searchQuery.value.isNotEmpty
                                      ? 'no_results_for'.tr +
                                            ' "${controller.searchQuery.value}"'
                                      : 'no_teams_found'.tr,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
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
                            return _buildTeamCard(team, isDark);
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

  Widget profileHeader(bool isDark) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'my_teams'.tr,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${controller.userTeams.length} ${'teams_available'.tr}',
                style: TextStyle(
                  fontSize: 12, 
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(54),
            color: isDark ? Colors.grey[800] : AppColors.backgroundColor,
            border: Border.all(
              color: isDark ? Colors.grey[600]! : AppColors.borderColor, 
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? Colors.white70 : Colors.black,
                ),
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

  Widget searching(BuildContext context, TextEditingController searchCtrl, bool isDark) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: searchCtrl,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        onChanged: (value) {
          controller.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'search_teams'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey, 
            fontSize: 14,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.clear, 
                  size: 20, 
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
                onPressed: () {
                  searchCtrl.clear();
                  controller.clearSearch();
                },
              );
            }
            return Icon(
              Icons.search, 
              color: isDark ? Colors.grey[400] : Colors.grey,
            );
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(TeamEntity team, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TeamDetailsPage(teamId: team.id));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1, 
            color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team.formattedCreateTime,
                        style: TextStyle(
                          fontSize: 12, 
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
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
                    isDark ? Colors.blue[300]! : Colors.blue,
                    isDark,
                  ),
                if (team.isHouseholdCleaningAndDisinfection)
                  _buildServiceChip(
                    'household_cleaning'.tr,
                    Icons.home,
                    isDark ? Colors.green[300]! : Colors.green,
                    isDark,
                  ),
                if (team.isPatientsReferral)
                  _buildServiceChip(
                    'patient_referral'.tr,
                    Icons.person_search,
                    isDark ? Colors.orange[300]! : Colors.orange,
                    isDark,
                  ),
                if (team.isSafeAndDignifiedBurial)
                  _buildServiceChip(
                    'safe_burial'.tr,
                    Icons.psychology,
                    isDark ? Colors.purple[300]! : Colors.purple,
                    isDark,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip(String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.2 : 0.1),
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