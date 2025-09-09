import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/home/domain/entities/users_entity.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/notification_page.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key});

  final TextEditingController search = TextEditingController();
  final controller = Get.find<AuthController>();
  final HomeController homeController = Get.find<HomeController>();
  bool _isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768;
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
          padding: screenPadding ,
          child: Column(
            children: [
           SizedBox(height: isTablet ? 32 : 24),
              profileHeader(isDark , isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              searching(context, search, isDark),
            SizedBox(height: isTablet ? 24 : 16),
              buildExpandableFiltersContainer(isDark),
                 SizedBox(height: isTablet ? 24 : 16),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await homeController.fetchUsers();
                  },
                  color: AppColors.primaryColor,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  child: Obx(() {
                    if (homeController.isLoadingUsers.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (homeController.errorMessageUsers.value.isNotEmpty) {
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
                              homeController.errorMessage.value,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => homeController.fetchUsers(),
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

                    if (homeController.users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_users_found'.tr,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
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
                        return _buildUserCard(user, isDark);
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

  Widget _buildUserCard(UserEntity user, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserDetailScreen(userId: user.id));
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14, 
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  if (user.roles.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: user.roles.map((role) {
                        Color roleColor = role == 'Admin'
                            ? (isDark ? Colors.purple[300]! : Colors.purple)
                            : role == 'Doctor'
                            ? (isDark ? Colors.blue[300]! : Colors.blue)
                            : (isDark ? Colors.grey[400]! : Colors.grey);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(isDark ? 0.2 : 0.1),
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
              homeController.toggleFiltersExpansion();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
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
        controller: controller,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        onChanged: (value) {
          homeController.setNameFilter(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_name_or_email'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey, 
            fontSize: 14,
          ),
          suffixIcon: Obx(() {
            if (homeController.nameFilter.value.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.clear, 
                  size: 20, 
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
                onPressed: () {
                  controller.clear();
                  homeController.setNameFilter("");
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

  Widget profileHeader(bool isDark, bool isTablet) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'users_management'.tr,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${homeController.totalUsers} ${'users_available'.tr}',
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
                Obx(() {
                  final unreadCount =
                      controller.currentLoginUser.value?.unReadMessagesCount ??
                      0;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          homeController.isNotificationSelected.value = true;
                          homeController.isProfileSelected.value = false;

                          Future.delayed(const Duration(milliseconds: 200), () {
                            Get.to(
                              NotificationPage(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 400),
                            )?.then((_) {
                              homeController.isNotificationSelected.value =
                                  false;
                              homeController.isProfileSelected.value = true;
                            });
                          });
                        },
                        child: Obx(
                          () => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(isTablet ? 12 : 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    homeController.isNotificationSelected.value
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: homeController.isNotificationSelected.value
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: isTablet ? 24 : 20,
                              color: homeController.isNotificationSelected.value
                                  ? AppColors.background
                                  : (isDark ? Colors.white70 : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 3 : 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 10 : 8,
                              ),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : AppColors.backgroundColor,
                                width: 1,
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: isTablet ? 20 : 16,
                              minHeight: isTablet ? 20 : 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                SizedBox(width: isTablet ? 16 : 12),
                GestureDetector(
                  onTap: () {
                    homeController.isProfileSelected.value = true;
                    homeController.isNotificationSelected.value = false;
                  },
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: homeController.isProfileSelected.value
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: homeController.isProfileSelected.value
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: CircleAvatar(
                        backgroundColor: homeController.isProfileSelected.value
                            ? AppColors.primaryColor.withOpacity(0.9)
                            : AppColors.primaryColor,
                        radius: isTablet ? 30 : 24,
                        child: Icon(
                          Icons.person,
                          color: AppColors.backgroundColor,
                          size: homeController.isProfileSelected.value
                              ? (isTablet ? 32 : 26)
                              : (isTablet ? 30 : 24),
                        ),
                      ),
                    ),
                  ),
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
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: homeController.roleFilter.value.isEmpty
                        ? null
                        : homeController.roleFilter.value,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'filter_by_role'.tr,
                      labelStyle: TextStyle(
                        color: homeController.roleFilter.value.isNotEmpty
                            ? AppColors.primaryColor
                            : (isDark ? Colors.grey[400] : Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.roleFilter.value.isNotEmpty
                              ? AppColors.primaryColor
                              : (isDark ? Colors.grey[600]! : Colors.grey),
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
                              : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
                          width: homeController.roleFilter.value.isNotEmpty
                              ? 2
                              : 1,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
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
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'filter_by_approval'.tr,
                      labelStyle: TextStyle(
                        color: homeController.isApprovedFilter.value != null
                            ? AppColors.primaryColor
                            : (isDark ? Colors.grey[400] : Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: homeController.isApprovedFilter.value != null
                              ? AppColors.primaryColor
                              : (isDark ? Colors.grey[600]! : Colors.grey),
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
                              : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
                          width: homeController.isApprovedFilter.value != null
                              ? 2
                              : 1,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
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
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'sort_by'.tr,
                      labelStyle: TextStyle(
                        color: homeController.sortBy.value != 'Email'
                            ? AppColors.primaryColor
                            : (isDark ? Colors.grey[400] : Colors.grey),
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
                              : (isDark ? Colors.grey[600]! : Colors.grey.shade300),
                          width: homeController.sortBy.value != 'Email' ? 2 : 1,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
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
                  Text(
                    'sort_order'.tr, 
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: homeController.sortDesc.value,
                      activeColor: AppColors.primaryColor,
                      inactiveThumbColor: isDark ? Colors.grey[600] : Colors.grey[300],
                      inactiveTrackColor: isDark ? Colors.grey[700] : Colors.grey[200],
                      onChanged: homeController.setSortDirection,
                    ),
                  ),
                  Text(
                    'descending'.tr, 
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
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
}