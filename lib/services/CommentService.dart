import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_news_firebase/models/CommentData.dart';

import '../main.dart';
import 'BaseService.dart';

class CommentService extends BaseService {
  CommentService(String? newsId) {
    ref = db.collection('news').doc(newsId).collection('comments');
  }

  Query commentQuery() {
    return ref!.orderBy('updatedAt', descending: true);
  }

  Stream<List<CommentData>> comments() {
    return commentQuery().snapshots().map((x) => x.docs.map((y) => CommentData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<List<CommentData>> commentsFuture() async {
    return await commentQuery().get().then((x) => x.docs.map((y) => CommentData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
