
import 'package:test3/features/home/domain/entities/chart_bar_entity.dart';

class BarChartModel extends BarChartEntity {
  BarChartModel({
    required int total,
    required List<BarChartDoctorModel> doctors,
  }) : super(
    total: total,
    doctors: doctors,
  );

  factory BarChartModel.fromJson(Map<String, dynamic> json) {
    return BarChartModel(
      total: json['total'] ?? 0,
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((doctor) => BarChartDoctorModel.fromJson(doctor))
          .toList() ?? [],
    );
  }
}

class BarChartDoctorModel extends BarChartDoctorEntity {
  BarChartDoctorModel({
    required String doctorId,
    required String doctorName,
    required int count,
  }) : super(
    doctorId: doctorId,
    doctorName: doctorName,
    count: count,
  );

  factory BarChartDoctorModel.fromJson(Map<String, dynamic> json) {
    return BarChartDoctorModel(
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}