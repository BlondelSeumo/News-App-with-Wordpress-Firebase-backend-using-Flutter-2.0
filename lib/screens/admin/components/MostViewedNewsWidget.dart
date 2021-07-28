import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/screens/admin/UploadNewsScreen.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class MostViewedNewsWidget extends StatelessWidget {
  static String tag = '/MostViewedNewsWidget';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsData>>(
      future: newsService.getMostViewedNewsFuture(limit: DocLimit),
      builder: (_, snap) {
        if (snap.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Most Viewed News', style: boldTextStyle(size: 24)),
                  //Text('View All', style: primaryTextStyle(size: 14)),
                ],
              ).paddingRight(8),
              Divider(color: colorPrimary, height: 30, thickness: 2).withWidth(100),
              ListView.builder(
                itemBuilder: (_, index) {
                  NewsData data = snap.data![index];

                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            cachedImage(data.image.validate(), fit: BoxFit.cover, height: 30, width: 60).cornerRadiusWithClipRRect(defaultRadius),
                            8.height,
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined, size: 18, color: textSecondaryColor),
                                4.width,
                                Text(data.postViewCount.validate().toString(), style: boldTextStyle(size: 20)),
                              ],
                            ),
                          ],
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.title!, style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                            4.height,
                            Text(data.shortContent!, style: secondaryTextStyle(size: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                            4.height,
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
                              ],
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                  ).onTap(() {
                    UploadNewsScreen(data: data).launch(context);
                  });
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data!.length,
              ),
            ],
          );
        }
        return snapWidgetHelper(snap);
      },
    );
  }
}
