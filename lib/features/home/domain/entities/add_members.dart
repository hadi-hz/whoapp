class AddMembersRequest {
  final String teamId;
  final List<String> userId;
  final String representativeId;

  AddMembersRequest({
    required this.teamId,
    required this.userId,
    required this.representativeId,
  });
}