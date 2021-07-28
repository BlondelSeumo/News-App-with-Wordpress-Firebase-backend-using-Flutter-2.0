import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/models/DashboardResponse.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/models/UserModel.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'BaseService.dart';

class NewsService extends BaseService {
  NewsService() {
    ref = db.collection('news');
  }

  Future<DashboardResponse> getUserDashboardData() async {
    DashboardResponse dashboardResponse = DashboardResponse();

    dashboardResponse.breakingNews = await getNewsFuture(newsType: NewsTypeBreaking);
    dashboardResponse.story = await getNewsFuture(newsType: NewsTypeStory);
    dashboardResponse.recentNews = await getNewsFuture(newsType: NewsTypeRecent);

    setStringAsync(DASHBOARD_DATA, jsonEncode(dashboardResponse.toJson(toStore: false)));

    return dashboardResponse;
  }

  DashboardResponse? getCachedUserDashboardData() {
    String data = getStringAsync(DASHBOARD_DATA);

    if (data.isNotEmpty) {
      return DashboardResponse.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  Query buildCommonQuery({String? newsType = '', String? searchText}) {
    Query query;

    if (newsType == NewsTypeBreaking) {
      query = ref!.where(NewsKeys.newsType, isEqualTo: newsType).orderBy(CommonKeys.updatedAt, descending: true);
    } else if (newsType == NewsTypeStory) {
      query = ref!.where(NewsKeys.newsType, isEqualTo: newsType).where(CommonKeys.createdAt, isGreaterThan: DateTime.now().subtract(Duration(days: 1)));
    } else if (newsType == NewsTypeRecent) {
      query = ref!.where(NewsKeys.newsType, isEqualTo: newsType).orderBy(CommonKeys.updatedAt, descending: true);
    } else {
      query = ref!.where(NewsKeys.caseSearch, arrayContains: searchText).orderBy(CommonKeys.updatedAt, descending: true);
    }

    return query.where(NewsKeys.newsStatus, whereIn: appStore.isAdmin ? [NewsStatusPublished, NewsStatusUnpublished, NewsStatusDraft] : [NewsStatusPublished]);
  }

  Future<List<NewsData>> getNewsFuture({String newsType = '', String? searchText, int limit = DocLimit}) async {
    Query query;

    if (searchText.validate().isNotEmpty) {
      query = buildCommonQuery(newsType: newsType, searchText: searchText);
    } else {
      query = buildCommonQuery(newsType: newsType, searchText: searchText).limit(limit);
    }

    return await query.get().then((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<List<NewsData>> getMostViewedNewsFuture({int limit = DocLimit}) async {
    Query query = ref!.orderBy(NewsKeys.postViewCount, descending: true).limit(limit);

    return await query.get().then((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<NewsData>> getNews({String newsType = '', String? searchText}) {
    Query query;

    if (searchText.validate().isNotEmpty) {
      query = buildCommonQuery(newsType: newsType, searchText: searchText);
    } else {
      query = buildCommonQuery(newsType: newsType, searchText: searchText).limit(DocLimit);
    }

    return query.snapshots().map((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<int> getTotalNewsCount() {
    return ref!.snapshots().map((x) => x.docs.length);
  }

  Future<List<NewsData>> getBookmarkNewsFuture() async {
    if (bookmarkList.isNotEmpty) {
      Query query = ref!.where(CommonKeys.id, whereIn: bookmarkList).orderBy(CommonKeys.updatedAt, descending: true);

      return await query.get().then((x) {
        return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
      });
    } else {
      return [];
    }
  }

  Query buildNewsByCategoryQuery(DocumentReference? doc) {
    return ref!
        .where(NewsKeys.newsStatus, whereIn: appStore.isAdmin ? [NewsStatusPublished, NewsStatusUnpublished, NewsStatusDraft] : [NewsStatusPublished])
        .where(NewsKeys.categoryRef, isEqualTo: doc)
        .orderBy(CommonKeys.updatedAt, descending: true);
  }

  Future<List<NewsData>> getNewsByCategoryFuture(DocumentReference doc) async {
    Query query = buildNewsByCategoryQuery(doc);

    return await query.get().then((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<NewsData>> getNewsByCategory(DocumentReference? doc) {
    Query query = ref!
        .where(NewsKeys.newsStatus, whereIn: appStore.isAdmin ? [NewsStatusPublished, NewsStatusUnpublished, NewsStatusDraft] : [NewsStatusPublished])
        .where(NewsKeys.categoryRef, isEqualTo: doc)
        .orderBy(CommonKeys.updatedAt, descending: true);

    return query.snapshots().map((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<NewsData> newsDetail(String? id) async {
    return await ref!.doc(id).get().then((value) => NewsData.fromJson(value.data() as Map<String, dynamic>));
  }

  Future<List<NewsData>> relatedNewsFuture(DocumentReference? doc, String? newsId) async {
    Query query = ref!.where(NewsKeys.newsStatus, whereIn: appStore.isAdmin ? [NewsStatusPublished, NewsStatusUnpublished, NewsStatusDraft] : [NewsStatusPublished]).where(NewsKeys.categoryRef, isEqualTo: doc).limit(10);

    var data = await query.get().then((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });

    data.removeWhere((element) => element.id == newsId);

    return data;
  }

  Future<List<NewsData>> newsByAuthor(DocumentReference? doc) async {
    Query query = ref!.where(NewsKeys.authorRef, isEqualTo: doc);

    var data = await query.get().then((x) {
      return x.docs.map((y) => NewsData.fromJson(y.data() as Map<String, dynamic>)).toList();
    });

    return data;
  }

  Future<CategoryData> getNewsCategory(DocumentReference doc) async {
    return await doc.get().then((value) => CategoryData.fromJson(value.data() as Map<String, dynamic>));
  }

  Future<UserModel> getAuthor(DocumentReference doc) async {
    return await doc.get().then((value) => UserModel.fromJson(value.data() as Map<String, dynamic>));
  }

  Future<void> updatePostCount(String? id) async {
    await updateDocument({NewsKeys.postViewCount: FieldValue.increment(1)}, id);
  }
}
