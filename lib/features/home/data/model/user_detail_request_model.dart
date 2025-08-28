class UserDetailRequest {
  final String userId;
  final String currentUserId;

  UserDetailRequest({
    required this.userId,
    required this.currentUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentUserId': currentUserId,
    };
  }
}