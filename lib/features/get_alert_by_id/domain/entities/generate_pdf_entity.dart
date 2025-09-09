class ReportResponse {
  final List<int> data;
  final String filename;
  final String contentType;

  ReportResponse({
    required this.data,
    required this.filename,
    required this.contentType,
  });
}
