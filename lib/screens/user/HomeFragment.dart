import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/models/DashboardResponse.dart';
import 'package:mighty_news_firebase/shimmer/HorizontalImageShimmer.dart';
import 'package:mighty_news_firebase/shimmer/VerticalTextImageShimmer.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'components/HeaderWidget.dart';
import 'components/UserDashboardWidget.dart';
import 'components/WeatherWidget.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
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
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          /// If you want to update app setting every time when you refresh home page
          /// Uncomment the below line
          appSettingService.setAppSettings();

          setState(() {});
          await 2.seconds.delay;
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: !getBoolAsync(DISABLE_LOCATION_WIDGET) ? 100 : 70,
                child: !getBoolAsync(DISABLE_LOCATION_WIDGET) ? WeatherWidget() : HeaderWidget(),
              ),
              FutureBuilder<DashboardResponse>(
                initialData: newsService.getCachedUserDashboardData(),
                future: newsService.getUserDashboardData(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return UserDashboardWidget(snap);
                  }
                  return snapWidgetHelper(
                    snap,
                    errorWidget: Container(
                      child: Text(errorSomethingWentWrong, style: primaryTextStyle()).paddingAll(16).center(),
                      height: context.height() - 180,
                      width: context.width(),
                    ),
                    loadingWidget: Column(
                      children: [
                        16.height,
                        HorizontalImageShimmer(),
                        16.height,
                        VerticalTextImageShimmer(),
                        16.height,
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
