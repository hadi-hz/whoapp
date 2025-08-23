import 'package:test3/features/auth/domain/entities/enum.dart';


class EnumItemModel extends EnumItem {
  const EnumItemModel({
    required int value,
    required String name,
  }) : super(value: value, name: name);

  factory EnumItemModel.fromJson(Map<String, dynamic> json) {
    return EnumItemModel(
      value: json['value'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'name': name,
    };
  }
}

class EnumsResponseModel extends EnumsResponse {
  const EnumsResponseModel({
    required List<EnumItemModel> platform,
    required List<EnumItemModel> deviceType,
    required List<EnumItemModel> preferredLanguage,
    required List<EnumItemModel> provider,
    required List<EnumItemModel> alertType,
    required List<EnumItemModel> alertStatus,
    required List<EnumItemModel> alertLogStatusChange,
  }) : super(
          platform: platform,
          deviceType: deviceType,
          preferredLanguage: preferredLanguage,
          provider: provider,
          alertType: alertType,
          alertStatus: alertStatus,
          alertLogStatusChange: alertLogStatusChange,
        );

  factory EnumsResponseModel.fromJson(Map<String, dynamic> json) {
    List<EnumItemModel> _mapList(String key) {
      return (json[key] as List<dynamic>)
          .map((e) => EnumItemModel.fromJson(e))
          .toList();
    }

    return EnumsResponseModel(
      platform: _mapList("platform"),
      deviceType: _mapList("deviceType"),
      preferredLanguage: _mapList("preferredLanguage"),
      provider: _mapList("provider"),
      alertType: _mapList("alertType"),
      alertStatus: _mapList("alertStatus"),
      alertLogStatusChange: _mapList("alertLogStatusChange"),
    );
  }
}
