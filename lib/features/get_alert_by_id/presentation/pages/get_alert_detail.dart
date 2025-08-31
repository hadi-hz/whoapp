import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/team_finish_processing.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/update_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/update_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/visited_by_admin_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/visited_by_team_member_usecase.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/team_finish_processing_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/update_by_admin_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/update_by_team_member-controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/visited_by_admin_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/visited_team_member_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/map_get_location.dart';
import 'package:test3/features/home/domain/usecase/team_start_processing.dart';
import 'package:test3/features/home/presentation/controller/team_start_processing_controller.dart';
import '../../../../core/const/const.dart';
import 'dart:io';

class AlertDetailPage extends StatefulWidget {
  final String alertId;
  final int alertType;

  const AlertDetailPage({
    super.key,
    required this.alertId,
    required this.alertType,
  });

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  final AlertDetailController controller = Get.find<AlertDetailController>();

  Future<bool> _isUserTeamRepresentative() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentUserId = prefs.getString('userId');

    if (currentUserId == null || controller.alertDetail.value == null) {
      return false;
    }

    final teamMembers = controller.alertDetail.value!.teamMembers;

    for (final member in teamMembers) {
      if (member.userId == currentUserId && member.isRepresentative) {
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchAlertDetail(widget.alertId);
      final prefs = await SharedPreferences.getInstance();
      final String? savedRole = prefs.getString('role');
      final String? savedUserId = prefs.getString('userId');

      if (savedRole == 'Admin') {
        await controller.fetchTeamByAlertType(widget.alertType);

        final alertDetail = controller.alertDetail.value;
        final currentStatus = alertDetail?.alert.visitedByAdminTime;

        if (currentStatus == null && savedUserId != null) {
          final visitedController = Get.put(
            VisitedByAdminController(Get.find<VisitedByAdminUseCase>()),
          );

          await visitedController.markAsVisitedByAdmin(
            alertId: widget.alertId,
            userId: savedUserId,
          );

          await controller.fetchAlertDetail(widget.alertId);
        }
      } else if (savedRole == 'ServiceProvider') {
        final alertDetail = controller.alertDetail.value;

        if (savedUserId != null) {
          final visitedTeamController = Get.put(
            VisitedByTeamMemberController(
              Get.find<VisitedByTeamMemberUseCase>(),
            ),
          );

          await visitedTeamController.markAsVisitedByTeamMember(
            alertId: widget.alertId,
            userId: savedUserId,
          );

          await controller.fetchAlertDetail(widget.alertId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
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
                  onPressed: () => controller.fetchAlertDetail(widget.alertId),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.alertDetail.value == null) {
          return Center(child: Text('no_data_found'.tr));
        }

        final alertDetail = controller.alertDetail.value!;
        final alert = alertDetail.alert;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(alert),
              ConstantSpace.mediumVerticalSpacer,
              _buildAlertInfoCard(alert),
              ConstantSpace.mediumVerticalSpacer,
              _buildDoctorInfoCard(alertDetail.doctor),
              ConstantSpace.mediumVerticalSpacer,
              _buildLocationCard(alert),
              ConstantSpace.mediumVerticalSpacer,
              if (alertDetail.doctorFiles.isNotEmpty) ...[
                _buildImagesSection(alertDetail.doctorFiles),
                ConstantSpace.mediumVerticalSpacer,
              ],
              if (alert.teamId != null) ...[
                _buildTeamSection(alertDetail),
                ConstantSpace.mediumVerticalSpacer,
              ],
              alert.teamId == null && controller.userRole.value == 'Admin'
                  ? _buildTeamAssignmentButton(alertDetail)
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),
              _buildServiceProviderButton(),
              const SizedBox(height: 16),
              controller.userRole.value == 'Admin'
                  ? _buildAdminDescriptionSection()
                  : SizedBox(),
              const SizedBox(height: 16),
              _buildTeamMemberDescriptionSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTeamMemberDescriptionSection() {
    if (controller.userRole.value != 'ServiceProvider') {
      return const SizedBox.shrink();
    }

    final alert = controller.alertDetail.value?.alert;
    final isStarted = alert?.startTimeByTeam != null;

    return FutureBuilder<bool>(
      future: _isUserTeamRepresentative(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data! || !isStarted) {
          return const SizedBox.shrink();
        }

        final TeamFinishProcessingController finishController = Get.put(
          TeamFinishProcessingController(
            Get.find<TeamFinishProcessingUseCase>(),
          ),
        );

        return Obx(
          () => Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.borderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'team_member_update'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description Field
                  TextFormField(
                    controller: finishController.descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'enter_team_member_notes'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text(
                        'attached_images'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => finishController.pickImages(),
                        icon: const Icon(Icons.add_photo_alternate, size: 18),
                        label: Text('add_images'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.1,
                          ),
                          foregroundColor: AppColors.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (finishController.selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: finishController.selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = finishController.selectedImages[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(image, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () =>
                                        finishController.removeImage(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  if (finishController.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      finishController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: finishController.isFinishingProcess.value
                          ? null
                          : () async {
                              if (!finishController.validateForm()) return;

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final userId = prefs.getString('userId');

                              if (userId != null) {
                                final success = await finishController
                                    .teamFinishProcessing(
                                      alertId: widget.alertId,
                                      userId: userId,
                                    );

                                if (success) {
                                  await controller.fetchAlertDetail(
                                    widget.alertId,
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: finishController.isFinishingProcess.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'end_processing'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminDescriptionSection() {
    if (controller.userRole.value != 'Admin') {
      return const SizedBox.shrink();
    }

    final UpdateAlertByAdminController updateController = Get.put(
      UpdateAlertByAdminController(Get.find<UpdateAlertByAdminUseCase>()),
    );

    return Obx(
      () => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'admin_notes'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: updateController.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'enter_admin_notes'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (updateController.errorMessage.value.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  updateController.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateController.isUpdating.value
                      ? null
                      : () async {
                          if (updateController.descriptionController.text
                              .trim()
                              .isEmpty) {
                            updateController.errorMessage.value =
                                'description_required'.tr;
                            return;
                          }
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getString('userId');
                          if (userId != null) {
                            final success = await updateController
                                .updateAlertByAdmin(
                                  alertId: widget.alertId,
                                  description: updateController
                                      .descriptionController
                                      .text
                                      .trim(),
                                  userId: userId,
                                );
                            if (success) {
                              await controller.fetchAlertDetail(widget.alertId);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: updateController.isUpdating.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'update_description'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamAssignmentButton(alertDetail) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'select_team'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoadingTeam.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessageTeam.value.isNotEmpty) {
                return Text(
                  controller.errorMessageTeam.value,
                  style: const TextStyle(color: Colors.red),
                );
              }
              if (controller.teams.isEmpty) {
                return Text('no_teams_available'.tr);
              }
              return DropdownSearch<TeamsEntity>(
                items: controller.teams,
                selectedItem: controller.selectedTeam.value,
                itemAsString: (team) => team.name,
                onChanged: (team) => controller.selectedTeam.value = team,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'search_teams'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: 'choose_team'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed:
                    !controller.isAssigning.value &&
                        controller.selectedTeam.value != null
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String? savedUserId = prefs.getString('userId');
                        await controller.assignTeamToAlert(
                          alertId: widget.alertId,
                          teamId: controller.selectedTeam.value!.id,
                          userId: savedUserId ?? '',
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: controller.isAssigning.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.background,
                        ),
                      )
                    : Text('assign'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(alert) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'alert_status'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: controller
                    .getStatusColor(alert.alertStatus)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.getStatusColor(alert.alertStatus),
                  width: 1,
                ),
              ),
              child: Text(
                controller.getStatusName(alert.alertStatus),
                style: TextStyle(
                  color: controller.getStatusColor(alert.alertStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${'track_id'.tr}: ${alert.trackId}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertInfoCard(alert) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'alert_information'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('patient_name'.tr, alert.patientName),
            _buildInfoRow(
              'alert_type'.tr,
              controller.getAlertTypeName(alert.alertType),
            ),
            _buildInfoRow('description'.tr, alert.alertDescriptionByDoctor),
            if (alert.alertDescriptionByAdmin.isNotEmpty)
              _buildInfoRow(
                'description_Admin'.tr,
                alert.alertDescriptionByAdmin,
              ),
            if (alert.alertDescriptionByServiceProvider.isNotEmpty)
              _buildInfoRow(
                'description_ServiceProvider'.tr,
                alert.alertDescriptionByServiceProvider,
              ),
            _buildInfoRow(
              'created_date'.tr,
              _formatDateTime(alert.serverCreateTime),
            ),
            _buildInfoRow(
              'last_update'.tr,
              _formatDateTime(alert.lastUpdateTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard(doctor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'doctor_information'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('name'.tr, '${doctor.name} ${doctor.lastname}'),
            _buildInfoRow('email'.tr, doctor.email),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(alert) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'location_information'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'selected_location'.tr,
              '${alert.latitude}, ${alert.longitude}',
            ),
            _buildInfoRow(
              'gps_location'.tr,
              '${alert.latitudeGPS}, ${alert.longitudeGPS}',
            ),
            if (alert.locationLabel != null && alert.locationLabel!.isNotEmpty)
              _buildInfoRow('location_label'.tr, alert.locationLabel!),
            if (alert.locationDescription != null &&
                alert.locationDescription!.isNotEmpty)
              _buildInfoRow(
                'location_description'.tr,
                alert.locationDescription!,
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              icon: Icon(Icons.map, color: AppColors.background),
              label: Text(
                'open_map_direction'.tr,
                style: TextStyle(color: AppColors.background),
              ),
              onPressed: () {
                final destination = LatLng(alert.latitude, alert.longitude);
                controller.openDirections(destination);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection(List<String> images) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'attached_images'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _showImageDialog(images[index]),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(alertDetail) {
    final teamName =
        alertDetail.team?.teamName ?? alertDetail.alert?.team?.name ?? '';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'team_information'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (alertDetail.team != null) ...[
              _buildInfoRow('team_name'.tr, teamName),
              if (alertDetail.team!.teamDescription != null &&
                  alertDetail.team!.teamDescription!.isNotEmpty)
                _buildInfoRow(
                  'description'.tr,
                  alertDetail.team!.teamDescription!,
                ),
            ] else ...[
              Text(
                'no_team'.tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (alertDetail.teamMembers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'team_members'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...alertDetail.teamMembers.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${member.name} ${member.lastname} (${member.email})',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceProviderButton() {
    if (controller.userRole.value != 'ServiceProvider') {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: _isUserTeamRepresentative(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return const SizedBox.shrink();
        }

        final alert = controller.alertDetail.value!.alert;
        final isStarted = alert.startTimeByTeam != null;

        if (isStarted || alert.alertStatus == 5 || alert.alertStatus == 6) {
          return const SizedBox.shrink(); 
        } else {
          TeamStartProcessingController startProcessController;
          try {
            startProcessController = Get.find<TeamStartProcessingController>();
          } catch (e) {
            Get.lazyPut<TeamStartProcessingController>(
              () => TeamStartProcessingController(
                Get.find<TeamStartProcessingUseCase>(),
              ),
            );
            startProcessController = Get.find<TeamStartProcessingController>();
          }

          return Obx(() {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: startProcessController.isStartingProcess.value
                    ? null
                    : () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String? savedUserId = prefs.getString('userId');

                        if (savedUserId != null) {
                          final success = await startProcessController
                              .teamStartProcessing(
                                alertId: widget.alertId,
                                userId: savedUserId,
                              );

                          if (success) {
                            await controller.fetchAlertDetail(widget.alertId);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: startProcessController.isStartingProcess.value
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
                          Text('Starting...'),
                        ],
                      )
                    : Text(
                        'start_processing'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          });
        }
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  void _showImageDialog(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
