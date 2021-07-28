import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  String? id;
  String? newsId;
  String? comment;
  String? userId;
  String? userName;
  DateTime? createdAt;
  DateTime? updatedAt;

  CommentData({
    this.id,
    this.newsId,
    this.comment,
    this.userId,
    this.userName,
    this.createdAt,
    this.updatedAt,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['id'],
      newsId: json['newsId'],
      comment: json['comment'],
      userId: json['userId'],
      userName: json['userName'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['newsId'] = this.newsId;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
