class GetAlertRequestModel {
  final String userId;
  final String? status;
  final String? type;
  final DateTime? registerDateFrom;
  final DateTime? registerDateTo;
  final String? sortBy;
  final bool sortDescending;
  final int page;
  final int pageSize;

  GetAlertRequestModel({
    required this.userId,
    this.status,
    this.type,
    this.registerDateFrom,
    this.registerDateTo,
    this.sortBy,
    this.sortDescending = true,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
      'type': type,
      'registerDateFrom': registerDateFrom?.toIso8601String(),
      'registerDateTo': registerDateTo?.toIso8601String(),
      'sortBy': sortBy,
      'sortDescending': sortDescending,
      'page': page,
      'pageSize': pageSize,
    };
  }
}
