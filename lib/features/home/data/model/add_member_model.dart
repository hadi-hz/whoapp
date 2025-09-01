import 'package:test3/features/home/domain/entities/add_members.dart';

class AddMembersModel {
  final String teamId;
  final List<String> userId;
  final String representativeId;

  AddMembersModel({
    required this.teamId,
    required this.userId,
    required this.representativeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'userId': userId,
      'representativeId': representativeId,
    };
  }

  factory AddMembersModel.fromRequest(AddMembersRequest request) {
    return AddMembersModel(
      teamId: request.teamId,
      userId: request.userId,
      representativeId: request.representativeId,
    );
  }
}