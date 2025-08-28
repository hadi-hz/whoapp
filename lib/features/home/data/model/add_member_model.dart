import 'package:test3/features/home/domain/entities/add_members.dart';

class AddMembersModel {
  final String teamId;
  final List<String> userId;

  AddMembersModel({
    required this.teamId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'userId': userId,
    };
  }

  factory AddMembersModel.fromRequest(AddMembersRequest request) {
    return AddMembersModel(
      teamId: request.teamId,
      userId: request.userId,
    );
  }
}