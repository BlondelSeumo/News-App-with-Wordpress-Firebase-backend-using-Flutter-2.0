import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/UserModel.dart';
import 'package:mighty_news_firebase/utils/Colors.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class RecentlyLoggedInUserWidget extends StatelessWidget {
  static String tag = '/RecentlyLoggedInUserWidget';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: userService.usersFuture(limit: DocLimit),
      builder: (_, snap) {
        if (snap.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recently Logged In Users', style: boldTextStyle(size: 24)),
                  //Text('View All', style: primaryTextStyle(size: 14)),
                ],
              ).paddingRight(8),
              Divider(color: colorPrimary, height: 30, thickness: 2).withWidth(100),
              ListView.builder(
                itemBuilder: (_, index) {
                  UserModel data = snap.data![index];

                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        data.image.validate().isNotEmpty ? cachedImage(data.image, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(30) : Icon(Feather.user, size: 40),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${data.name.validate()}', style: boldTextStyle()),
                                4.width,
                                Text('-', style: boldTextStyle()),
                                8.width,
                                Text('${data.updatedAt!.timeAgo}', style: primaryTextStyle()),
                              ],
                            ),
                            4.height.visible(appStore.isAdmin),
                            Text(data.email.validate(), style: secondaryTextStyle()).visible(appStore.isAdmin),
                          ],
                        ),
                      ],
                    ),
                  ).onTap(() {
                    //
                  });
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
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
