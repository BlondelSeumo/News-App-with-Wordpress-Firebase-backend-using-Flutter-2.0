import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/screens/admin/components/MostViewedNewsWidget.dart';
import 'package:mighty_news_firebase/screens/admin/components/RecentlyLoggedInUserWidget.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class AdminStatisticsWidget extends StatefulWidget {
  static String tag = '/AdminStatisticsWidget';

  @override
  _AdminStatisticsWidgetState createState() => _AdminStatisticsWidgetState();
}

class _AdminStatisticsWidgetState extends State<AdminStatisticsWidget> {
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
    Widget itemWidget(Color bgColor, Color textColor, String title, Widget desc, IconData icon, {Function? onTap}) {
      return Container(
        width: 300,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: radius(16),
          color: bgColor.withOpacity(0.5),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: textColor),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: primaryTextStyle(color: textColor)),
                desc,
                //Text(desc, style: boldTextStyle(size: 30, color: textColor)),
              ],
            ),
          ],
        ),
      ).onTap(onTap, borderRadius: radius(16));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //region Statistics
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              itemWidget(
                '#c9dcff'.toColor(),
                '#0047c9'.toColor(),
                'total_news'.translate,
                StreamBuilder<int>(
                  stream: newsService.getTotalNewsCount(),
                  builder: (_, snap) {
                    int? count = 0;
                    if (snap.hasError) log(snap.error);
                    if (snap.hasData) {
                      count = snap.data;
                    }
                    return Text(count.toString(), style: boldTextStyle(size: 30, color: '#0047c9'.toColor()));
                  },
                ),
                Feather.trending_up,
                onTap: () {
                  LiveStream().emit(StreamSelectItem, 2);
                },
              ),
              itemWidget(
                '#aafad7'.toColor(),
                '#099c5c'.toColor(),
                'total_categories'.translate,
                StreamBuilder<int>(
                  stream: categoryService.totalCategoriesCount(),
                  builder: (_, snap) {
                    int? count = 0;
                    if (snap.hasError) log(snap.error);
                    if (snap.hasData) {
                      count = snap.data;
                    }
                    return Text(count.toString(), style: boldTextStyle(size: 30, color: '#099c5c'.toColor()));
                  },
                ),
                Feather.trending_up,
                onTap: () {
                  LiveStream().emit(StreamSelectItem, 6);
                },
              ),
              itemWidget(
                '#ffb3c2'.toColor(),
                '#b30023'.toColor(),
                'total_users'.translate,
                StreamBuilder<int>(
                  stream: userService.totalUsersCount(),
                  builder: (_, snap) {
                    int? count = 0;
                    if (snap.hasError) log(snap.error);
                    if (snap.hasData) {
                      count = snap.data;
                    }
                    return Text(count.toString(), style: boldTextStyle(size: 30, color: '#b30023'.toColor()));
                  },
                ),
                Feather.users,
                onTap: () {
                  LiveStream().emit(StreamSelectItem, 8);
                },
              ),
            ],
          ),
          //endregion

          30.height,

          Responsive(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MostViewedNewsWidget(),
                16.height,
                RecentlyLoggedInUserWidget(),
              ],
            ),
            web: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MostViewedNewsWidget().expand(),
                16.width,
                RecentlyLoggedInUserWidget().expand(),
              ],
            ),
          ),

          ///Graph
          //Top most viewed post
          //New users in last 7 days
          //
        ],
      ),
    );
  }
}
