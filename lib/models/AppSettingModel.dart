import 'package:mighty_news_firebase/utils/ModelKeys.dart';

class AppSettingModel {
  bool? disableAd;
  bool? disableLocation;
  bool? disableHeadline;
  bool? disableQuickRead;
  bool? disableStory;

  String? termCondition;
  String? privacyPolicy;
  String? contactInfo;

  List<String>? dashboardWidgetOrder;
  String? flutterWebBuildVersion;

  AppSettingModel({
    this.disableAd,
    this.disableLocation,
    this.disableHeadline,
    this.disableQuickRead,
    this.disableStory,
    this.termCondition,
    this.privacyPolicy,
    this.contactInfo,
    this.dashboardWidgetOrder,
    this.flutterWebBuildVersion,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      disableAd: json[AppSettingKeys.disableAd],
      disableLocation: json[AppSettingKeys.disableLocation],
      disableHeadline: json[AppSettingKeys.disableHeadline],
      disableQuickRead: json[AppSettingKeys.disableQuickRead],
      disableStory: json[AppSettingKeys.disableStory],
      termCondition: json[AppSettingKeys.termCondition],
      privacyPolicy: json[AppSettingKeys.privacyPolicy],
      contactInfo: json[AppSettingKeys.contactInfo],
      flutterWebBuildVersion: json[AppSettingKeys.flutterWebBuildVersion],
      dashboardWidgetOrder: json[AppSettingKeys.dashboardWidgetOrder] != null ? List<String>.from(json[AppSettingKeys.dashboardWidgetOrder]) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AppSettingKeys.disableAd] = this.disableAd;
    data[AppSettingKeys.disableLocation] = this.disableLocation;
    data[AppSettingKeys.disableHeadline] = this.disableHeadline;
    data[AppSettingKeys.disableQuickRead] = this.disableQuickRead;
    data[AppSettingKeys.disableStory] = this.disableStory;
    data[AppSettingKeys.termCondition] = this.termCondition;
    data[AppSettingKeys.privacyPolicy] = this.privacyPolicy;
    data[AppSettingKeys.contactInfo] = this.contactInfo;
    data[AppSettingKeys.dashboardWidgetOrder] = this.dashboardWidgetOrder;
    data[AppSettingKeys.flutterWebBuildVersion] = this.flutterWebBuildVersion;
    return data;
  }
}
