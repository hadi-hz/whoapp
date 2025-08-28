import '../../domain/entities/assign_role_entity.dart';

class AssignRoleModel extends AssignRoleEntity {
  AssignRoleModel({required String message}) : super(message: message);

  factory AssignRoleModel.fromJson(Map<String, dynamic> json) {
    return AssignRoleModel(message: json['message'] ?? '');
  }
}