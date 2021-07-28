import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../CommentScreen.dart';

class NewsItemGridWidget extends StatefulWidget {
  static String tag = '/NewsItemGridWidget';
  final NewsData newsData;
  final Function? onTap;

  NewsItemGridWidget(this.newsData, {this.onTap});

  @override
  NewsItemGridWidgetState createState() => NewsItemGridWidgetState();
}

class NewsItemGridWidgetState extends State<NewsItemGridWidget> {
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
    String heroTag = '${widget.newsData.id}${currentTimeStamp()}';

    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  cachedImage(widget.newsData.image.validate(), fit: BoxFit.cover, height: 200).cornerRadiusWithClipRRect(defaultRadius),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: FutureBuilder<CategoryData>(
                      future: newsService.getNewsCategory(widget.newsData.categoryRef!),
                      builder: (_, snap) {
                        if (snap.hasData) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: radiusOnly(topLeft: defaultRadius, bottomRight: defaultRadius),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(snap.data!.name!, maxLines: 1, style: secondaryTextStyle(size: 12, color: Colors.blue)),
                          );
                        } else {
                          return Offstage();
                        }
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Text(parseHtmlString(widget.newsData.title.validate()), maxLines: 2, style: boldTextStyle(size: 14), overflow: TextOverflow.ellipsis),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18, color: textSecondaryColor),
                      4.width,
                      Text(widget.newsData.updatedAt!.timeAgo, maxLines: 1, style: secondaryTextStyle(size: 12)),
                      4.width,
                      Text('・', style: secondaryTextStyle()),
                      4.width,
                      Text(
                        '${(parseHtmlString(widget.newsData.content).calculateReadTime()).ceilToDouble().toInt()} ${'min_read'.translate}',
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: radius(),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FontAwesome.comment_o, size: 18),
                            8.width,
                            Text('comments'.translate, style: primaryTextStyle(size: 14)),
                          ],
                        ),
                      ).onTap(() {
                        CommentScreen(newsId: widget.newsData.id).launch(context);
                      }),
                    ],
                  ).visible(widget.newsData.allowComments.validate()),
                  8.height,
                  Container(
                    decoration: BoxDecoration(
                      color: getNewsStatusBgColor(widget.newsData.newsStatus).withOpacity(0.2),
                      border: Border.all(color: getNewsStatusBgColor(widget.newsData.newsStatus)),
                      borderRadius: radius(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      widget.newsData.newsStatus.capitalizeFirstLetter(),
                      style: boldTextStyle(color: getNewsStatusBgColor(widget.newsData.newsStatus), size: 12, letterSpacing: 1.3),
                    ),
                  ),
                  8.height,
                ],
              ).paddingAll(8),
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
