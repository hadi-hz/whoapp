class ApprovedRequest {
  String userId;

  ApprovedRequest({required this.userId});

  Map<String, dynamic> toJson() => {"userId": userId};
}
