class AlertModel {
  final String doctorId;
  final String alertDescriptionByDoctor;
  final int alertType;
  final double latitude;
  final double longitude;
  final String localCreateTime;
  final List<String> files;

  AlertModel({
    required this.doctorId,
    required this.alertDescriptionByDoctor,
    required this.alertType,
    required this.latitude,
    required this.longitude,
    required this.localCreateTime,
    this.files = const []
  });

  Map<String, dynamic> toJson() {
    return {
      "doctorid": doctorId,
      "alertDescriptionByDoctor": alertDescriptionByDoctor,
      "alertType": alertType,
      "latitude": latitude,
      "longitude": longitude,
      "localCreateTime": localCreateTime,
      "files": files,
    };
  }
}
