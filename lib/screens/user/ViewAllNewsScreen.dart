import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/screens/user/NewsDetailScreen.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../main.dart';
import 'UserNewsItemWidget.dart';

class ViewAllNewsScreen extends StatefulWidget {
  static String tag = '/ViewAllNewsScreen';
  final String? title;
  final String? newsType;

  final String filterBy;
  final DocumentReference? categoryRef;

  ViewAllNewsScreen({this.title, this.newsType, this.filterBy = FilterByPost, this.categoryRef});

  @override
  _ViewAllNewsScreenState createState() => _ViewAllNewsScreenState();
}

class _ViewAllNewsScreenState extends State<ViewAllNewsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setDynamicStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.title.validate(), color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (index, context, documentSnapshot) {
            NewsData data = NewsData.fromJson(documentSnapshot.data() as Map<String, dynamic>);

            return UserNewsItemWidget(
              newsData: data,
              onTap: () {
                NewsDetailScreen(data: data).launch(context);
              },
            );
          },
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
          // orderBy is compulsory to enable pagination
          query: widget.filterBy == FilterByPost ? newsService.buildCommonQuery(newsType: widget.newsType) : newsService.buildNewsByCategoryQuery(widget.categoryRef),
          itemsPerPage: DocLimit,
          bottomLoader: Loader(),
          initialLoader: Loader(),
          emptyDisplay: noDataWidget(),
          onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
        ),
      ),
    );
  }
}
