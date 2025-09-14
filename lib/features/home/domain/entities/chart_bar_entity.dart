class BarChartEntity {
  final int total;
  final List<BarChartDoctorEntity> doctors;

  BarChartEntity({
    required this.total,
    required this.doctors,
  });
}

class BarChartDoctorEntity {
  final String doctorId;
  final String doctorName;
  final int count;

  BarChartDoctorEntity({
    required this.doctorId,
    required this.doctorName,
    required this.count,
  });
}