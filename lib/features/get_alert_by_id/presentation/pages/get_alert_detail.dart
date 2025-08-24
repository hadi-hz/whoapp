import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/presentation/controller/get_alert_by_id_controller.dart';
import '../../../../core/const/const.dart';

class AlertDetailPage extends StatefulWidget {
  final String alertId;

  const AlertDetailPage({super.key, required this.alertId});

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


              if (alertDetail.team != null ||
                  alertDetail.teamMembers.isNotEmpty) ...[
                _buildTeamSection(alertDetail),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(alert) {
    return Card(
      elevation: 4,

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
              '${'track_id'.tr}: ${alert.trackId}', // Add track_id to translations
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertInfoCard(alert) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'alert_information'.tr, // Add this to translations
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'doctor_information'.tr, // Add this to translations
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('name'.tr, '${doctor.name} ${doctor.lastname}'),
            _buildInfoRow('email'.tr, doctor.email),
            // _buildInfoRow('register_date'.tr, _formatDateTime(doctor.registerDate)),
            // _buildInfoRow('approved_date'.tr, _formatDateTime(doctor.approvedTime)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(alert) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'location_information'.tr, // Add this to translations
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'attached_images'.tr, // Add this to translations
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'team_information'.tr, // Add this to translations
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
                'team_members'.tr, // Add this to translations
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
}
