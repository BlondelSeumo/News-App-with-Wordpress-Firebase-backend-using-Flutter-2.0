import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'UserNewsListWidget.dart';

class BookmarkNewsScreen extends StatefulWidget {
  static String tag = '/BookmarkNewsScreen';

  @override
  _BookmarkNewsScreenState createState() => _BookmarkNewsScreenState();
}

class _BookmarkNewsScreenState extends State<BookmarkNewsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(StreamRefreshBookmark, (s) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(StreamRefreshBookmark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('bookmarks'.translate),
      body: FutureBuilder<List<NewsData>>(
        future: newsService.getBookmarkNewsFuture(),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) return noDataWidget();

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: UserNewsListWidget(list: snap.data),
            );
          } else {
            return snapWidgetHelper(snap);
          }
        },
      ),
    );
  }
}
