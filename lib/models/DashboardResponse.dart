import 'package:mighty_news_firebase/models/NewsData.dart';

class DashboardResponse {
  List<NewsData>? breakingNews;
  List<NewsData>? story;
  List<NewsData>? recentNews;

  DashboardResponse({this.breakingNews, this.story, this.recentNews});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      breakingNews: json['breakingNews'] != null ? (json['breakingNews'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      story: json['story'] != null ? (json['story'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      recentNews: json['recentNews'] != null ? (json['recentNews'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson({bool toStore = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.breakingNews != null) {
      data['breakingNews'] = this.breakingNews!.map((v) => v.toJson(toStore: toStore)).toList();
    }
    if (this.story != null) {
      data['story'] = this.story!.map((v) => v.toJson(toStore: toStore)).toList();
    }
    if (this.recentNews != null) {
      data['recentNews'] = this.recentNews!.map((v) => v.toJson(toStore: toStore)).toList();
    }
    return data;
  }
}
