import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';

class NewsItemWidget extends StatefulWidget {
  static String tag = '/NewsItemWidget';
  final NewsData newsData;
  final Function? onTap;

  NewsItemWidget(this.newsData, {this.onTap});

  @override
  NewsItemWidgetState createState() => NewsItemWidgetState();
}

class NewsItemWidgetState extends State<NewsItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parseHtmlString(widget.newsData.post_title.validate()), maxLines: 2, style: boldTextStyle(size: 14), overflow: TextOverflow.ellipsis),
                  8.height,
                  Text(parseHtmlString(widget.newsData.post_content.validate()), maxLines: 2, style: primaryTextStyle(size: 12), overflow: TextOverflow.ellipsis),
                  8.height,
                  Align(
                    child: Text(widget.newsData.human_time_diff.validate(), maxLines: 1, style: secondaryTextStyle(size: 12)),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ).expand(),
              8.width,
              cachedImage(widget.newsData.image.validate(), width: 130, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
            ],
          ),
        ],
      ),
    ).onTap(() {
      widget.onTap?.call();
      // NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
    });
  }
}
