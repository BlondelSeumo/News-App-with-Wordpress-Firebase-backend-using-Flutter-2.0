import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? image;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool? isNotificationOn;
  int? themeIndex;
  String? appLanguage;
  String? oneSignalPlayerId;

  List<String>? bookmarks;

  bool? isAdmin;
  bool? isTester;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.isNotificationOn,
    this.themeIndex,
    this.appLanguage,
    this.oneSignalPlayerId,
    this.bookmarks,
    this.isAdmin,
    this.isTester,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[CommonKeys.id],
      name: json[UserKeys.name],
      email: json[UserKeys.email],
      image: json[UserKeys.image],
      loginType: json[UserKeys.loginType],
      isNotificationOn: json[UserKeys.isNotificationOn],
      themeIndex: json[UserKeys.themeIndex],
      appLanguage: json[UserKeys.appLanguage],
      oneSignalPlayerId: json[UserKeys.oneSignalPlayerId],
      isAdmin: json[UserKeys.isAdmin],
      isTester: json[UserKeys.isTester],
      bookmarks: json[UserKeys.bookmarks] != null ? List<String>.from(json[UserKeys.bookmarks]) : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.image] = this.image;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isNotificationOn] = this.isNotificationOn;
    data[UserKeys.themeIndex] = this.themeIndex;
    data[UserKeys.appLanguage] = this.appLanguage;
    data[UserKeys.oneSignalPlayerId] = this.oneSignalPlayerId;
    data[UserKeys.bookmarks] = this.bookmarks;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.isTester] = this.isTester;
    return data;
  }
}
