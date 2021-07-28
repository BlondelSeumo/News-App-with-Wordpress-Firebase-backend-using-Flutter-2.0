import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/screens/admin/components/NewsItemListWidget.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../../main.dart';
import '../UploadNewsScreen.dart';

class AllNewsListWidget extends StatefulWidget {
  static String tag = '/AllNewsListWidget';

  @override
  AllNewsListWidgetState createState() => AllNewsListWidgetState();
}

class AllNewsListWidgetState extends State<AllNewsListWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, documentSnapshot) {
          NewsData data = NewsData.fromJson(documentSnapshot.data() as Map<String, dynamic>);

          return NewsItemListWidget(data: data).onTap(() {
            UploadNewsScreen(data: data).launch(context);
          });
        },
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        // orderBy is compulsory to enable pagination
        query: newsService.buildCommonQuery(),
        itemsPerPage: DocLimit,
        bottomLoader: Loader(),
        initialLoader: Loader(),
        emptyDisplay: noDataWidget(),
        onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
      ),
    );
  }
}
