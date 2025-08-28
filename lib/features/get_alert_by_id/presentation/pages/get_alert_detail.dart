import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import 'package:test3/features/home/domain/usecase/team_start_processing.dart';
import 'package:test3/features/home/presentation/controller/team_start_processing_controller.dart';
import '../../../../core/const/const.dart';

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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchAlertDetail(widget.alertId);
      final prefs = await SharedPreferences.getInstance();
      final String? savedRole = prefs.getString('role');

      print('savedRole : ${savedRole}');
      if (savedRole == 'Admin') {
        await controller.fetchTeamByAlertType(widget.alertType);
        print('controller.team.value : ${controller.teams.value}');
        
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

              if (alert.teamId != null) ...[_buildTeamSection(alertDetail)],

              alert.teamId == null && controller.userRole.value == 'Admin'
                  ? _buildTeamAssignmentButton(alertDetail)
                  : const SizedBox.shrink(),

              const SizedBox(height: 16),
              _buildServiceProviderButton(),
            ],
          ),
        );
      }),
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
            SizedBox(
              width: context.width * 0.28,
              child: Divider(
                color: AppColors.textColor,
                thickness: 4,
                radius: BorderRadius.all(Radius.circular(22)),
              ),
            ),

            const SizedBox(height: 30),

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

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedTeam.value?.id,
                    hint: Text('choose_team'.tr),
                    items: controller.teams.map((team) {
                      return DropdownMenuItem<String>(
                        value: team.id,
                        child: Text(team.name),
                      );
                    }).toList(),
                    onChanged: (String? selectedId) {
                      if (selectedId != null) {
                        final selectedTeam = controller.teams.firstWhere(
                          (team) => team.id == selectedId,
                        );
                        controller.selectedTeam.value = selectedTeam;
                      } else {
                        controller.selectedTeam.value = null;
                      }
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),

            Obx(
              () => ElevatedButton(
                onPressed: controller.selectedTeam.value != null
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String? savedUserId = prefs.getString('userId');

                        await controller.assignTeamToAlert(
                          alertId: widget.alertId,
                          teamId: controller.selectedTeam.value!.id,
                          userId: savedUserId ?? '',
                        );

                        Get.back();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: Text('assign'.tr),
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
            if (alert.locationLabel != null)
              _buildInfoRow('location_label'.tr, alert.locationLabel!),
            if (alert.locationDescription != null)
              _buildInfoRow(
                'location_description'.tr,
                alert.locationDescription!,
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
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
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
              _buildInfoRow('team_name'.tr, alertDetail.team!.name),
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
                  child: Text('• ${member.name} (${member.email})'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Widget _buildServiceProviderButton() {
    if (controller.userRole.value != 'ServiceProvider') {
      return const SizedBox.shrink();
    }

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
      if (controller.userRole.value != 'ServiceProvider') {
        return const SizedBox.shrink();
      }

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
                  } else {
                    Get.snackbar(
                      'error'.tr,
                      'User ID not found',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
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
                    Text('Processing...'),
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
}
