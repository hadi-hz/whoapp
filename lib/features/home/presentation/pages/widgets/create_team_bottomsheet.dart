import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/presentation/controller/create_team_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

class CreateTeamBottomSheet extends StatefulWidget {
  CreateTeamBottomSheet({Key? key}) : super(key: key);

  @override
  _CreateTeamBottomSheetState createState() => _CreateTeamBottomSheetState();
}

class _CreateTeamBottomSheetState extends State<CreateTeamBottomSheet> {
  final CreateTeamController controller = Get.find<CreateTeamController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.9, 
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context, isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    16, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameField(context, isDark),
                  const SizedBox(height: 16),
                  _buildDescriptionField(context, isDark),
                  const SizedBox(height: 20),
                  _buildServicesSection(context, isDark),
                  const SizedBox(height: 20),
                  _buildMembersSection(context, isDark),
                  const SizedBox(height: 20),
                  _buildErrorMessage(),
                  _buildCreateButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.group_add, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Text(
            'create_new_team'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(BuildContext context, bool isDark) {
    return TextFormField(
      controller: controller.nameController,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'team_name'.tr,
        hintText: 'enter_team_name'.tr,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[500],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        prefixIcon: Icon(
          Icons.group,
          color: isDark ? Colors.grey[300] : Colors.grey[600],
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
      ),
    );
  }

  Widget _buildDescriptionField(BuildContext context, bool isDark) {
    return TextFormField(
      controller: controller.descriptionController,
      maxLines: 3,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'description'.tr,
        hintText: 'enter_description'.tr,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[500],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'team_services'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildServiceTile(
          context,
          'healthcare_cleaning'.tr,
          Icons.local_hospital,
          Colors.blue,
          controller.isHealthcare,
          isDark,
        ),
        _buildServiceTile(
          context,
          'household_cleaning'.tr,
          Icons.home,
          Colors.green,
          controller.isHousehold,
          isDark,
        ),
        _buildServiceTile(
          context,
          'patient_referral'.tr,
          Icons.person_search,
          Colors.orange,
          controller.isReferral,
          isDark,
        ),
        _buildServiceTile(
          context,
          'burial_services'.tr,
          Icons.psychology,
          Colors.purple,
          controller.isBurial,
          isDark,
        ),
      ],
    );
  }

  Widget _buildMembersSection(BuildContext context, bool isDark) {
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'select_members'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Obx(
              () => Text(
                '${controller.selectedMembers.length} ${'selected'.tr}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isDark ? Colors.grey[800] : Colors.grey[50],
          ),
          child: TextFormField(
            controller: controller.searchController,
            onChanged: (value) => homeController.setUserSearchQuery(value),
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'search_users'.tr,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
              suffixIcon: Obx(
                () => homeController.userSearchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                        ),
                        onPressed: () {
                         controller. searchController.clear();
                          homeController.setUserSearchQuery('');
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Obx(() {
          if (homeController.isLoadingUsers.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final approvedUsers = homeController.users.where((user) {
            if (!user.isApproved) return false;
            if (homeController.userSearchQuery.value.isNotEmpty) {
              final query = homeController.userSearchQuery.value.toLowerCase();
              return user.fullName.toLowerCase().contains(query) ||
                  (user.email?.toLowerCase().contains(query) ?? false);
            }
            return true;
          }).toList();

          if (approvedUsers.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Colors.grey[800] : Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_off,
                      size: 40,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      homeController.userSearchQuery.value.isNotEmpty
                          ? 'no_approved_users_found_for_search'.tr
                          : 'no_approved_users_found'.tr,
                      style: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

        
          double listHeight = (approvedUsers.length * 70.0).clamp(150.0, 200.0);

          return Container(
            height: listHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isDark ? Colors.grey[800] : Colors.white,
            ),
            child: ListView.builder(
              itemCount: approvedUsers.length,
              itemBuilder: (context, index) {
                final user = approvedUsers[index];
                return Obx(() {
                  final isMember = controller.selectedMembers.contains(user.id);
                  final isRepresentative =
                      controller.selectedRepresentative.value == user.id;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isMember,
                          onChanged: (value) =>
                              controller.toggleMemberSelection(user.id),
                          activeColor: AppColors.primaryColor,
                          checkColor: Colors.white,
                        ),
                        CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.1,
                          ),
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                user.email ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Radio<String>(
                              value: user.id,
                              groupValue:
                                  controller.selectedRepresentative.value,
                              onChanged: isMember
                                  ? (value) {
                                      if (value != null) {
                                        controller.setRepresentative(value);
                                      }
                                    }
                                  : null,
                              activeColor: AppColors.primaryColor,
                            ),
                            Text(
                              'Rep',
                              style: TextStyle(
                                fontSize: 10,
                                color: isMember
                                    ? AppColors.primaryColor
                                    : (isDark
                                          ? Colors.grey[600]
                                          : Colors.grey[400]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildServiceTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    RxBool value,
    bool isDark,
  ) {
    return Obx(
      () => CheckboxListTile(
        title: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
        value: value.value,
        onChanged: (val) => value.value = val ?? false,
        activeColor: AppColors.primaryColor,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Obx(
      () => controller.errorMessage.value.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.createTeamWithMembers(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'create_team'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
