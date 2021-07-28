import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';

class NewsData {
  String? id;
  String? title;
  String? content;
  String? shortContent;
  String? image;
  int? commentCount;
  String? newsStatus;
  int? postViewCount;
  String? sourceUrl;

  DateTime? createdAt;
  DateTime? updatedAt;

  String? newsType;

  bool? allowComments;

  DocumentReference? categoryRef;
  DocumentReference? authorRef;

  List<String>? caseSearch;

  NewsData({
    this.commentCount,
    this.content,
    this.shortContent,
    this.sourceUrl,
    this.createdAt,
    this.id,
    this.image,
    this.newsStatus,
    this.postViewCount,
    this.title,
    this.updatedAt,
    this.newsType,
    this.allowComments,
    this.categoryRef,
    this.authorRef,
    this.caseSearch,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      commentCount: json[NewsKeys.commentCount],
      shortContent: json[NewsKeys.shortContent],
      content: json[NewsKeys.content],
      id: json[CommonKeys.id],
      sourceUrl: json[NewsKeys.sourceUrl],
      image: json[NewsKeys.image],
      newsStatus: json[NewsKeys.newsStatus],
      postViewCount: json[NewsKeys.postViewCount],
      title: json[NewsKeys.title],
      newsType: json[NewsKeys.newsType],
      allowComments: json[NewsKeys.allowComments],
      caseSearch: json[NewsKeys.caseSearch] != null ? List<String>.from(json[NewsKeys.caseSearch]) : [],
      categoryRef: json[NewsKeys.categoryRef] != null ? (json[NewsKeys.categoryRef] as DocumentReference?) : null,
      authorRef: json[NewsKeys.authorRef] != null ? (json[NewsKeys.authorRef] as DocumentReference?) : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson({bool toStore = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[NewsKeys.commentCount] = this.commentCount;
    data[NewsKeys.content] = this.content;
    data[NewsKeys.shortContent] = this.shortContent;
    data[NewsKeys.image] = this.image;
    data[NewsKeys.newsStatus] = this.newsStatus;
    data[NewsKeys.postViewCount] = this.postViewCount;
    data[NewsKeys.sourceUrl] = this.sourceUrl;
    data[NewsKeys.title] = this.title;
    data[NewsKeys.newsType] = this.newsType;
    data[NewsKeys.allowComments] = this.allowComments;
    data[NewsKeys.caseSearch] = this.caseSearch;

    if (toStore) data[CommonKeys.createdAt] = this.createdAt;
    if (toStore) data[CommonKeys.updatedAt] = this.updatedAt;
    if (toStore) data[NewsKeys.categoryRef] = this.categoryRef;
    if (toStore) data[NewsKeys.authorRef] = this.authorRef;
    return data;
  }
}
