
class AlertDetailEntity {
  final AlertEntity alert;
  final DoctorEntity doctor;
  final TeamEntity? team;
  final List<TeamMemberEntity> teamMembers;
  final List<LogEntity> logs;
  final List<String> doctorFiles;
  final List<String> teamFiles;

  const AlertDetailEntity({
    required this.alert,
    required this.doctor,
    this.team,
    required this.teamMembers,
    required this.logs,
    required this.doctorFiles,
    required this.teamFiles,
  });
}

class AlertEntity {
  final String doctorId;
  final DoctorDetailEntity doctor;
  final String? teamId;
  final TeamDetailEntity? team;
  final String patientName;
  final String alertDescriptionByDoctor;
  final String alertDescriptionByAdmin;
  final String alertDescriptionByServiceProvider;
  final String localCreateTime;
  final String serverCreateTime;
  final String lastUpdateTime;
  final String? visitedByAdminTime;
  final String? visitedByServiceProviderTime;
  final double latitudeGPS;
  final double longitudeGPS;
  final double latitude;
  final double longitude;
  final String? locationLabel;
  final String? locationDescription;
  final int alertType;
  final int alertStatus;
  final String trackId;
  final String id;
  final bool isDelete;
  final String createTime;

  const AlertEntity({
    required this.doctorId,
    required this.doctor,
    this.teamId,
    this.team,
    required this.patientName,
    required this.alertDescriptionByDoctor,
    required this.alertDescriptionByAdmin,
    required this.alertDescriptionByServiceProvider,
    required this.localCreateTime,
    required this.serverCreateTime,
    required this.lastUpdateTime,
    this.visitedByAdminTime,
    this.visitedByServiceProviderTime,
    required this.latitudeGPS,
    required this.longitudeGPS,
    required this.latitude,
    required this.longitude,
    this.locationLabel,
    this.locationDescription,
    required this.alertType,
    required this.alertStatus,
    required this.trackId,
    required this.id,
    required this.isDelete,
    required this.createTime,
  });
}

class DoctorEntity {
  final String id;
  final String name;
  final String lastname;
  final String email;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
  });
}

class DoctorDetailEntity {
  final String name;
  final String lastname;
  final String registerDate;
  final String approvedTime;
  final bool isUserApproved;
  final int preferredLanguage;
  final String deviceTokenId;
  final dynamic teamMemberships;
  final int provider;
  final String? googleId;
  final String id;
  final String userName;
  final String normalizedUserName;
  final String email;
  final String normalizedEmail;
  final bool emailConfirmed;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final String? phoneNumber;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final String? lockoutEnd;
  final bool lockoutEnabled;
  final int accessFailedCount;

  const DoctorDetailEntity({
    required this.name,
    required this.lastname,
    required this.registerDate,
    required this.approvedTime,
    required this.isUserApproved,
    required this.preferredLanguage,
    required this.deviceTokenId,
    this.teamMemberships,
    required this.provider,
    this.googleId,
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.normalizedEmail,
    required this.emailConfirmed,
    required this.passwordHash,
    required this.securityStamp,
    required this.concurrencyStamp,
    this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    this.lockoutEnd,
    required this.lockoutEnabled,
    required this.accessFailedCount,
  });
}

class TeamEntity {
  final String id;
  final String name;

  const TeamEntity({
    required this.id,
    required this.name,
  });
}

class TeamDetailEntity {
 
  const TeamDetailEntity();
}

class TeamMemberEntity {
  final String id;
  final String name;
  final String email;

  const TeamMemberEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

class LogEntity {
  final int status;
  final String dateTime;
  final UserEntity user;

  const LogEntity({
    required this.status,
    required this.dateTime,
    required this.user,
  });
}

class UserEntity {
  final String id;
  final String name;
  final String lastname;
  final String email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
  });
}