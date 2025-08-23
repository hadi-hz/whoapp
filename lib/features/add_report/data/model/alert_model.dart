class AlertModel {
  final String doctorId;
  final String alertDescriptionByDoctor;
  final String? patientName;
  final int alertType;
  final double latitude;
  final double latitudeGps;
  final double longitude;
  final double longitudeGps;
  final bool isOflineMode;
  final String localCreateTime;
  final List<String> files;

  AlertModel({
    required this.doctorId,
    required this.alertDescriptionByDoctor,
    this.patientName,
    required this.alertType,
    required this.latitude,
    required this.longitude,
    required this.latitudeGps,
    required this.longitudeGps,
    required this.isOflineMode,
    required this.localCreateTime,
    this.files = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "doctorid": doctorId,
      "alertDescriptionByDoctor": alertDescriptionByDoctor,
      "patientName": patientName,
      "alertType": alertType,
      "latitude": latitude,
      "longitude": longitude,
      "localCreateTime": localCreateTime,
      "latitudeGPS": latitudeGps,
      "longitudeGPS": longitudeGps,
      'isInOfflineMode': isOflineMode,
      "files": files,
    };
  }
}
