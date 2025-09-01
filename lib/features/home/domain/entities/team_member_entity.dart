class TeamMemberEntity {
  final String teamMemberId;
  final String teamId;
  final String userId;
  final String name;
  final String lastname;
  final String email;
  final bool isRepresentative;

  TeamMemberEntity({
    required this.teamMemberId,
    required this.teamId,
    required this.userId,
    required this.name,
    required this.lastname,
    required this.email,
    required this.isRepresentative,
  });
}