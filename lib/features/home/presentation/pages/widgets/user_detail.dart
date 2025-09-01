import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/user_detail_entity.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final HomeController controller = Get.find<HomeController>();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
  }

  Future<void> _loadUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId');

    if (currentUserId != null) {
      await controller.fetchUserDetail(
        userId: widget.userId,
        currentUserId: currentUserId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUserDetail,
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          if (controller.userDetail.value == null) {
            return Center(child: Text('no_user_data'.tr));
          }

          final user = controller.userDetail.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                _buildProfileSection(user),

                const SizedBox(height: 24),

                _buildPersonalInfoSection(user),

                const SizedBox(height: 24),

                _buildAccountStatusSection(user),

                const SizedBox(height: 24),

                if (user.roles.isNotEmpty) ...[
                  _buildRolesSection(user),
                  const SizedBox(height: 24),
                ],

                if (!user.isUserApproved) ...[
                  _buildRoleAssignmentSection(user),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileSection(UserDetailEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 3),
            ),
            child: ClipOval(
              child: user.hasProfileImage
                  ? Image.network(
                      user.profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : _buildDefaultAvatar(),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            user.displayName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.1),
      child: Icon(Icons.person, size: 50, color: AppColors.primaryColor),
    );
  }

  Widget _buildPersonalInfoSection(UserDetailEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'personal_information'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            'first_name'.tr,
            user.name.isNotEmpty ? user.name : 'not_provided'.tr,
          ),
          _buildInfoRow(
            'last_name'.tr,
            user.lastname.isNotEmpty ? user.lastname : 'not_provided'.tr,
          ),
     
          _buildInfoRow('preferred_language'.tr, user.languageDisplayName),
        ],
      ),
    );
  }

  Widget _buildAccountStatusSection(UserDetailEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'account_status'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(
                user.isUserApproved ? Icons.check_circle : Icons.pending,
                color: user.isUserApproved ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'approval_status'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: user.isUserApproved
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: user.isUserApproved ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  user.isUserApproved ? 'approved'.tr : 'pending'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: user.isUserApproved ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                user.emailConfirmed ? Icons.verified : Icons.email,
                color: user.emailConfirmed ? Colors.blue : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'email_verification'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                user.emailConfirmed ? 'verified'.tr : 'not_verified'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: user.emailConfirmed ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSection(UserDetailEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'user_roles'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.roles.map((role) {
              Color roleColor;
              IconData roleIcon;

              switch (role) {
                case 'Admin':
                  roleColor = Colors.purple;
                  roleIcon = Icons.admin_panel_settings;
                  break;
                case 'Doctor':
                  roleColor = Colors.blue;
                  roleIcon = Icons.local_hospital;
                  break;
                case 'ServiceProvider':
                  roleColor = Colors.orange;
                  roleIcon = Icons.build;
                  break;
                default:
                  roleColor = Colors.grey;
                  roleIcon = Icons.person;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: roleColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(roleIcon, color: roleColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: roleColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleAssignmentSection(UserDetailEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'assign_role'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'select_role_for_user'.tr,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedRole.value.isEmpty
                      ? null
                      : controller.selectedRole.value,
                  hint: Text('choose_role'.tr),
                  items: controller.availableRoles.map((role) {
                    IconData roleIcon;
                    Color roleColor;

                    switch (role) {
                      case 'Admin':
                        roleIcon = Icons.admin_panel_settings;
                        roleColor = Colors.purple;
                        break;
                      case 'Doctor':
                        roleIcon = Icons.local_hospital;
                        roleColor = Colors.blue;
                        break;
                      case 'ServiceProvider':
                        roleIcon = Icons.build;
                        roleColor = Colors.orange;
                        break;
                      default:
                        roleIcon = Icons.person;
                        roleColor = Colors.grey;
                    }

                    return DropdownMenuItem<String>(
                      value: role,
                      child: Row(
                        children: [
                          Icon(roleIcon, color: roleColor, size: 20),
                          const SizedBox(width: 12),
                          Text(role),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.setSelectedRole(value);
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed:
                    controller.selectedRole.value.isNotEmpty &&
                        !controller.isAssigningRole.value
                    ? () => _assignRole(user)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isAssigningRole.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('assigning_role'),
                        ],
                      )
                    : Text('assign_role'.tr),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'role_assignment_info'.tr,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Future<void> _assignRole(UserDetailEntity user) async {
  final success = await controller.assignRoleToUser(
    userId: user.id,
    roleName: controller.selectedRole.value,
  
  );

  if (success) {
    controller.clearSelectedRole();
  }
}

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
