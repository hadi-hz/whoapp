import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key});

  final TextEditingController search = TextEditingController();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await homeController.fetchUsers();
                  },
                  color: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  child: Obx(() {
                    if (homeController.isLoadingUsers.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (homeController.errorMessageUsers.value.isNotEmpty) {
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
                            Text(homeController.errorMessage.value),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => homeController.fetchUsers(),
                              child: Text('retry'.tr),
                            ),
                          ],
                        ),
                      );
                    }

                    if (homeController.users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text('no_users_found'.tr),
                            if (homeController.nameFilter.value.isNotEmpty ||
                                homeController.emailFilter.value.isNotEmpty ||
                                homeController.roleFilter.value.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  search.clear();
                                  homeController.clearAllFilters();
                                },
                                child: Text('clear_filters'.tr),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: homeController.users.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = homeController.users[index];
                        return _buildUserCard(user);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserDetailScreen(userId: user.id));
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
              child: ClipOval(
                child: user.profileImageUrl.isNotEmpty
                    ? Image.network(
                        user.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                              size: 30,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName.isNotEmpty ? user.fullName : 'no_name'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  if (user.roles.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: user.roles.map((role) {
                        Color roleColor = role == 'Admin'
                            ? Colors.purple
                            : role == 'Doctor'
                            ? Colors.blue
                            : Colors.grey;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: roleColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: roleColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              children: [
                Icon(
                  user.isApproved ? Icons.check_circle : Icons.cancel,
                  color: user.isApproved ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  user.isApproved ? 'approved'.tr : 'pending'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: user.isApproved ? Colors.green : Colors.red,
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
              homeController.toggleFiltersExpansion();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: homeController.isFiltersExpanded.value
                      ? const BorderRadius.vertical(top: Radius.circular(16))
                      : BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'filters'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),

                    Obx(() {
                      int activeFilters = 0;
                      if (homeController.nameFilter.value.isNotEmpty)
                        activeFilters++;
                      if (homeController.emailFilter.value.isNotEmpty)
                        activeFilters++;
                      if (homeController.roleFilter.value.isNotEmpty)
                        activeFilters++;
                      if (homeController.isApprovedFilter.value != null)
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
                      turns: homeController.isFiltersExpanded.value ? 0.5 : 0,
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
              height: homeController.isFiltersExpanded.value ? null : 0,
              child: AnimatedOpacity(
                opacity: homeController.isFiltersExpanded.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: homeController.isFiltersExpanded.value
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
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor, width: 1),
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
          homeController.setNameFilter(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_name_or_email'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: Obx(() {
            if (homeController.nameFilter.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  homeController.setNameFilter("");
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

  Widget profileHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'users_management'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${homeController.totalUsers} ${'users_available'.tr}',
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
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: homeController.roleFilter.value.isEmpty
                        ? null
                        : homeController.roleFilter.value,
                    decoration: InputDecoration(
                      labelText: 'filter_by_role'.tr,
                      labelStyle: TextStyle(
                        color: homeController.roleFilter.value.isNotEmpty
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.roleFilter.value.isNotEmpty
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.roleFilter.value.isNotEmpty
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          width: homeController.roleFilter.value.isNotEmpty
                              ? 2
                              : 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('all_roles'.tr),
                      ),
                      ...homeController.roleOptions.map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      ),
                    ],
                    onChanged: (value) =>
                        homeController.setRoleFilter(value ?? ''),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<bool?>(
                    value: homeController.isApprovedFilter.value,
                    decoration: InputDecoration(
                      labelText: 'filter_by_approval'.tr,
                      labelStyle: TextStyle(
                        color: homeController.isApprovedFilter.value != null
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.isApprovedFilter.value != null
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.isApprovedFilter.value != null
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          width: homeController.isApprovedFilter.value != null
                              ? 2
                              : 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('all_statuses'.tr),
                      ),
                      DropdownMenuItem(value: true, child: Text('approved'.tr)),
                      DropdownMenuItem(value: false, child: Text('pending'.tr)),
                    ],
                    onChanged: homeController.setApprovalFilter,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: homeController.sortBy.value.isEmpty
                        ? null
                        : homeController.sortBy.value,
                    decoration: InputDecoration(
                      labelText: 'sort_by'.tr,
                      labelStyle: TextStyle(
                        color: homeController.sortBy.value != 'Email'
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.sortBy.value != 'Email'
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          width: homeController.sortBy.value != 'Email' ? 2 : 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: homeController.sortOptions
                        .map(
                          (sort) => DropdownMenuItem(
                            value: sort,
                            child: Text(sort.toLowerCase().tr),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        homeController.setSortBy(value ?? 'Email'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text('sort_order'.tr, style: const TextStyle(fontSize: 12)),
                  Obx(
                    () => Switch(
                      value: homeController.sortDesc.value,
                      activeColor: AppColors.primaryColor,

                      onChanged: homeController.setSortDirection,
                    ),
                  ),
                  Text('descending'.tr, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: homeController.applyFiltersUsers,
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
                    homeController.clearAllFilters();
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
}
