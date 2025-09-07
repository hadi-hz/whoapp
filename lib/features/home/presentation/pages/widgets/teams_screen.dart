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

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768;
  }

  bool _isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 3;
    if (width >= 900) return 2;
    if (width >= 600) return 2;
    return 1;
  }

  EdgeInsets _getScreenPadding(BuildContext context) {
    if (_isLargeTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (_isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = _isTablet(context);
    final screenPadding = _getScreenPadding(context);

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
          padding: screenPadding,
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
                  SizedBox(height: isTablet ? 32 : 24),
                  profileHeader(isDark, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  searching(context, search, isDark, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  buildExpandableFiltersContainer(isDark, isTablet),
                  SizedBox(height: isTablet ? 16 : 8),
                  SizedBox(
                    height: isTablet
                        ? context.height * 0.65
                        : context.height * 0.6,
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
                                size: isTablet ? 80 : 64,
                                color: isDark ? Colors.red[300] : Colors.red,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              Text(
                                homeController.errorMessageTeam.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              ElevatedButton(
                                onPressed: () => homeController.fetchTeams(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 24 : 16,
                                    vertical: isTablet ? 16 : 12,
                                  ),
                                ),
                                child: Text(
                                  'retry'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
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
                                size: isTablet ? 80 : 64,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              Text(
                                'no_teams_found'.tr,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
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
                                SizedBox(height: isTablet ? 12 : 8),
                                TextButton(
                                  onPressed: () {
                                    search.clear();
                                    homeController.clearAllFiltersTeam();
                                  },
                                  child: Text(
                                    'clear_filters'.tr,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: isTablet && _getCrossAxisCount(context) > 1
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _getCrossAxisCount(
                                        context,
                                      ),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: _isLargeTablet(context)
                                          ? 3.2
                                          : 2.8,
                                    ),
                                itemCount: homeController.filteredTeams.length,
                                itemBuilder: (context, index) {
                                  final team =
                                      homeController.filteredTeams[index];
                                  return _buildTeamCard(team, isDark, isTablet);
                                },
                              )
                            : Column(
                                children: homeController.filteredTeams.map((
                                  team,
                                ) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isTablet ? 16 : 12,
                                    ),
                                    child: _buildTeamCard(
                                      team,
                                      isDark,
                                      isTablet,
                                    ),
                                  );
                                }).toList(),
                              ),
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

  Widget _buildTeamCard(TeamEntity team, bool isDark, bool isTablet) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TeamDetailsPage(teamId: team.id));
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          border: Border.all(
            width: isTablet ? 2 : 1,
            color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black12,
              blurRadius: isTablet ? 8 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isTablet ? 60 : 50,
              height: isTablet ? 60 : 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : AppColors.borderColor,
                  width: isTablet ? 2 : 1,
                ),
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.groups,
                color: AppColors.primaryColor,
                size: isTablet ? 36 : 30,
              ),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: isTablet ? 6 : 4),
                  Text(
                    '${team.memberCount} ${'members'.tr}',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                ],
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  size: isTablet ? 24 : 20,
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  team.formattedCreateTime,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
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

  Widget buildExpandableFiltersContainer(bool isDark, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isTablet ? 12 : 8,
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
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: homeController.isFiltersExpandedTeam.value
                      ? BorderRadius.vertical(
                          top: Radius.circular(isTablet ? 20 : 16),
                        )
                      : BorderRadius.circular(isTablet ? 20 : 16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune,
                      color: AppColors.primaryColor,
                      size: isTablet ? 24 : 20,
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'capability_filters'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
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
                              margin: EdgeInsets.only(right: isTablet ? 12 : 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 10 : 8,
                                vertical: isTablet ? 6 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
                              ),
                              child: Text(
                                '$activeFilters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
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
                        size: isTablet ? 24 : 20,
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
                    ? buildFiltersContent(isDark, isTablet)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget searching(
  BuildContext context,
  TextEditingController controller,
  bool isDark,
  bool isTablet,
) {
  return Obx(
    () => Row(
      children: [
        Expanded(
          flex: isTablet ? 3 : 2, 
          child: _buildSearchField(controller, isDark, isTablet),
        ),
        SizedBox(width: isTablet ? 16 : 8),
        Expanded(
          flex: 1,
          child: _buildAddTeamButton(isTablet, context),
        ),
      ],
    ),
  );
}

  Widget _buildSearchField(
    TextEditingController controller,
    bool isDark,
    bool isTablet,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: isTablet ? 16 : 14,
        ),
        onChanged: (value) {
          homeController.setNameFilterTeam(value);
        },
        decoration: InputDecoration(
          hintText: 'search_teams'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey,
            fontSize: isTablet ? 16 : 14,
          ),
          suffixIcon: homeController.nameFilterTeam.value.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: isTablet ? 24 : 20,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    homeController.setNameFilterTeam("");
                  },
                )
              : Icon(
                  Icons.search,
                  size: isTablet ? 24 : 20,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 16,
            vertical: isTablet ? 16 : 12,
          ),
        ),
      ),
    );
  }

 Widget _buildAddTeamButton(bool isTablet, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
      ),
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 8,
        vertical: isTablet ? 16 : 12,
      ),
    ),
    onPressed: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CreateTeamBottomSheet(),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add, color: Colors.white, size: isTablet ? 20 : 18),
        if (MediaQuery.of(context).size.width > 300) ...[
          SizedBox(width: isTablet ? 8 : 4),
          Flexible(
            child: Text(
              'add_team'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    ),
  );
}

  Widget profileHeader(bool isDark, bool isTablet) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'teams_management'.tr,
              style: TextStyle(
                fontSize: isTablet ? 24 : 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Obx(
              () => Text(
                '${homeController.totalTeams} ${'teams_available'.tr}',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: isTablet ? 70 : 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isTablet ? 70 : 54),
            color: isDark ? Colors.grey[800] : AppColors.backgroundColor,
            border: Border.all(
              color: isDark ? Colors.grey[600]! : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? Colors.white70 : Colors.black,
                  size: isTablet ? 24 : 20,
                ),
                SizedBox(width: isTablet ? 16 : 12),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: isTablet ? 30 : 24,
                  child: Icon(
                    Icons.person,
                    color: AppColors.backgroundColor,
                    size: isTablet ? 30 : 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFiltersContent(bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(isTablet ? 20 : 16),
        ),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final shouldUseHorizontal = constraints.maxWidth > 600;

              if (shouldUseHorizontal) {
                return Column(
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
                            isTablet,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: _buildCapabilityFilter(
                            'household_cleaning'.tr,
                            homeController.householdFilter,
                            homeController.setHouseholdFilter,
                            Icons.home,
                            isDark ? Colors.green[300]! : Colors.green,
                            isDark,
                            isTablet,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
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
                            isTablet,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: _buildCapabilityFilter(
                            'burial_services'.tr,
                            homeController.burialFilter,
                            homeController.setBurialFilter,
                            Icons.psychology,
                            isDark ? Colors.purple[300]! : Colors.purple,
                            isDark,
                            isTablet,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildCapabilityFilter(
                      'healthcare_cleaning'.tr,
                      homeController.healthcareFilter,
                      homeController.setHealthcareFilter,
                      Icons.local_hospital,
                      isDark ? Colors.blue[300]! : Colors.blue,
                      isDark,
                      isTablet,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    _buildCapabilityFilter(
                      'household_cleaning'.tr,
                      homeController.householdFilter,
                      homeController.setHouseholdFilter,
                      Icons.home,
                      isDark ? Colors.green[300]! : Colors.green,
                      isDark,
                      isTablet,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    _buildCapabilityFilter(
                      'patient_referral'.tr,
                      homeController.referralFilter,
                      homeController.setReferralFilter,
                      Icons.person_search,
                      isDark ? Colors.orange[300]! : Colors.orange,
                      isDark,
                      isTablet,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    _buildCapabilityFilter(
                      'burial_services'.tr,
                      homeController.burialFilter,
                      homeController.setBurialFilter,
                      Icons.psychology,
                      isDark ? Colors.purple[300]! : Colors.purple,
                      isDark,
                      isTablet,
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: isTablet ? 20 : 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final shouldUseHorizontal = constraints.maxWidth > 400;

              if (shouldUseHorizontal) {
                return Row(
                  children: [
                    Expanded(child: _buildApplyButton(isTablet)),
                    SizedBox(width: isTablet ? 16 : 12),
                    Expanded(child: _buildClearButton(isDark, isTablet)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildApplyButton(isTablet),
                    SizedBox(height: isTablet ? 12 : 8),
                    _buildClearButton(isDark, isTablet),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(bool isTablet) {
    return ElevatedButton.icon(
      onPressed: homeController.applyFiltersTeam,
      icon: Icon(Icons.search, size: isTablet ? 20 : 18),
      label: Text(
        'apply_filters'.tr,
        style: TextStyle(fontSize: isTablet ? 16 : 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
      ),
    );
  }

  Widget _buildClearButton(bool isDark, bool isTablet) {
    return ElevatedButton.icon(
      onPressed: () {
        search.clear();
        homeController.clearAllFiltersTeam();
      },
      icon: Icon(Icons.clear_all, size: isTablet ? 20 : 18),
      label: Text(
        'clear_all_filters'.tr,
        style: TextStyle(fontSize: isTablet ? 16 : 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? Colors.grey[700]
            : Colors.grey.withOpacity(0.2),
        foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
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
    bool isTablet,
  ) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
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
                Icon(icon, color: color, size: isTablet ? 20 : 16),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w500,
                      color: filterValue.value != null
                          ? AppColors.primaryColor
                          : (isDark ? Colors.grey[400] : Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterOption(
                  'all'.tr,
                  null,
                  filterValue,
                  onChanged,
                  isDark,
                  isTablet,
                ),
                _buildFilterOption(
                  'yes'.tr,
                  true,
                  filterValue,
                  onChanged,
                  isDark,
                  isTablet,
                ),
                _buildFilterOption(
                  'no'.tr,
                  false,
                  filterValue,
                  onChanged,
                  isDark,
                  isTablet,
                ),
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
    bool isTablet,
  ) {
    final isSelected = currentValue.value == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 12 : 8,
          vertical: isTablet ? 6 : 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 10,
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
