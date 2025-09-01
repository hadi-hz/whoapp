class ApiEndpoints {
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String checkUserIsApproved = "/auth/check-user-is-approved";
  static const String alertCreate = "/alert/create";
  static const String getAllAlert = "/alert/get-all";
  static const String loginWithGoogle = "/auth/login-by-google";
  static const String changepassword = "/auth/change-password";
  static const String getUserInfo = "/user/get-user-info";
  static const String updateProfile = "/user/update-profile";
  static const String enums = "/general/get-all-enums";
  static const String geAlertById = '/alert/get-by-id';
  static const String getallTeams = '/teams/getall-by-alerttype';
  static const String assignTeamToAlert = '/alert/assign-team-to-alert';
  static const String userGetAll = '/user/getall';
  static const String assignRole = '/auth/assign-role';
  static const String teamsGetAll = '/teams/getall';
  static const String teamsGetbyId = '/teams/getbyId';
  static const String addMembers = '/teammember/add-members';
  static const String teamsCreate = '/teams/create';
  static const String teamsByMemberId = '/teams/get-teams-by-memberId';
  static const String teamStartProcessing = '/alert/team-start-processing';
  static const String changeLanguage = '/user/change-preferred-language';
  static const String alertUpdateAdmin = '/alert/alert-update-by-admin';
  static const String alertUpdateteammember =
      '/alert/alert-update-by-teammember';
  static const String visitedAdmin = '/alert/visited-by-admin';
  static const String visitedTeamMember = '/alert/visited-by-team-member';
  static const String teamFinishProcessing = '/alert/team-finish-processing';
  static const String adminCloseAlert = '/alert/admin-close-alert';
}
