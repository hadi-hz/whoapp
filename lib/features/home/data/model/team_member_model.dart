import '../../domain/entities/team_member_entity.dart';

class TeamMemberModel extends TeamMemberEntity {
  TeamMemberModel({
    required super.teamMemberId,
    required super.teamId,
    required super.userId,
    required super.name,
    required super.lastname,
    required super.email,
    required super.isRepresentative,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      teamMemberId: json['teamMemberId'] ?? '',
      teamId: json['teamId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      isRepresentative: json['isRepresentative'] ?? false,
    );
  }
}