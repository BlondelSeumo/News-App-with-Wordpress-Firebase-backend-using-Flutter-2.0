import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:mighty_news_firebase/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';

class AppDashboardConfigScreen extends StatefulWidget {
  static String tag = '/AppDashboardConfigScreen';

  @override
  _AppDashboardConfigScreenState createState() => _AppDashboardConfigScreenState();
}

class _AppDashboardConfigScreenState extends State<AppDashboardConfigScreen> {
  List<String> json = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loadJson();
  }

  Future<void> loadJson() async {
    Iterable? widgets = sharedPreferences.getStringList(DASHBOARD_WIDGET_ORDER);

    if (widgets.validate().isNotEmpty) {
      json.clear();
      json.addAll(widgets!.map((e) => e));
    }
    if (json.isEmpty) {
      String defaultOrder = await rootBundle.loadString('assets/dashboard.json');
      Iterable it = jsonDecode(defaultOrder);

      json.clear();
      json.addAll(it.map((e) => e));
    }

    setState(() {});
  }

  Widget getItemWidget(String e) {
    if (e == DashboardWidgetsBreakingNewsMarquee) {
      return Text('Breaking News Marquee', style: boldTextStyle());
    } else if (e == DashboardWidgetsStory) {
      return Text('Story View', style: boldTextStyle());
    } else if (e == DashboardWidgetsBreakingNews) {
      return Text('Breaking News', style: boldTextStyle());
    } else if (e == DashboardWidgetsQuickRead) {
      return Text('Quick Read', style: boldTextStyle());
    } else if (e == DashboardWidgetsRecentNews) {
      return Text('Recent News', style: boldTextStyle());
    } else {
      return SizedBox();
    }
  }

  Widget getPreviewWidget(String e) {
    if (e == DashboardWidgetsBreakingNewsMarquee) {
      return Image.asset('assets/config_breaking_marquee.jpg', fit: BoxFit.fitWidth, width: 300);
    } else if (e == DashboardWidgetsStory) {
      return Image.asset('assets/config_story_view.jpg', fit: BoxFit.fitWidth, width: 300);
    } else if (e == DashboardWidgetsBreakingNews) {
      return Image.asset('assets/config_breaking_news.jpg', fit: BoxFit.fitWidth, width: 300);
    } else if (e == DashboardWidgetsQuickRead) {
      return Image.asset('assets/config_quick_read.jpg', fit: BoxFit.fitWidth, width: 300);
    } else if (e == DashboardWidgetsRecentNews) {
      return Image.asset('assets/config_recent_news.jpg', fit: BoxFit.fitWidth, width: 300);
    } else {
      return SizedBox();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: appBarWidget('app_dashboard'.translate),
      body: Container(
        height: context.height(),
        width: context.width() * 0.8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableListView(
              children: json.map((e) => KeyedSubtree(child: getItemWidget(e).paddingAll(16), key: Key(e))).toList(),
              header: Text('settings_will_be_saved_automatically'.translate, style: secondaryTextStyle()).paddingAll(16),
              shrinkWrap: true,
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }

                String oldItem = json.removeAt(oldIndex);
                json.insert(newIndex, oldItem);

                setState(() {});
                if (appStore.isTester) return toast(mTesterNotAllowedMsg);

                appSettingService.updateDocument({AppSettingKeys.dashboardWidgetOrder: json}, appSettingService.id).then((value) {
                  toast('success_saved'.translate);

                  setValue(DASHBOARD_WIDGET_ORDER, json);
                });
              },
            ).expand(flex: 1),
            100.width,
            Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('user_dashboard_preview'.translate, style: secondaryTextStyle()),
                    16.height,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        borderRadius: radius(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: json.map((e) => KeyedSubtree(child: getPreviewWidget(e), key: Key(e))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ).expand(flex: 2),
          ],
        ),
      ).center(),
    );
  }
}
