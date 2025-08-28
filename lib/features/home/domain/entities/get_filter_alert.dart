class AlertFilterEntity {
  final String? search;
  final String? userId;
  final int? status;
  final int? type;
  final DateTime? registerDateFrom;
  final DateTime? registerDateTo;
  final String? sortBy;
  final bool? sortDescending;
  final String? teamId;
  final int page;
  final int pageSize;

  AlertFilterEntity({
    this.search,
    this.userId,
    this.status,
    this.type,
    this.registerDateFrom,
    this.registerDateTo,
    this.sortBy,
    this.sortDescending,
    this.teamId,
    this.page = 1,
    this.pageSize = 150,
  });
}