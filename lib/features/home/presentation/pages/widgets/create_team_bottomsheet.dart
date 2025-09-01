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
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  _buildServicesSection(),
                  const SizedBox(height: 20),
                  _buildMembersSection(),
                  const SizedBox(height: 20),
                  _buildErrorMessage(),
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      decoration: InputDecoration(
        labelText: 'team_name'.tr,
        hintText: 'enter_team_name'.tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.group),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: controller.descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'description'.tr,
        hintText: 'enter_description'.tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'team_services'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildServiceTile(
          'healthcare_cleaning'.tr,
          Icons.local_hospital,
          Colors.blue,
          controller.isHealthcare,
        ),
        _buildServiceTile(
          'household_cleaning'.tr,
          Icons.home,
          Colors.green,
          controller.isHousehold,
        ),
        _buildServiceTile(
          'patient_referral'.tr,
          Icons.person_search,
          Colors.orange,
          controller.isReferral,
        ),
        _buildServiceTile(
          'burial_services'.tr,
          Icons.psychology,
          Colors.purple,
          controller.isBurial,
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    final TextEditingController searchController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'select_members'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: searchController,
            onChanged: (value) => homeController.setUserSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'search_users'.tr,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Obx(
                () => homeController.userSearchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
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
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.person_off, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      homeController.userSearchQuery.value.isNotEmpty
                          ? 'no_approved_users_found_for_search'.tr
                          : 'no_approved_users_found'.tr,
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
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
                              Text(user.fullName),
                              Text(
                                user.email ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
                                    : Colors.grey,
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
    String title,
    IconData icon,
    Color color,
    RxBool value,
  ) {
    return Obx(
      () => CheckboxListTile(
        title: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        value: value.value,
        onChanged: (val) => value.value = val ?? false,
        activeColor: AppColors.primaryColor,
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

  Widget _buildCreateButton() {
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
