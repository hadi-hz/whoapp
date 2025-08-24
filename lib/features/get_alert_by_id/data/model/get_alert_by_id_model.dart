

import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';

class AlertDetailModel extends AlertDetailEntity {
  const AlertDetailModel({
    required super.alert,
    required super.doctor,
    super.team,
    required super.teamMembers,
    required super.logs,
    required super.doctorFiles,
    required super.teamFiles,
  });

  factory AlertDetailModel.fromJson(Map<String, dynamic> json) {
    return AlertDetailModel(
      alert: AlertModel.fromJson(json['alert'] ?? {}),
      doctor: DoctorModel.fromJson(json['doctor'] ?? {}),
      team: json['team'] != null ? TeamModel.fromJson(json['team']) : null,
      teamMembers: (json['teamMembers'] as List<dynamic>? ?? [])
          .map((e) => TeamMemberModel.fromJson(e))
          .toList(),
      logs: (json['logs'] as List<dynamic>? ?? [])
          .map((e) => LogModel.fromJson(e))
          .toList(),
      doctorFiles: List<String>.from(json['doctorFiles'] ?? []),
      teamFiles: List<String>.from(json['teamFiles'] ?? []),
    );
  }
}

class AlertModel extends AlertEntity {
  const AlertModel({
    required super.doctorId,
    required super.doctor,
    super.teamId,
    super.team,
    required super.patientName,
    required super.alertDescriptionByDoctor,
    required super.alertDescriptionByAdmin,
    required super.alertDescriptionByServiceProvider,
    required super.localCreateTime,
    required super.serverCreateTime,
    required super.lastUpdateTime,
    super.visitedByAdminTime,
    super.visitedByServiceProviderTime,
    required super.latitudeGPS,
    required super.longitudeGPS,
    required super.latitude,
    required super.longitude,
    super.locationLabel,
    super.locationDescription,
    required super.alertType,
    required super.alertStatus,
    required super.trackId,
    required super.id,
    required super.isDelete,
    required super.createTime,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      doctorId: json['doctorId'] ?? '',
      doctor: DoctorDetailModel.fromJson(json['doctor'] ?? {}),
      teamId: json['teamId'],
      team: json['team'] != null ? TeamDetailModel.fromJson(json['team']) : null,
      patientName: json['patientName'] ?? '',
      alertDescriptionByDoctor: json['alertDescriptionByDoctor'] ?? '',
      alertDescriptionByAdmin: json['alertDescriptionByAdmin'] ?? '',
      alertDescriptionByServiceProvider: json['alertDescriptionByServiceProvider'] ?? '',
      localCreateTime: json['localCreateTime'] ?? '',
      serverCreateTime: json['serverCreateTime'] ?? '',
      lastUpdateTime: json['lastUpdateTime'] ?? '',
      visitedByAdminTime: json['visitedByAdminTime'],
      visitedByServiceProviderTime: json['visitedByServiceProviderTime'],
      latitudeGPS: (json['latitudeGPS'] ?? 0).toDouble(),
      longitudeGPS: (json['longitudeGPS'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationLabel: json['locationLabel'],
      locationDescription: json['locationDescription'],
      alertType: json['alertType'] ?? 0,
      alertStatus: json['alertStatus'] ?? 0,
      trackId: json['trackId'] ?? '',
      id: json['id'] ?? '',
      isDelete: json['isDelete'] ?? false,
      createTime: json['createTime'] ?? '',
    );
  }
}

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.lastname,
    required super.email,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class DoctorDetailModel extends DoctorDetailEntity {
  const DoctorDetailModel({
    required super.name,
    required super.lastname,
    required super.registerDate,
    required super.approvedTime,
    required super.isUserApproved,
    required super.preferredLanguage,
    required super.deviceTokenId,
    super.teamMemberships,
    required super.provider,
    super.googleId,
    required super.id,
    required super.userName,
    required super.normalizedUserName,
    required super.email,
    required super.normalizedEmail,
    required super.emailConfirmed,
    required super.passwordHash,
    required super.securityStamp,
    required super.concurrencyStamp,
    super.phoneNumber,
    required super.phoneNumberConfirmed,
    required super.twoFactorEnabled,
    super.lockoutEnd,
    required super.lockoutEnabled,
    required super.accessFailedCount,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      registerDate: json['registerDate'] ?? '',
      approvedTime: json['approvedTime'] ?? '',
      isUserApproved: json['isUserApproved'] ?? false,
      preferredLanguage: json['preferredLanguage'] ?? 0,
      deviceTokenId: json['deviceTokenId'] ?? '',
      teamMemberships: json['teamMemberships'],
      provider: json['provider'] ?? 0,
      googleId: json['googleId'],
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      normalizedUserName: json['normalizedUserName'] ?? '',
      email: json['email'] ?? '',
      normalizedEmail: json['normalizedEmail'] ?? '',
      emailConfirmed: json['emailConfirmed'] ?? false,
      passwordHash: json['passwordHash'] ?? '',
      securityStamp: json['securityStamp'] ?? '',
      concurrencyStamp: json['concurrencyStamp'] ?? '',
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'] ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      lockoutEnd: json['lockoutEnd'],
      lockoutEnabled: json['lockoutEnabled'] ?? false,
      accessFailedCount: json['accessFailedCount'] ?? 0,
    );
  }
}

class TeamModel extends TeamEntity {
  const TeamModel({
    required super.id,
    required super.name,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TeamDetailModel extends TeamDetailEntity {
  const TeamDetailModel();

  factory TeamDetailModel.fromJson(Map<String, dynamic> json) {
    return const TeamDetailModel();
  }
}

class TeamMemberModel extends TeamMemberEntity {
  const TeamMemberModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class LogModel extends LogEntity {
  const LogModel({
    required super.status,
    required super.dateTime,
    required super.user,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      status: json['status'] ?? 0,
      dateTime: json['dateTime'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.lastname,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
    );
  }
}