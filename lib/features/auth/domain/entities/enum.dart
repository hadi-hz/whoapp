class EnumItem {
  final int value;
  final String name;

  const EnumItem({
    required this.value,
    required this.name,
  });
}

class EnumsResponse {
  final List<EnumItem> platform;
  final List<EnumItem> deviceType;
  final List<EnumItem> preferredLanguage;
  final List<EnumItem> provider;
  final List<EnumItem> alertType;
  final List<EnumItem> alertStatus;
  final List<EnumItem> alertLogStatusChange;

  const EnumsResponse({
    required this.platform,
    required this.deviceType,
    required this.preferredLanguage,
    required this.provider,
    required this.alertType,
    required this.alertStatus,
    required this.alertLogStatusChange,
  });
}
