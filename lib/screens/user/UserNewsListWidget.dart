import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NewsDetailListScreen.dart';
import 'UserNewsItemWidget.dart';

class UserNewsListWidget extends StatelessWidget {
  static String tag = '/UserNewsListWidget';
  final List<NewsData>? list;

  UserNewsListWidget({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return UserNewsItemWidget(
          newsData: list![index],
          onTap: () {
            NewsDetailListScreen(list, index: index).launch(context);
          },
        );
      },
      itemCount: list!.length,
      shrinkWrap: true,
    );
  }
}
