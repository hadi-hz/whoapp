import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/create_team_bottomsheet.dart';
import 'package:test3/features/home/presentation/pages/widgets/team_detail_screen.dart';

class TeamsScreen extends StatelessWidget {
  TeamsScreen({super.key});

  final TextEditingController search = TextEditingController();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 80 , start: 100 , end: 100),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () {
                Get.bottomSheet(
                  CreateTeamBottomSheet(),
                  isScrollControlled: true,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.background),
                  Text(
                    'add_team'.tr,
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          child: Column(
            children: [
              ConstantSpace.largeVerticalSpacer,
              ConstantSpace.largeVerticalSpacer,
              profileHeader(),
              ConstantSpace.mediumVerticalSpacer,
              searching(context, search),
              ConstantSpace.mediumVerticalSpacer,
              buildExpandableFiltersContainer(),
              ConstantSpace.mediumVerticalSpacer,

              Expanded(
                child: Obx(() {
                  if (homeController.isLoadingTeam.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (homeController.errorMessageTeam.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(homeController.errorMessageTeam.value),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => homeController.fetchTeams(),
                            child: Text('retry'.tr),
                          ),
                        ],
                      ),
                    );
                  }

                  if (homeController.filteredTeams.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text('no_teams_found'.tr),
                          if (homeController.nameFilterTeam.value.isNotEmpty ||
                              homeController.healthcareFilter.value != null ||
                              homeController.householdFilter.value != null ||
                              homeController.referralFilter.value != null ||
                              homeController.burialFilter.value != null) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                search.clear();
                                homeController.clearAllFiltersTeam();
                              },
                              child: Text('clear_filters'.tr),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: homeController.filteredTeams.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final team = homeController.filteredTeams[index];
                      return _buildTeamCard(team);
                    },
                  );
                }),
              ),
            ],
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Container(
                child: Icon(
                  Icons.groups,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ),

            const SizedBox(width: 16),

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
                    '${team.membersCount} ${'members'.tr}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                const SizedBox(height: 4),
                Text(
                  team.formattedCreateTime,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableFiltersContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              homeController.toggleFiltersExpansionTeam();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: homeController.isFiltersExpandedTeam.value
                      ? const BorderRadius.vertical(top: Radius.circular(16))
                      : BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tune, color: AppColors.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'capability_filters'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),

                    Obx(() {
                      int activeFilters = 0;
                      if (homeController.nameFilterTeam.value.isNotEmpty)
                        activeFilters++;
                      if (homeController.healthcareFilter.value != null)
                        activeFilters++;
                      if (homeController.householdFilter.value != null)
                        activeFilters++;
                      if (homeController.referralFilter.value != null)
                        activeFilters++;
                      if (homeController.burialFilter.value != null)
                        activeFilters++;

                      return activeFilters > 0
                          ? Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$activeFilters',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                    AnimatedRotation(
                      turns: homeController.isFiltersExpandedTeam.value
                          ? 0.5
                          : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: homeController.isFiltersExpandedTeam.value ? null : 0,
              child: AnimatedOpacity(
                opacity: homeController.isFiltersExpandedTeam.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: homeController.isFiltersExpandedTeam.value
                    ? buildFiltersContent()
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searching(BuildContext context, TextEditingController controller) {
    return Obx(
      () => Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: homeController.nameFilterTeam.value.isNotEmpty
                ? AppColors.primaryColor
                : AppColors.borderColor,
            width: homeController.nameFilterTeam.value.isNotEmpty ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: (value) {
            homeController.setNameFilterTeam(value);
          },
          decoration: InputDecoration(
            hintText: 'search_teams'.tr,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            suffixIcon: homeController.nameFilterTeam.value.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      controller.clear();
                      homeController.setNameFilterTeam("");
                    },
                  )
                : const Icon(Icons.search, color: Colors.grey),
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
              'teams_management'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${homeController.totalTeams} ${'teams_available'.tr}',
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

  Widget buildFiltersContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCapabilityFilter(
                  'healthcare_cleaning'.tr,
                  homeController.healthcareFilter,
                  homeController.setHealthcareFilter,
                  Icons.local_hospital,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapabilityFilter(
                  'household_cleaning'.tr,
                  homeController.householdFilter,
                  homeController.setHouseholdFilter,
                  Icons.home,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildCapabilityFilter(
                  'patient_referral'.tr,
                  homeController.referralFilter,
                  homeController.setReferralFilter,
                  Icons.person_search,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapabilityFilter(
                  'burial_services'.tr,
                  homeController.burialFilter,
                  homeController.setBurialFilter,
                  Icons.psychology,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: homeController.applyFiltersTeam,
                  icon: const Icon(Icons.search, size: 18),
                  label: Text('apply_filters'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    search.clear();
                    homeController.clearAllFiltersTeam();
                  },
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: Text('clear_all_filters'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    foregroundColor: Colors.grey[700],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityFilter(
    String label,
    Rxn<bool> filterValue,
    Function(bool?) onChanged,
    IconData icon,
    Color color,
  ) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filterValue.value != null
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            width: filterValue.value != null ? 2 : 1,
          ),
          color: filterValue.value != null
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: filterValue.value != null
                          ? AppColors.primaryColor
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterOption('all'.tr, null, filterValue, onChanged),
                _buildFilterOption('yes'.tr, true, filterValue, onChanged),
                _buildFilterOption('no'.tr, false, filterValue, onChanged),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String label,
    bool? value,
    Rxn<bool> currentValue,
    Function(bool?) onChanged,
  ) {
    final isSelected = currentValue.value == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
