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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
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
                    Colors.white,
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
              await homeController.fetchTeams();
            },
            color: AppColors.primaryColor,
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ConstantSpace.largeVerticalSpacer,
                  ConstantSpace.largeVerticalSpacer,
                  profileHeader(isDark),
                  ConstantSpace.mediumVerticalSpacer,
                  searching(context, search, isDark),
                  ConstantSpace.mediumVerticalSpacer,
                  buildExpandableFiltersContainer(isDark),
                  ConstantSpace.smallVerticalSpacer,
                  Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
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
                          Icon(Icons.add, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'add_team'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.6,
                    child: Obx(() {
                      if (homeController.isLoadingTeam.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (homeController.errorMessageTeam.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: isDark ? Colors.red[300] : Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                homeController.errorMessageTeam.value,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => homeController.fetchTeams(),
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

                      if (homeController.filteredTeams.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.groups_outlined,
                                size: 64,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_teams_found'.tr,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              if (homeController
                                      .nameFilterTeam
                                      .value
                                      .isNotEmpty ||
                                  homeController.healthcareFilter.value !=
                                      null ||
                                  homeController.householdFilter.value !=
                                      null ||
                                  homeController.referralFilter.value != null ||
                                  homeController.burialFilter.value !=
                                      null) ...[
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
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: homeController.filteredTeams.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final team = homeController.filteredTeams[index];
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : AppColors.borderColor, 
                  width: 1,
                ),
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.groups,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
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
                    '${team.memberCount} ${'members'.tr}',
                    style: TextStyle(
                      fontSize: 14, 
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Icon(
                  Icons.calendar_today, 
                  color: isDark ? Colors.grey[400] : Colors.grey[600], 
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  team.formattedCreateTime,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableFiltersContainer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
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
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
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
                    ? buildFiltersContent(isDark)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searching(BuildContext context, TextEditingController controller, bool isDark) {
    return Obx(
      () => Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.grey[850] : Colors.white,
          border: Border.all(
            color: homeController.nameFilterTeam.value.isNotEmpty
                ? AppColors.primaryColor
                : (isDark ? Colors.grey[700]! : AppColors.borderColor),
            width: homeController.nameFilterTeam.value.isNotEmpty ? 2 : 1,
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
          controller: controller,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          onChanged: (value) {
            homeController.setNameFilterTeam(value);
          },
          decoration: InputDecoration(
            hintText: 'search_teams'.tr,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey, 
              fontSize: 14,
            ),
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
                : Icon(
                    Icons.search, 
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
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
              'teams_management'.tr,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${homeController.totalTeams} ${'teams_available'.tr}',
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

  Widget buildFiltersContent(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
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
                  isDark ? Colors.blue[300]! : Colors.blue,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapabilityFilter(
                  'household_cleaning'.tr,
                  homeController.householdFilter,
                  homeController.setHouseholdFilter,
                  Icons.home,
                  isDark ? Colors.green[300]! : Colors.green,
                  isDark,
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
                  isDark ? Colors.orange[300]! : Colors.orange,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCapabilityFilter(
                  'burial_services'.tr,
                  homeController.burialFilter,
                  homeController.setBurialFilter,
                  Icons.psychology,
                  isDark ? Colors.purple[300]! : Colors.purple,
                  isDark,
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
                    backgroundColor: isDark 
                        ? Colors.grey[700] 
                        : Colors.grey.withOpacity(0.2),
                    foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
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
    bool isDark,
  ) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filterValue.value != null
                ? AppColors.primaryColor
                : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
            width: filterValue.value != null ? 2 : 1,
          ),
          color: filterValue.value != null
              ? AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1)
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
                          : (isDark ? Colors.grey[400] : Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterOption('all'.tr, null, filterValue, onChanged, isDark),
                _buildFilterOption('yes'.tr, true, filterValue, onChanged, isDark),
                _buildFilterOption('no'.tr, false, filterValue, onChanged, isDark),
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
    bool isDark,
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
            color: isSelected 
                ? AppColors.primaryColor 
                : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}