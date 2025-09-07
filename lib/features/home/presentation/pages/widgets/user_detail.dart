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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent :   AppColors.primaryColor.withOpacity(0.1),
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.primaryColor.withOpacity(0.1),
                    Colors.black,
                  ]
                : [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
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
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUserDetail,
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

          if (controller.userDetail.value == null) {
            return Center(
              child: Text(
                'no_user_data'.tr,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            );
          }

          final user = controller.userDetail.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                _buildProfileSection(user, isDark),

                const SizedBox(height: 24),

                _buildPersonalInfoSection(user, isDark),

                const SizedBox(height: 24),

                _buildAccountStatusSection(user, isDark),

                const SizedBox(height: 24),

                if (user.roles.isNotEmpty) ...[
                  _buildRolesSection(user, isDark),
                  const SizedBox(height: 24),
                ],

                if (!user.isUserApproved) ...[
                  _buildRoleAssignmentSection(user, isDark),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileSection(UserDetailEntity user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
                        return _buildDefaultAvatar(isDark);
                      },
                    )
                  : _buildDefaultAvatar(isDark),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            user.displayName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isDark) {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.1),
      child: Icon(Icons.person, size: 50, color: AppColors.primaryColor),
    );
  }

  Widget _buildPersonalInfoSection(UserDetailEntity user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            'first_name'.tr,
            user.name.isNotEmpty ? user.name : 'not_provided'.tr,
            isDark,
          ),
          _buildInfoRow(
            'last_name'.tr,
            user.lastname.isNotEmpty ? user.lastname : 'not_provided'.tr,
            isDark,
          ),
          _buildInfoRow(
            'preferred_language'.tr,
            user.languageDisplayName,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusSection(UserDetailEntity user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey,
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
                color: user.emailConfirmed
                    ? Colors.blue
                    : (isDark ? Colors.grey[400] : Colors.grey),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'email_verification'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                user.emailConfirmed ? 'verified'.tr : 'not_verified'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: user.emailConfirmed
                      ? Colors.blue
                      : (isDark ? Colors.grey[400] : Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSection(UserDetailEntity user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
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
                  roleColor = isDark ? Colors.purple[300]! : Colors.purple;
                  roleIcon = Icons.admin_panel_settings;
                  break;
                case 'Doctor':
                  roleColor = isDark ? Colors.blue[300]! : Colors.blue;
                  roleIcon = Icons.local_hospital;
                  break;
                case 'ServiceProvider':
                  roleColor = isDark ? Colors.orange[300]! : Colors.orange;
                  roleIcon = Icons.build;
                  break;
                default:
                  roleColor = isDark ? Colors.grey[400]! : Colors.grey;
                  roleIcon = Icons.person;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(isDark ? 0.2 : 0.1),
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

  Widget _buildRoleAssignmentSection(UserDetailEntity user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'select_role_for_user'.tr,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              border: Border.all(
                color: isDark ? Colors.grey[600]! : AppColors.borderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedRole.value.isEmpty
                      ? null
                      : controller.selectedRole.value,
                  hint: Text(
                    'choose_role'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                  items: controller.availableRoles.map((role) {
                    IconData roleIcon;
                    Color roleColor;

                    switch (role) {
                      case 'Admin':
                        roleIcon = Icons.admin_panel_settings;
                        roleColor = isDark
                            ? Colors.purple[300]!
                            : Colors.purple;
                        break;
                      case 'Doctor':
                        roleIcon = Icons.local_hospital;
                        roleColor = isDark ? Colors.blue[300]! : Colors.blue;
                        break;
                      case 'ServiceProvider':
                        roleIcon = Icons.build;
                        roleColor = isDark
                            ? Colors.orange[300]!
                            : Colors.orange;
                        break;
                      default:
                        roleIcon = Icons.person;
                        roleColor = isDark ? Colors.grey[400]! : Colors.grey;
                    }

                    return DropdownMenuItem<String>(
                      value: role,
                      child: Row(
                        children: [
                          Icon(roleIcon, color: roleColor, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            role,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
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
                  disabledBackgroundColor: isDark
                      ? Colors.grey[700]
                      : Colors.grey[300],
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
              color: isDark
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: isDark ? Colors.blue[300] : Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'role_assignment_info'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.blue[300] : Colors.blue,
                    ),
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

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
