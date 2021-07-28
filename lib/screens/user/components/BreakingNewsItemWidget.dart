import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class BreakingNewsItemWidget extends StatefulWidget {
  static String tag = '/BreakingNewsItemWidget';
  final NewsData newsData;
  final Function? onTap;

  BreakingNewsItemWidget(this.newsData, {this.onTap});

  @override
  BreakingNewsItemWidgetState createState() => BreakingNewsItemWidgetState();
}

class BreakingNewsItemWidgetState extends State<BreakingNewsItemWidget> {
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
      width: newsListWidgetSize(context),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: white.withOpacity(0.1), spreadRadius: 0.5, blurRadius: 1.0)],
        borderRadius: radius(),
      ),
      margin: EdgeInsets.all(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          cachedImage(widget.newsData.image.validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          Container(color: Colors.black38).cornerRadiusWithClipRRect(defaultRadius),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parseHtmlString(widget.newsData.title.validate()),
                maxLines: 2,
                style: boldTextStyle(size: 20, color: Colors.white, fontFamily: titleFont()),
              ),
              Text(
                parseHtmlString(widget.newsData.shortContent.validate()),
                maxLines: 4,
                style: primaryTextStyle(size: 10, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).paddingAll(8),
        ],
      ),
    ).onTap(() {
      widget.onTap?.call();
      // NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
    });
  }
}
