import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class NewsItemListWidget extends StatelessWidget {
  final NewsData data;

  NewsItemListWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: context.width(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cachedImage(data.image.validate(), fit: BoxFit.cover, height: 70, width: 100).cornerRadiusWithClipRRect(defaultRadius),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.1),
                          borderRadius: radius(),
                        ),
                        child: Text('${data.newsType.capitalizeFirstLetter()} ${'news'.translate}', maxLines: 1, style: boldTextStyle(size: 12)),
                      ),
                      8.width,
                      Text(parseHtmlString(data.title.validate()), maxLines: 2, style: boldTextStyle(size: 14), overflow: TextOverflow.ellipsis).expand(),
                    ],
                  ).expand(),
                  Text(data.newsStatus.capitalizeFirstLetter(), maxLines: 1, style: boldTextStyle(size: 12, color: getNewsStatusBgColor(data.newsStatus))),
                ],
              ),
              8.height,
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 18, color: textSecondaryColor),
                  4.width,
                  Text(data.updatedAt!.timeAgo, maxLines: 1, style: secondaryTextStyle(size: 12)),
                  4.width,
                  Text('・', style: secondaryTextStyle()),
                  4.width,
                  Text(
                    '${(parseHtmlString(data.content).calculateReadTime()).ceilToDouble().toInt()} ${'min_read'.translate}',
                    style: secondaryTextStyle(size: 12),
                  ),
                  8.width,
                  Text('・', style: secondaryTextStyle()),
                  8.width,
                  Icon(Icons.remove_red_eye_outlined, size: 18, color: textSecondaryColor),
                  4.width,
                  Text(data.postViewCount.validate().toString(), style: secondaryTextStyle()),
                ],
              ),
              8.height,
            ],
          ).expand(),
        ],
      ),
    );
  }
}
