import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:nb_utils/nb_utils.dart';

import 'UserNewsListWidget.dart';

class AuthorNewsListScreen extends StatelessWidget {
  static String tag = '/AuthorNewsListScreen';
  final String title;
  final List<NewsData> news;

  AuthorNewsListScreen({required this.title, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title.validate()),
      body: SingleChildScrollView(child: UserNewsListWidget(list: news)),
    );
  }
}
