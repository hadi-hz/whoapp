class AddMembersRequest {
  final String teamId;
  final List<String> userId;

  AddMembersRequest({
    required this.teamId,
    required this.userId,
  });
}